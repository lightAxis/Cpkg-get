local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.OwnerMenu : Tabullet.UIScene
---@field Layout Golkin.App.Layout.OwnerMenu
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.OwnerMenu
local SCENE = class("Golkin.App.Scene.OwnerMenu", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.OwnerMenu
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

end

return SCENE
