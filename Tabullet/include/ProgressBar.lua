---@module "Class.middleclass"
local class = require("Class.middleclass")

---#includes
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- [properties description]

---@class Tabullet.ProgressBar : Tabullet.UIElement
---@field BarBG Tabullet.Enums.Color
---@field __value number
---@field new fun(self:Tabullet.ProgressBar, parent: Tabullet.UIElement, screen: Tabullet.Screen, name:string, dir?:Tabullet.Enums.Direction, BarBG?: Tabullet.Enums.Color):Tabullet.ProgressBar


-- public class ProgressBar : UIElement
---
---**require**
--- - Class.middleclass
--- - UI.UIElement
--- - UI.UITools
---@class Tabullet.ProgressBar : Tabullet.UIElement
local ProgressBar = class("ProgressBar", THIS.UIElement)

-- [constructor]

---comment
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
---@param BarBG? Tabullet.Enums.Color default:cyan
---@param dir? Tabullet.Enums.Direction default:horizontal
function ProgressBar:initialize(parent, screen, name, dir, BarBG)
    if (parent == nil) then error("ProgressBar must have a parent UIElement!") end
    THIS.UIElement.initialize(self, parent, screen, name)

    self.BarBG = BarBG or THIS.Enums.Color.cyan
    self.BarDirection = dir or THIS.Enums.Direction.horizontal
    self.IsBGTransparent = false

    ---@type number
    self.__value = 0
end

---set value of progressbar
---@param value number 0<=value<=1
function ProgressBar:setValue(value)
    value = THIS.UITools.constrain(value, 0.0, 1.0);
    self.__value = value
end

---get value of progressBar
---@return number value
function ProgressBar:getValue()
    return self.__value
end

function ProgressBar:__drawBar()
    local totalLen = 0
    if self.BarDirection == THIS.Enums.Direction.horizontal then
        totalLen = self.Len.x
    elseif self.BarDirection == THIS.Enums.Direction.vertical then
        totalLen = self.Len.y
    else
        totalLen = self.Len.x
    end

    local targetLen = math.floor(totalLen * self.__value + 0.001)
    local restLen = totalLen - targetLen


    if self.BarDirection == THIS.Enums.Direction.horizontal then

        local tempPos = self.Pos:Copy()
        local _, endY = THIS.UITools.Len2Pos_FromStart(self.Pos.y, self.Len.y)

        for y = self.Pos.y, endY, 1 do
            tempPos.y = y
            self._screen:setCursorPos(tempPos)
            self._screen:setBackgroundColor(self.BarBG)
            self._screen:write(THIS.UITools.getEmptyString(targetLen))
            self._screen:setBackgroundColor(self.BG)
            self._screen:write(THIS.UITools.getEmptyString(restLen))
        end

    elseif self.BarDirection == THIS.Enums.Direction.vertical then
        local tempPos = self.Pos:Copy()
        local _, restY = THIS.UITools.Len2Pos_FromStart(self.Pos.y, restLen)
        local _, endY = THIS.UITools.Len2Pos_FromStart(self.Pos.y, self.Len.y)

        if restLen > 0 then
            self._screen:setBackgroundColor(self.BG)
            for y = tempPos.y, restY, 1 do
                tempPos.y = y
                self._screen:setCursorPos(tempPos)
                self._screen:write(THIS.UITools.getEmptyString(self.Len.x))
            end
            tempPos.y = tempPos.y + 1
        end

        self._screen:setBackgroundColor(self.BarBG)
        for y = tempPos.y, endY, 1 do
            tempPos.y = y
            self._screen:setCursorPos(tempPos)
            self._screen:write(THIS.UITools.getEmptyString(self.Len.x))
        end
    end

    return 0

end

-- [overriding functions]

---overrided function from UIElement:render()
function ProgressBar:render() -- renderOffset)

    -- update global pos
    self:_updatePos()

    -- draw actual lines
    self:__drawBar()

    -- render history add
    self:_addThisToRenderHistory()

    -- render children
    self:renderChildren()

end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function ProgressBar:_ClickEvent(e) end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function ProgressBar:_ScrollEvent(e) end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function ProgressBar:_KeyInputEvent(e) end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function ProgressBar:_CharEvent(e) end

---overrided function from UIElement:PostRendering()
function ProgressBar:PostRendering() end

---overrided function from UIElement:FocusIn()
function ProgressBar:FocusIn() end

---overrided function from UIElement:FocusOut()
function ProgressBar:FocusOut() end

return ProgressBar
