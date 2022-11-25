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
            self:cb_bt_numpad(10)
        end
    end

    self.Layout.bt_numpad_backspace.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_backspace()
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

    self.original_password = ""
    self.password = ""
    self.maximumCount = 8

    ---@enum Golkin.App.Scene.PinCheck.ePrevScene
    self.ePrevScene = {
        ["BioRegister"] = "BioRegister",
        ["ListRegister"] = "ListRegister",
    }
    ---@type Golkin.App.Scene.Pin.ePrevScene|nil
    self.CurrentPrevScene = nil
end

function SCENE:cb_bt_back()
    if self.CurrentPrevScene == self.ePrevScene.BioRegister then
        self:goto_Login_BioScan()
    elseif self.CurrentPrevScene == self.ePrevScene.ListRegister then
        self:goto_Login_List()
    else
        error("?? ePrevScene is broken")
    end
end

function SCENE:cb_bt_done()

    if self.original_password ~= self.password then
        self.Layout.tb_info:setText("Password is not same! try again")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        return nil
    end

    self.PROJ.Handle:attachMsgHandle(procotol.Header.ACK_REGISTER_OWNER, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
        self:cb_ack_register_owner(msg, msgstruct)
    end)

    -- self.PROJ.Client:send_OWNER_LOGIN()

end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
function SCENE:cb_ack_register_owner(msg, msgstruct)
    local replyEnum = procotol.Enum.ACK_REGISTER_OWNER_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.OWNER_ALREADY_EXISTS then
            self.Layout.tb_info:setText("OWNER_ALREADY_EXISTS")
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        end
    else
        self:cb_bt_back()
    end
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
    self.password = ""
    self:refresh_PINDisplay()
end

function SCENE:detachHandlers()

end

return SCENE
