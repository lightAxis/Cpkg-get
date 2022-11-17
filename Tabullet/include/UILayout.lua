local class = require("Class.middleclass")

--- include
local THIS = PKGS.Tabullet

---properties description
---@class Tabullet.UILayout
---@field attachingScreen Tabullet.Screen
---@field PROJ table
---@field rootScreenCanvas Tabullet.ScreenCanvas
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:table):Tabullet.UILayout

---public class UIScene
---@class Tabullet.UILayout
local UILayout = class("Tabullet.UILayout")


function UILayout:initialize(attachedScreen, projNamespace)
    self.attachingScreen = attachedScreen
    self.PROJ = projNamespace
    self.rootScreenCanvas = THIS.ScreenCanvas:new(nil, attachedScreen, "rootScreenCanvas")
end

return UILayout
