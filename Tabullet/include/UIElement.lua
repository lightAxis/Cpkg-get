local class = require("Class.middleclass")

--- include
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- public class UIElement
---
---**require** :
--- - Class.middleclass
--- - MathLib.Vector2
--- - UI.Enums
--- - UI.UITools
--- - UI.UIEvent
---@class Tabullet.UIElement
--- TODO change to protected, Pos, Children, Name, Visible
--- TODO consider capsule Parent, Posrel, Len?
---@field _screen Tabullet.Screen
---@field Parent Tabullet.UIElement|nil
---@field PosRel MathLib.Vector2
---@field Pos MathLib.Vector2
---@field Len MathLib.Vector2
---@field BG Tabullet.Enums.Color
---@field FG Tabullet.Enums.Color
---@field Children table<number,Tabullet.UIElement>
---@field Name string
---@field Visible boolean
---@field ClickEvent nil|fun(self:Tabullet.UIElement, e:Tabullet.ClickEventArgs)
---@field KeyInputEvent nil|fun(self:Tabullet.UIElement, e:Tabullet.KeyInputEventArgs)
---@field CharEvent nil|fun(self:Tabullet.UIElement, e:Tabullet.CharEventArgs)
---@field ScrollEvent nil|fun(self:Tabullet.UIElement, e:Tabullet.ScrollEventArgs)
---@field new fun(self:Tabullet.UIElement ,parent: Tabullet.UIElement|nil, screen: Tabullet.Screen, name: string, x?: number, y?: number, xlen?: number, ylen?:number, bg?: Tabullet.Enums.Color, fg?:Tabullet.Enums.Color)
local UIElement = class("Tabullet.UIElement")

-- [constructor]

---constructor
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
---@param x? number or 1
---@param y? number or 1
---@param xlen? number or 1
---@param ylen? number or 1
---@param bg? Tabullet.Enums.Color or Enums.Color.black
---@param fg? Tabullet.Enums.Color or Enums.Color.white
function UIElement:initialize(parent, screen, name, x, y, xlen, ylen, bg, fg)
    if (screen == nil) then
        error("UIElement cannot be initialized without owner:screen")
    end
    -- private:
    self._screen = screen -- owner screen handle
    -- public:
    self.Parent = self:setParent(parent or nil)
    self.PosRel = Vector2:new(x or 1, y or 1) -- coordinate of Position Relavent to parent obj

    if (self.Parent == nil) then -- coordinate of Global position in screen
        self.Pos = self.PosRel
    else
        self.Pos = THIS.UITools.calcRelativeOffset(self.Parent.Pos, self.PosRel)
    end

    self.Len = Vector2:new(xlen or 1, ylen or 1) -- length of w,h
    self.BG = bg or THIS.Enums.Color.gray -- background color of element
    self.FG = fg or THIS.Enums.Color.white -- foregraoud color or element

    ---@type table<number,Tabullet.UIElement>
    self.Children = {}

    self.Name = name or ""

    self.Visible = true

    self.ClickEvent = nil
    self.KeyInputEvent = nil
    self.CharEvent = nil
    self.ScrollEvent = nil

end

-- [functions]

---set Parent of this element
---@param parent Tabullet.UIElement
function UIElement:setParent(parent)
    self.Parent = parent
    if (parent ~= nil) then table.insert(self.Parent.Children, self) end
    return parent
end

-- add Child element to this element
---@param child Tabullet.UIElement
function UIElement:addChild(child) table.insert(self.Children, child) end

-- call render callback of children
function UIElement:renderChildren()
    for index, value in ipairs(self.Children) do
        if (value.Visible == true) then value:render() end
    end
end

-- check if position is over element.
---@param checkpos MathLib.Vector2
function UIElement:isPositionOver(checkpos)
    return THIS.UITools.isInsideSquare(self.Pos, self.Len, checkpos)
end

-- check if position is over element. use only lua
---@param x number
---@param y number
function UIElement:isPositionOver_Raw(x, y)
    return UIElement:isPositionOver(Vector2:new(x, y))
end

-- update global Position of element based on Parent or nil
-- spread to childs
function UIElement:_updatePos()
    if (self.Parent == nil) then
        self.Pos = self.PosRel:Copy()
    else
        self.Pos = THIS.UITools.calcRelativeOffset(self.Parent.Pos, self.PosRel)
    end
    -- for key, child in pairs(self.Children) do child:_updatePos() end
end

-- update length sync with parent's Len
function UIElement:_updateLengthFromParent()
    self.Len.x = self.Parent.Len.x
    self.Len.x = math.max(1, self.Len.x)
    self.Len.y = self.Parent.Len.y
    self.Len.y = math.max(1, self.Len.y)
