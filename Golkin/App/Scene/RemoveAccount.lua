local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

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
    self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.RemoveAccount
    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN.AccountName = self.SelectedAccountName
    self.PROJ.Scene.PIN.OwnerName = self.PROJ.Data.CurrentOwner.Name
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
