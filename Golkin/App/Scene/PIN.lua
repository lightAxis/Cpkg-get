local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.PIN : Tabullet.UIScene
---@field Layout Golkin.App.Layout.PIN
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.PIN
local SCENE = class("Golkin.App.Scene.PIN", TBL.UIScene)

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
            self:cb_bt_enterPIN()
        end
    end

    self.OwnerName = nil
    self.password = ""
    self.maximumCount = 8

    ---@enum Golkin.App.Scene.Pin.ePrevScene
    self.ePrevScene = {
        ["Bio"] = "Bio",
        ["BioRegister"] = "BioRegister",
        ["List"] = "List",
        ["ListRegister"] = "ListRegister",
    }
    ---@type Golkin.App.Scene.Pin.ePrevScene|nil
    self.CurrentPrevScene = nil
end

function SCENE:cb_bt_back()
    if (self.CurrentPrevScene == self.ePrevScene.Bio) or
        self.CurrentPrevScene == self.ePrevScene.BioRegister then
        self:goto_Login_BioScan()
    elseif self.CurrentPrevScene == self.ePrevScene.List or
        self.CurrentPrevScene == self.ePrevScene.ListRegister then
        self:goto_Login_List()
    else
        error("?? ePrevScene is broken")
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

function SCENE:goto_PINCheck()
    self:detachHandlers()
    self.PROJ.Scene.PINCheck:reset()
    self.PROJ.Scene.PINCheck.CurrentPrevScene = self.CurrentPrevScene
    self.PROJ.Scene.PINCheck.original_password = self.password
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PINCheck)
end

function SCENE:goto_OwnerMenu()
    self:detachHandlers()
    self.PROJ.Scene.OwnerMenu:reset()
end

function SCENE:cb_bt_enterPIN()
    if self.CurrentPrevScene == self.ePrevScene.Bio or
        self.CurrentPrevScene == self.ePrevScene.List then

        self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_OWNER_LOGIN, function(msg, msgstruct)
            ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
            self:cb_ack_owner_login(msg, msgstruct)
        end)
    else
        self:goto_PINCheck()
    end
end

---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
function SCENE:cb_ack_owner_login(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_OWNER_LOGIN_R
    if (msgstruct.Success == false) then
        if msgstruct.State == replyEnum.NO_OWNER_EXIST then
            self.Layout.tb_info:setText("NO_OWNER_EXIST")
        elseif msgstruct.State == replyEnum.PASSWORD_UNMET then
            self.Layout.tb_info:setText("PASSWORD_UNMET")
        else
            error("no error code met ")
        end
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self.PROJ.Scene.OwnerMenu.OwnerName = self.OwnerName
        self:goto_OwnerMenu()
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

    if self.CurrentPrevScene == self.ePrevScene.Bio or
        self.CurrentPrevScene == self.ePrevScene.List then
        self.Layout.tb_info:setText("Enter your PIN")
    else
        self.Layout.tb_info:setText("Enter new PIN")
    end
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
