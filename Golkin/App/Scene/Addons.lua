local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.Addons : Tabullet.UIScene
---@field Layout Golkin.App.Layout.Addons
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.Addons
local SCENE = class("Golkin.App.Scene.Addons", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.Addons
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_OwnerMenu()
        end
    end

end

function SCENE:goto_OwnerMenu()
    self:detach_handelers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

function SCENE:reset()

end

function SCENE:detach_handelers()

end

return SCENE
