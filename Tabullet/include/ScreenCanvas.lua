local class = require("Class.middleclass")

--- include
local THIS = PKGS.Tabullet

-- properties description
---@class Tabullet.ScreenCanvas  : Tabullet.UIElement
---@field new fun(self:Tabullet.ScreenCanvas, parent: Tabullet.UIElement, screen: Tabullet.Screen, name: string): Tabullet.ScreenCanvas


-- public class ScreenCanvas : UIElement
---
---**require** :
--- - Class.middleclass
--- - UI.UIElement
---@class Tabullet.ScreenCanvas : Tabullet.UIElement
local ScreenCanvas = class("Tabullet.ScreenCanvas", THIS.UIElement)

-- [constructor]
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
function ScreenCanvas:initialize(parent, screen, name)
    THIS.UIElement.initialize(self, parent, screen, name)
    self:_updateLengthFromScreen()
end

-- functions

-- get length from screen and reset Len of current
function ScreenCanvas:_updateLengthFromScreen() self.Len =
    self._screen:getSize()
end

function ScreenCanvas:Reflect2Screen()
    self._screen:reflect2Screen()
end

-- [overrinding functions]

---overrided function from UIElement:render()
function ScreenCanvas:render()

    -- update canvas length from attached screen
    self:_updateLengthFromScreen()

    -- global position is always 1
    self.Pos.x = 1
    self.Pos.y = 1

    -- render history add
    self:_addThisToRenderHistory()

    -- render children
    self:renderChildren()
end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function ScreenCanvas:_ClickEvent(e) end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function ScreenCanvas:_ScrollEvent(e) end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function ScreenCanvas:_KeyInputEvent(e) end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function ScreenCanvas:_CharEvent(e) end

---overrided function from UIElement:PostRendering()
function ScreenCanvas:PostRendering() end

---overrided function from UIElement:FocusIn()
function ScreenCanvas:FocusIn() end

---overrided function from UIElement:FocusOut()
function ScreenCanvas:FocusOut() end

return ScreenCanvas
