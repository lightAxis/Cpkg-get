local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.RemoveAccount : Tabullet.UIScene
---@field Layout Golkin.App.Layout.RemoveAccount
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.RemoveAccount
local SCENE = class("Golkin.App.Scene.RemoveAccount", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.RemoveAccount
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_OwnerMenu()
        end
    end

    self.Layout.bt_remove.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_PIN()
        end
    end


    self.SelectedAccountName = ""
    self.SelectedAccountBalance = 0

end

function SCENE:goto_OwnerMenu()
    self:detachHandlers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

function SCENE:goto_PIN()
    self:detachHandlers()
    -- self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.RemoveAccount
    self.PROJ.Scene.PIN:reset()
    -- self.PROJ.Scene.PIN.AccountName = self.SelectedAccountName
    -- self.PROJ.Scene.PIN.OwnerName = self.PROJ.Data.CurrentOwner.Name
    local accountName = self.SelectedAccountName
    local ownername = self.PROJ.Data.CurrentOwner.Name

    self.PROJ.Scene.PIN:infoStr_normal("Enter your owner PIN")

    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        PIN:detachHandlers()
        self.PROJ.Scene.OwnerMenu:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
    end

    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_REMOVE_ACCOUNT, function(msg, msgstruct)
            ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT
            if msgstruct.Success == false then
                PIN:infoStr_error(protocol.Enum_INV.ACK_REMOVE_ACCOUNT_R_INV[msgstruct.State])
            else
                PIN:detachHandlers()
                self.PROJ.Scene.OwnerMenu:reset()
                self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
            end
            self.PROJ.UIRunner:ReDrawAll()
        end)
        self.PROJ.Client:send_REMOVE_ACCOUNT(accountName, PIN.password, ownername)
    end


    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:reset()
    self.Layout.tb_info:setText("Do you Really want to Remove this account?")
    self.PROJ.Style.TB.InfoWarning(self.Layout.tb_info)
    self.Layout.tb_removeacc_nameC:setText(self.SelectedAccountName)
    self.Layout.tb_balanceLeftC:setText(self.PROJ.Style.STR.Balance(tostring(self.SelectedAccountBalance)))
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
