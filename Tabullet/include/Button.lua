---@module 'Class.middleclass'
local class = require("Class.middleclass")

-- #includes
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

--- public class Button : TextBlock
---
---**require** :
--- - Class.middleclass
--- - JLib.UIElement
---@class Tabullet.Button : Tabullet.TextBlock
---@field IsToggleable boolean
---@field IsButtonPressed boolean
---@field BGPressed Tabullet.Enums.Color
---@field FGPressed Tabullet.Enums.Color
-- -@field _tempPressed boolean
-- -@field ClickEvent fun(Button): nil
---@field new fun(self:Tabullet.Button, parent: Tabullet.UIElement, screen: Tabullet.Screen, name: string, text?: string, PosRel?: MathLib.Vector2, Len?: MathLib.Vector2, bg?: Tabullet.Enums.Color, fg?: Tabullet.Enums.Color): Tabullet.Button
local Button = class("Tabullet.Button", THIS.TextBlock)

---constructor
function Button:initialize(parent, screen, name, text, PosRel, Len, bg, fg)
    THIS.TextBlock.initialize(self, parent, screen, name, text, PosRel, Len, bg,
        fg)

    self.IsToggleable = false
    self.IsButtonPressed = false

    self.BGUnpressed = self.BG
    self.FGUnpressed = self.FG
    self.BGPressed = THIS.Enums.Color.lightGray
    self.FGPressed = THIS.Enums.Color.black
    -- self._tempPressed = false

    -- self.ClickEvent = function(self) end // removed, because now UIElement itself support clickEvent function
end

-- functions

--- override functions

---@param color Tabullet.Enums.Color
function Button:setTextColor(color)
    self._TextArea.FG = color
    self.FG = color
    self.FGUnpressed = color
end

---@param color Tabullet.Enums.Color
function Button:setBackgroundColor(color)
    self.BG = color
    self._TextArea.BG = color
    self.BGUnpressed = color
end

---overrided from TextBlock
-- ---@param color Enums.Color
-- function Button:setBackgroundColor(color)
--     self.BG = color
--     self._TextArea.BG = color
-- end

---overrided function from UIElement:render()
function Button:render()
    -- update global pos
    self:_updatePos()

    -- if (self.IsButtonPressed == true) then
    --     self:setBackgroundColor(self.BGPressed)
    --     self:setTextColor(self.FGPressed)
    -- else
    --     self:setBackgroundColor(self.BGUnpressed)
    --     self:setTextColor(self.FGUnpressed)
    -- end

    -- change BG and FG state based on button pressed, toggle state
    self:_SetButtonBGFGState()

    -- fill inside the button with background color
    self:_fillWithBG()

    -- sync bg,fg of textarea same with button
    self._TextArea.BG = self.BG
    self._TextArea.FG = self.FG

    -- if (self._tempPressed) then
    --     self._tempPressed = false
    --     self.IsButtonPressed = false
    -- end
    -- render history check
    self:_addThisToRenderHistory()

    -- render children components
    self:renderChildren()

end

--- update the bg and fg based on ispressable & ispressed state
function Button:_SetButtonBGFGState()
    if (self.IsToggleable == true) then
        if (self.IsButtonPressed == true) then
            self.BG = self.BGPressed
            self.FG = self.FGPressed
        else
            self.BG = self.BGUnpressed
            self.FG = self.FGUnpressed
        end
    else
        self.BG = self.BGUnpressed
        self.FG = self.FGUnpressed
    end
end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function Button:_ClickEvent(e)
    if (self.IsToggleable) then
        if (not (self.IsButtonPressed)) then
            self.IsButtonPressed = true
        else
            self.IsButtonPressed = false
        end
    else
        self.IsButtonPressed = true
    end

    -- self.ClickEvent(self)

    e.Handled = true
end

-- ---overrided function from UIElement:_ScrollEvent
-- ---@param e ScrollEventArgs
-- function Button:_ScrollEvent(e)
--     e.Handled = true
--     self:setScroll(self:getScroll() + e.Direction)
-- end

-- ---overrided function from UIElement:_KeyInputEvent
-- ---@param e KeyInputEventArgs
-- function Button:_KeyInputEvent(e) end

-- ---overrided function from UIElement:_CharEvent
-- ---@param e CharEventArgs
-- function Button:_CharEvent(e) end

-- ---overrided function from UIElement:PostRendering()
-- function Button:PostRendering() end

-- ---overrided function from UIElement:FocusIn()
-- function Button:FocusIn() end

---overrided function from UIElement:FocusOut()
-- function Button:FocusOut()
--     if(not(self.IsToggleable)) then
--         if(self._tempPressed) then
--             self.BG = self.BGUnpressed
--             self._tempPressed = false
--             print(self.BG.."aa")
--         end
--     end
-- end

return Button
