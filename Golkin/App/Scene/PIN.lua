local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

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

end

return SCENE
