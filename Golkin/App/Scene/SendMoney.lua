local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.SendMoney : Tabullet.UIScene
---@field Layout Golkin.App.Layout.SendMoney
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.SendMoney
local SCENE = class("Golkin.App.Scene.SendMoney", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.SendMoney
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

end

return SCENE
