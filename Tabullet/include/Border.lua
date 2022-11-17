---@module "Class.middleclass"
local class = require("Class.middleclass")

---include
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- [properties description]
---@class Tabullet.Border : Tabullet.UIElement
---@field BorderThickness number
---@field BorderColor Tabullet.Enums.Color
---@field new fun(self: Tabullet.Border, parent: Tabullet.UIElement, screen: Tabullet.Screen, name:string, BorderThickness?:number, BorderColor?:Tabullet.Enums.Color): Tabullet.Border


-- public class Border : UIElement
---
---**require** :
--- - Class.middleclass
--- - UI.UIElement
--- - UI.UITools
---@class Tabullet.Border : Tabullet.UIElement
local Border = class("Tabullet.Border", THIS.UIElement)

-- [constructor]

---constructor
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
---@param BorderThickness? number or 1
---@param BorderColor? Tabullet.Enums.Color or Enums.Color.gray
function Border:initialize(parent, screen, name, BorderThickness, BorderColor)
    if (parent == nil) then error("border must have a parent UIElement!") end
    THIS.UIElement.initialize(self, parent, screen, name)
    self.BorderThickness = BorderThickness or 1 -- thickness of border. must >= 1
    self.BorderColor = BorderColor or THIS.Enums.Color.gray -- color of border
end

-- [functions]

---draw border in screen
function Border:__drawBorder()
    -- get four anchor pos
    local pos_ = self.Pos:Copy()
    local pos_leftUP1 = pos_:Copy()
    local pos_leftUP2 = pos_:Copy()
    local pos_leftDown = THIS.UITools.calcRelativeOffset_Y(pos_leftUP1,
        self.Len.y)
    local pos_rightUp = THIS.UITools.calcRelativeOffset_X(pos_leftUP1,
        self.Len.x)

    -- draw lines
    for i = 1, self.BorderThickness, 1 do

        THIS.UITools.drawLine_x(self._screen, pos_leftUP1, self.Len.x,
            self.BorderColor)
        THIS.UITools.drawLine_y(self._screen, pos_leftUP2, self.Len.y,
            self.BorderColor)
        THIS.UITools.drawLine_x(self._screen, pos_leftDown, self.Len.x,
            self.BorderColor)
        THIS.UITools.drawLine_y(self._screen, pos_rightUp, self.Len.y,
            self.BorderColor)

        pos_leftUP1.y = pos_leftUP1.y + 1
        pos_leftUP2.x = pos_leftUP2.x + 1
        pos_leftDown.y = pos_leftDown.y - 1
        pos_rightUp.x = pos_rightUp.x - 1
    end
end

-- [overriding functions]

---overrided function from UIElement:render()
function Border:render() -- renderOffset)
    -- cannot change border PosRel
    self.PosRel.x = 1
    self.PosRel.y = 1

    -- update global pos
    self:_updatePos()

    -- update length from parent
    self:_updateLengthFromParent()

    -- draw actual lines
    self:__drawBorder()

    -- render history add
    self:_addThisToRenderHistory()

    -- render children
    self:renderChildren()

end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function Border:_ClickEvent(e) end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function Border:_ScrollEvent(e) end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function Border:_KeyInputEvent(e) end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function Border:_CharEvent(e) end

---overrided function from UIElement:PostRendering()
function Border:PostRendering() end

---overrided function from UIElement:FocusIn()
function Border:FocusIn() end

---overrided function from UIElement:FocusOut()
function Border:FocusOut() end

return Border
