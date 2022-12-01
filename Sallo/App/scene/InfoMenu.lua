local class = require("Class.middleclass")

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.InfoMenu : Tabullet.UIScene
---@field Layout Sallo.App.Layout.InfoMenu
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.InfoMenu
local SCENE = class("Sallo.App.Scene.InfoMenu", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.InfoMenu
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Addons()
        end
    end

end

function SCENE:goto_Addons()
    self:detach_handelers()
    self.PROJ.Scene.Addons:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Addons)
end

function SCENE:reset()
    self.Layout.tb_info:setText("Welcome Back! " .. self.PROJ.Data.CurrentOwner.Name)
end

function SCENE:detach_handelers()

end

return SCENE
