local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local procotol = THIS.Web.Protocol

---@class Golkin.App.Scene.PINCheck : Tabullet.UIScene
---@field Layout Golkin.App.Layout.PIN
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.PINCheck
local SCENE = class("Golkin.App.Scene.PINCheck", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.PIN
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    for i = 1, 9, 1 do
        self.Layout.bts_numpad[i].ClickEvent = function(obj, e)
            if e.Button == TBL.Enums.MouseButton.left then
                self:cb_bt_numpad(i)
            end
        end
    end

    self.Layout.bts_numpad[10].ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_numpad(0)
        end
    end

    self.Layout.bt_numpad_backspace.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_backspace()
        end
    end

    self.Layout.bt_numpad_reset.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_numpad_reset()
        end
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_back()
        end
    end

    self.Layout.bt_enter_pin.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_done()
        end
    end

    self.OwnerName = ""
    self.AccountName = ""
    self.original_password = ""
    self.password = ""
    self.maximumCount = 8

    ---@enum Golkin.App.Scene.PinCheck.ePrevScene
    self.ePrevScene = {
        ["BioRegister"] = "BioRegister",
        ["ListRegister"] = "ListRegister",
        ["AccountRegister"] = "AccountRegister",
    }
    ---@type Golkin.App.Scene.PinCheck.ePrevScene|nil
    self.CurrentPrevScene = nil
end

function SCENE:goto_Login_BioScan()
    self:detachHandlers()
    self.PROJ.Scene.Login_BioScan:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
end

function SCENE:goto_Login_List()
    self:detachHandlers()
    self.PROJ.Scene.Login_List:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_List)
end

function SCENE:goto_OwnerMenu()
    self:detachHandlers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

function SCENE:cb_bt_back()
    if self.CurrentPrevScene == self.ePrevScene.BioRegister then
        self:goto_Login_BioScan()
    elseif self.CurrentPrevScene == self.ePrevScene.ListRegister then
        self:goto_Login_List()
    elseif self.CurrentPrevScene == self.ePrevScene.AccountRegister or
        self.CurrentPrevScene == self.ePrevScene.AccountRemove then
        self:goto_OwnerMenu()
    else
        error("cb_bt_back ?? ePrevScene is broken")
    end
end

function SCENE:cb_bt_done()
    if self.original_password ~= self.password then
        self.Layout.tb_info:setText("Password is not same! try again")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        self:cb_bt_numpad_reset()
        return nil
    end

    if self.CurrentPrevScene == self.ePrevScene.ListRegister or
        self.CurrentPrevScene == self.ePrevScene.BioRegister then
        self:requset_REGISTER_OWNER()
    elseif self.CurrentPrevScene == self.ePrevScene.AccountRegister then
        self:request_REGISTER_ACCOUNT()
    else
        error("cb_bt_done ?? ePrevScene is broken")
    end

end

function SCENE:requset_REGISTER_OWNER()
    self.PROJ.Handle:attachMsgHandle(procotol.Header.ACK_REGISTER_OWNER, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
        self:cb_ack_register_owner(msg, msgstruct)
    end)

    self.PROJ.Client:send_REGISTER_OWNER(self.OwnerName, self.password)
end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
function SCENE:cb_ack_register_owner(msg, msgstruct)
    local replyEnum = procotol.Enum.ACK_REGISTER_OWNER_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.OWNER_ALREADY_EXISTS then
            self.Layout.tb_info:setText("OWNER_ALREADY_EXISTS")
        else
            self.Layout.tb_info:setText("UNKNOWN_ERROR:" .. tostring(msgstruct.State))
        end
        self:cb_bt_numpad_reset()
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self:cb_bt_back()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:request_REGISTER_ACCOUNT()
    self.PROJ.Handle:attachMsgHandle(procotol.Header.ACK_REGISTER, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
        self:cb_ack_register_account(msg, msgstruct)
    end)

    self.PROJ.Client:send_REGISTER(self.AccountName, self.OwnerName, self.password)
end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
function SCENE:cb_ack_register_account(msg, msgstruct)
    local replyEnum = procotol.Enum.ACK_REGISTER_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.ACCOUNT_ALREADY_EXISTS then
            self.Layout.tb_info:setText("ACCOUNT_ALREADY_EXISTS")
        elseif msgstruct.State == replyEnum.ACCOUNT_OWNER_UNMET then
            self.Layout.tb_info:setText("ACCOUNT_OWNER_UNMET")
        end
        self:cb_bt_numpad_reset()
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self:cb_bt_back()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:cb_bt_numpad(number)
    if #self.password >= self.maximumCount then
        return nil
    else
        self.password = self.password .. tostring(number)
        self:refresh_PINDisplay()
    end
end

function SCENE:cb_bt_backspace()
    if #self.password <= 0 then
        return nil
    else
        self.password = self.password:sub(1, #self.password - 1)
        self:refresh_PINDisplay()
    end
end

function SCENE:cb_bt_numpad_reset()
    self.password = ""
    self:refresh_PINDisplay()
end

function SCENE:refresh_PINDisplay()
    local t = ""
    for i = 1, #self.password, 1 do
        t = t .. "* "
    end
    if #self.password >= 1 then
        t = t:sub(1, #t - 1)
    end
    self.Layout.tb_passwd_display:setText(t)

    if #self.password >= 0 and #self.password <= 3 then
        self.Layout.bt_enter_pin.Visible = false
    elseif #self.password >= 4 then
        self.Layout.bt_enter_pin.Visible = true
    end
end

function SCENE:reset()
    self.OwnerName = ""
    self.AccountName = ""
    self.password = ""
    self.original_password = ""
    self.Layout.tb_info:setText("repeat password again")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self:refresh_PINDisplay()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