end

-- add this UIelement to RenderHistory of JLib.Screen class to use at UIInteraction system
function UIElement:_addThisToRenderHistory()
    table.insert(self._screen:getRenderHistory(), self)
end

-- trigger bubble down click event to element
---@param button Tabullet.Enums.MouseButton
---@param pos MathLib.Vector2
function UIElement:triggerClickEvent(button, pos)
    local e = THIS.UIEvent.ClickEventArgs:new(button, pos)
    self:_ClickEventBubbleDown(e)
end

-- click event bubble down function for UIElement
---@param e Tabullet.ClickEventArgs
function UIElement:_ClickEventBubbleDown(e)
    if (self.ClickEvent ~= nil) then
        self.ClickEvent(self, e)
    end
    if e.Handled == false then
        self:_ClickEvent(e)
    end
    if (e.Handled == false) then
        if (self.Parent ~= nil) then self.Parent:_ClickEventBubbleDown(e) end
    end
    return nil
end

-- scroll event function for UIElement
---@param direction Tabullet.Enums.ScrollDirection
---@param pos MathLib.Vector2
function UIElement:triggerScrollEvent(direction, pos)
    local e = THIS.UIEvent.ScrollEventArgs:new(direction, pos)
    self:_ScrollEventBubbleDown(e)
end

-- scroll event bubble down function for UIelemnt
---@param e Tabullet.ScrollEventArgs
function UIElement:_ScrollEventBubbleDown(e)
    if (self.ScrollEvent ~= nil) then
        self.ScrollEvent(self, e)
    end
    if e.Handled == false then
        self:_ScrollEvent(e)
    end
    if (e.Handled == false) then
        if (self.Parent ~= nil) then
            self.Parent:_ScrollEventBubbleDown(e)
        end
    end
    return nil
end

-- keyinput event function for UIElement
---@param key Tabullet.Enums.Key
function UIElement:triggerKeyInputEvent(key)
    local e = THIS.UIEvent.KeyInputEventArgs:new(key)
    self:_KeyInputBubbleDown(e)
end

-- keyinput bubble down event function for UIElement
---@param e Tabullet.KeyInputEventArgs
function UIElement:_KeyInputBubbleDown(e)
    if (self.KeyInputEvent ~= nil) then
        self.KeyInputEvent(self, e)
    end
    if (e.Handled == false) then
        self:_KeyInputEvent(e)
    end
    if (e.Handled == false) then
        if (self.Parent ~= nil) then self.Parent:_KeyInputBubbleDown(e) end
    end
    return nil
end

---char event function for UIElement
---@param char string
function UIElement:triggerCharEvent(char)
    local e = THIS.UIEvent.CharEventArgs:new(char)
    self:_CharBubbleDown(e)
end

---char event bubble down function for UIElement
---@param e Tabullet.CharEventArgs
function UIElement:_CharBubbleDown(e)
    if (self.CharEvent ~= nil) then
        self.CharEvent(self, e)
    end
    if (e.Handled == false) then
        self:_CharEvent(e)
    end
    if (e.Handled == false) then
        if (self.Parent ~= nil) then self.Parent:_CharBubbleDown(e) end
    end
    return nil
end

-- [abstract functions]

---abstract render function.
function UIElement:render()
    error("This is abstrct function! UIElement:render(pos)")
end

-- abstract Click Bubble down event function
---@param e Tabullet.ClickEventArgs
function UIElement:_ClickEvent(e)
    error("this is abstrcat function! UIElement:_ClickEvent(e)")
end

-- abstract Scroll Bubble down event function
---@param e Tabullet.ScrollEventArgs
function UIElement:_ScrollEvent(e)
    error("This is abstract function! UIelement:_ScrollEvent(e)")
end

-- abstract KeyInput bubble down event function
---@param e Tabullet.KeyInputEventArgs
function UIElement:_KeyInputEvent(e)
    error("This is abstract function!, UIElement:_KeyInputEvent(e)")
end

---abastract Char bubble down event function
---@param e Tabullet.CharEventArgs
function UIElement:_CharEvent(e)
    error("This is abstract function!, UIElement:_CharEvent(e)")
end

---abstract PostRendering function when being focused Element
function UIElement:PostRendering()
    error("this is abstrct function!, UIElement:PostRendering")
end

---abstract function when this element is focused in
function UIElement:FocusIn()
    error("this is abstract function!, UIElement:FocusIn()")
end

---abstract function when this element is focused out
function UIElement:FocusOut()
    error("this is abstract function!, UIElement:FocusOut()")
end

return UIElement
