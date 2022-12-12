local class = require("Class.middleclass")

local TBL = DEPS.Sallo.Tabullet

local THIS = PKGS.Sallo
local protocol_sallo = THIS.Web.Protocol

---@class Sallo.App.Scene.TransferAccount : Tabullet.UIScene
---@field Layout Sallo.App.Layout.TransferAccount
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.TransferAccount
local SCENE = class("Sallo.App.Scene.TransferAccount", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.TransferAccount
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Addon()
        end
    end

    self.Layout.bt_register_with_golkin.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_PIN_ConnectAccount()
        end
    end

end

function SCENE:goto_Addon()
    self:detachHandlers()
    self.PROJ.Scene.Addons:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Addons)
end

function SCENE:goto_PIN_ConnectAccount()
    self:detachHandlers()

    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN:infoStr_normal("Enter your account PIN to continue")

    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        PIN:detachHandlers()
        self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
        self.PROJ.Sallo.Scene.TransferAccount:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.TransferAccount)
    end

    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
        self.PROJ.Sallo.Handle:attachMsgHandle(protocol_sallo.Header.ACK_REGISTER_INFO, function(msg, msgstruct)
            ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
            if msgstruct.Success == false then
                PIN:infoStr_error(protocol_sallo.Enum_INV.ACK_REGISTER_INFO_R_INV[msgstruct.State])
            else
                PIN:detachHandlers()
                self.PROJ.Sallo.Scene.InfoMenu:reset()
                self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
            end
            self.PROJ.UIRunner:ReDrawAll()
        end)

        self.PROJ.Sallo.Client:send_REGISTER_INFO(self.PROJ.Data.CurrentOwner.Name, PIN.password)
    end

    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:reset()
    self.Layout.tb_info:setText("There is no info for " .. self.PROJ.Data.CurrentOwner.Name)
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
