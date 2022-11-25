local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.ManualTextInput : Tabullet.UIScene
---@field Layout Golkin.App.Layout.ManualTextInput
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.ManualTextInput
local SCENE = class("Golkin.App.Scene.ManualTextInput", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.ManualTextInput
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

end

function SCENE:reset()
    self.Layout.tb_input:setText("")
end

function SCENE:detachHandlers()

end

return SCENE
