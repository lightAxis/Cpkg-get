---@module 'Class.middleclass'
local class = require("Class.middleclass")

-- #includes
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- properties
---@class Tabullet.Margin : Tabullet.UIElement
---@field MarginLeft number
---@field MarginRight number
---@field MarginTop number
---@field MarginBottom number
---@field new fun(self: Tabullet.Margin, parent: Tabullet.UIElement, screen: Tabullet.Screen, name: string, marginLeft?: number, marginRight?: number,  marginTop?: number, marginBottom?: number) : Tabullet.Margin


---public class Margin : JLibElement
---
---**require** :
--- - Class.middleclass
--- - UI.UIElement
---@class Tabullet.Margin : Tabullet.UIElement
local Margin = class("Tabullet.Margin", THIS.UIElement)

---constructor
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
---@param marginLeft? number or 0
---@param marginRight? number or 0
---@param marginTop? number or 0
---@param marginBottom? number or 0
function Margin:initialize(parent, screen, name, marginLeft, marginRight,
                           marginTop, marginBottom)
    if (parent == nil) then
        error("Margin class must have a parent UIElement!")
    end
    THIS.UIElement.initialize(self, parent, screen, name)
    self.MarginLeft = marginLeft or 0
    self.MarginRight = marginRight or 0
    self.MarginTop = marginTop or 0
    self.MarginBottom = marginBottom or 0

end

-- functions

---sell all 4 margin
---@param margin number
function Margin:setMarginAll(margin)
    self.MarginLeft = margin;
    self.MarginRight = margin;
    self.MarginTop = margin;
    self.MarginBottom = margin;
end

-- overriding functions

---overrided function from UIElement:render()
function Margin:render()
    -- update self length from parent and margin
    self:_updateLengthFromParent()

    -- update self PosRel from margin
    self:_updatePosRelFromMargin()

    -- update global position
    self:_updatePos()

    -- render history add
    self:_addThisToRenderHistory()

    -- render children
    self:renderChildren()

end

---overrided function from UIElement:_updateLengthFromParent()
function Margin:_updateLengthFromParent()
    self.Len.x = self.Parent.Len.x - self.MarginLeft - self.MarginRight
    self.Len.x = math.max(1, self.Len.x)
    self.Len.y = self.Parent.Len.y - self.MarginTop - self.MarginBottom
    self.Len.y = math.max(1, self.Len.y)
end

--- update position relevant to parent, using margin properties
function Margin:_updatePosRelFromMargin()
    self.PosRel.x = self.MarginLeft + 1
    self.PosRel.y = self.MarginTop + 1
end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function Margin:_ClickEvent(e) end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function Margin:_ScrollEvent(e) end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function Margin:_KeyInputEvent(e) end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function Margin:_CharEvent(e) end

---overrided function from UIElement:PostRendering()
function Margin:PostRendering() end

---overrided function from UIElement:FocusIn()
function Margin:FocusIn() end

---overrided function from UIElement:FocusOut()
function Margin:FocusOut() end

return Margin
