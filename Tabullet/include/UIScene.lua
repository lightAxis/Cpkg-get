local class = require("Class.middleclass")

---properties description
---@class Tabullet.UIScene
---@field PROJ table
---@field Layout Tabullet.UILayout
--@field Layout UILayout
---@field new fun(self:Tabullet.UIScene, projNamespace:table, UILayout:Tabullet.UILayout):Tabullet.UIScene

---public class UIScene
---@class Tabullet.UIScene
local UIScene = class("Tabullet.UIScene")

---constructor
---@param projNamespace table
---@param UILayout Tabullet.UILayout
function UIScene:initialize(projNamespace, UILayout)
    self.PROJ = projNamespace
    self.Layout = UILayout

end

return UIScene
