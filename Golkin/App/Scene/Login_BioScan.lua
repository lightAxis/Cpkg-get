local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.Login_BioScan : Tabullet.UIScene
---@field Layout Golkin.App.Layout.Login_BioScan
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.Login_BioScan
local SCENE = class("Golkin.App.Scene.Login_BioScan", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.Login_BioScan
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

end

---comment
function SCENE:reset()
end

return SCENE
