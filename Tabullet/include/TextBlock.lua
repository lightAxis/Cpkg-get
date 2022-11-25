local class = require("Class.middleclass")

--- include
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- priperties description
---@class Tabullet.TextBlock : Tabullet.UIElement
---@field _Border Tabullet.Border
---@field _Margin Tabullet.Margin
---@field _TextArea Tabullet.TextArea
---@field new fun(self:Tabullet.TextBlock, parent: Tabullet.UIElement, screen: Tabullet.Screen, name: string, text?: string, PosRel?: MathLib.Vector2, Len?: MathLib.Vector2, bg?: Tabullet.Enums.Color, fg?: Tabullet.Enums.Color): Tabullet.TextBlock


-- public class TextBlock : UIElement
---
---**require** :
--- - Class.middleclass
--- - UI.UIElement
--- - UI.UITools
--- - UI.Border
--- - UI.Margin
--- - UI.TextArea
---@class Tabullet.TextBlock : Tabullet.UIElement
local TextBlock = class("Tabullet.TextBlock", THIS.UIElement)


-- constructor
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
---@param text? string or ""
---@param PosRel? MathLib.Vector2 or (1,1)
---@param Len? MathLib.Vector2 or (1,1)
---@param bg? Tabullet.Enums.Color or Enums.Color.gray
---@param fg? Tabullet.Enums.Color or Enums.Color.white
function TextBlock:initialize(parent, screen, name, text, PosRel, Len, bg, fg)
    local PosRel_ = PosRel or Vector2:new(1, 1)
    local Len_ = Len or Vector2:new(1, 1)
    local bg_ = bg or THIS.Enums.Color.gray
    local fg_ = fg or THIS.Enums.Color.white

    THIS.UIElement.initialize(self, parent, screen, name, PosRel_.x, PosRel_.y,
        Len_.x, Len_.y, bg_, fg_)


    ---@type Tabullet.Border
    self._Border = THIS.Border:new(self, screen, name .. "/Border")
    self._Border.BorderThickness = 0

    ---@type Tabullet.Margin
    self._Margin = THIS.Margin:new(self._Border, screen, name .. "/Margin")
    self._Margin:setMarginAll(0)

    ---@type Tabullet.TextArea
    self._TextArea = THIS.TextArea:new(self._Margin, screen,
        name .. "/TextArea", text or "")
    self._TextArea.BG = self.BG
    self._TextArea.FG = self.FG
end

-- functions

---get textarea object inside
---@return Tabullet.TextArea
function TextBlock:getTextArea()
    return self._TextArea
end

---@param thickness number
function TextBlock:setBorderThickness(thickness)
    self._Border.BorderThickness = thickness
end

---@param color Tabullet.Enums.Color
function TextBlock:setBorderColor(color) self._Border.BorderColor = color end

---@param color Tabullet.Enums.Color
function TextBlock:setBackgroundColor(color)
    self.BG = color
    self._TextArea.BG = color
end

---@param margin number
function TextBlock:setMarginAll(margin) self._Margin:setMarginAll(margin) end

---@param marginLeft number
function TextBlock:setMarginLeft(marginLeft) self._Margin.MarginLeft =
    marginLeft
end

---@param marginRight number
function TextBlock:setMarginRight(marginRight)
    self._Margin.MarginRight = marginRight
end

---@param marginTop number
function TextBlock:setMarginTop(marginTop) self._Margin.MarginTop = marginTop end

---@param marginBottom number
function TextBlock:setMarginBottom(marginBottom)
    self._Margin.MarginBottom = marginBottom
end

---get all four margins
---@return number left
---@return number right
---@return number top
---@return number bottom
function TextBlock:getMargin()
    return self._Margin.MarginLeft, self._Margin.MarginRight,
        self._Margin.MarginTop, self._Margin.MarginBottom
end

---@param align Tabullet.Enums.HorizontalAlignmentMode
function TextBlock:setTextHorizontalAlignment(align)
    self._TextArea:setHorizontalAlignment(align)
end

---@param align Tabullet.Enums.VerticalAlignmentMode
function TextBlock:setTextVerticalAlignment(align)
    self._TextArea:setVerticalAlignment(align)
end

---@param text string
function TextBlock:setText(text) self._TextArea:setText(text) end

---@return string text
function TextBlock:getText() return self._TextArea:getText() end

---@param color Tabullet.Enums.Color
function TextBlock:setTextColor(color)
    self._TextArea.FG = color
    self.FG = color
end

---@param scroll number
function TextBlock:setScroll(scroll) self._TextArea:setScroll(scroll) end

---@return number scrollIndex
function TextBlock:getScroll() return self._TextArea:getScroll() end

---@param bool boolean
function TextBlock:setIsTextEditable(bool) self._TextArea.IsTextEditable = bool end

--- fill textarea with current BG
function TextBlock:_fillWithBG()
    self._screen:setBackgroundColor(self.BG)

    local str = THIS.UITools.getEmptyString(self.Len.x)
    local renderPos = self.Pos:Copy()
    for i = 1, self.Len.y, 1 do
        self._screen:setCursorPos(renderPos)
        self._screen:write(str)
        renderPos.y = renderPos.y + 1
    end
end

-- override functions

---overrided function from UIElement:render()
function TextBlock:render()
    -- update global pos
    self:_updatePos()

    -- fill inside the textblock with background color
    self:_fillWithBG()

    -- sync bg of textarea same with textblock
    self._TextArea.BG = self.BG

    -- render history check
    self:_addThisToRenderHistory()

    -- render children components
    self:renderChildren()

end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function TextBlock:_ClickEvent(e) end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function TextBlock:_ScrollEvent(e)
    e.Handled = true
    self:setScroll(self:getScroll() + e.Direction)
end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function TextBlock:_KeyInputEvent(e) end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function TextBlock:_CharEvent(e) end

---overrided function from UIElement:PostRendering()
function TextBlock:PostRendering() end

---overrided function from UIElement:FocusIn()
function TextBlock:FocusIn() end

---overrided function from UIElement:FocusOut()
function TextBlock:FocusOut() end

return TextBlock
