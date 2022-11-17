local class = require("Class.middleclass")

-- #includes
local Vector2 = DEPS.Tabullet.MathLib.Vector2
local THIS = PKGS.Tabullet

-- properties description
---@class Tabullet.Screen
---@field __screen any
---@field __side string
---@field IsMonitor boolean
---@field __renderHistory table<number, Tabullet.UIElement>
---@field __CursorPos MathLib.Vector2
---@field __BG Tabullet.Enums.Color
---@field __FG Tabullet.Enums.Color
---@field __ScreenSize MathLib.Vector2
---@field __screenBuffer table<number, table<number, Tabullet.Screen_t.Buffer>>
---@field new fun(self: Tabullet.Screen, screenObj: Tabullet.Screen, side: string): Tabullet.Screen

---public class Screen
---
---**require** :
--- - Class.middleclass
--- - MathLib.Vector2
---@class Tabullet.Screen
local Screen_CC = class("Tabullet.Screen")

-- [constructor]
---@param screenObj any -- computercraft screen obj
---@param side Tabullet.Enums.Side
function Screen_CC:initialize(screenObj, side)
    if (screenObj == nil) then
        error("screenObj cannot be nil! Screen_CC:initialize(screenObj, side)")
    end
    if (side == nil) then
        error("side cannot be nil! Screen_CC:initialize(screenObj, side)")
    end
    self.__screen = screenObj
    self.__side = side
    self.IsMonitor = self.__side ~= THIS.Enums.Side.NONE

    ---@type table<number, Tabullet.UIElement>
    self.__renderHistory = {}

    self.__CursorPos = Vector2:new(1, 1)
    self.__BG = THIS.Enums.Color.black
    self.__FG = THIS.Enums.Color.white
    self.__ScreenSize = self:getSize()

    self.__MAX_SCREEN_SIZE = Vector2:new(162, 80)

    -- ready Screen_t.Buffer table for maximum resolution in computercraft monitor
    ---@type table<number,table<number, Tabullet.Screen_t.Buffer>>
    self.__screenBuffer = {}
    local BGStr = THIS.Enums.Blit[THIS.Enums.Color.black]
    local FGStr = THIS.Enums.Blit[THIS.Enums.Color.white]
    for x = 1, self.__MAX_SCREEN_SIZE.x, 1 do
        self.__screenBuffer[x] = {}
        for y = 1, self.__MAX_SCREEN_SIZE.y, 1 do
            self.__screenBuffer[x][y] = THIS.ScreenBuffer_t:new(" ", FGStr, BGStr)
        end
    end

end

-- [functions]

---@return table<number, Tabullet.UIElement>
function Screen_CC:getRenderHistory() return self.__renderHistory end

-- Writes text to the screen, using the current text and background colors.
---@param text string
function Screen_CC:write(text)

    local y = self.__CursorPos.y
    if y < 1 then return nil
    elseif y > self.__ScreenSize.y then return nil
    end

    local len = #text
    local x_min = self.__CursorPos.x
    local _, x_max = THIS.UITools.Len2Pos_FromStart(x_min, len)

    if x_max < 1 then return nil
    elseif x_min > self.__ScreenSize.x then return nil
    end
    local x_min_ = THIS.UITools.constrain(x_min, 1, self.__ScreenSize.x)
    local x_max_ = THIS.UITools.constrain(x_max, 1, self.__ScreenSize.x)

    local strLenOffset = x_min - x_min_ + 1

    local BGStr = THIS.Enums.Blit[self.__BG]
    local FGStr = THIS.Enums.Blit[self.__FG]

    if (BGStr == THIS.Enums.Blit[THIS.Enums.Color.None]) then
        -- if transparent
        for x = x_min_, x_max_, 1 do
            local curChar = text:sub(strLenOffset, strLenOffset)
            if curChar ~= " " then
                self.__screenBuffer[x][y].Text = curChar
                self.__screenBuffer[x][y].FG = FGStr
            end
            strLenOffset = strLenOffset + 1

        end
    else
        -- if not transparent
        for x = x_min_, x_max_, 1 do
            self.__screenBuffer[x][y].Text = text:sub(strLenOffset, strLenOffset)
            self.__screenBuffer[x][y].BG = BGStr
            self.__screenBuffer[x][y].FG = FGStr
            strLenOffset = strLenOffset + 1
        end
    end

    self.__CursorPos.x = x_max_ + 1
    -- self._screen.write(text)
end

-- Writes text to the screen using the specified text and background colors. Requires version 1.74 or newer.
---@param text string
---@param fg string
---@param bg string
function Screen_CC:bilt(text, fg, bg)

    if #text ~= #fg or #fg ~= #bg then
        error("blit must have same length text:" + #text + "/fg:" + #fg + "/bg:" + #bg)
        return nil
    end

    local y = self.__CursorPos.y
    if y < 1 then return nil
    elseif y > self.__ScreenSize.y then return nil
    end

    local len = #text
    local x_min = self.__CursorPos.x
    local x_max = THIS.UITools.Len2Pos_FromStart(x_min, len)

    if x_max < 1 then return nil
    elseif x_min > self.__ScreenSize.x then return nil
    end
    local x_min_ = THIS.UITools.constrain(x_min, 1, self.__ScreenSize.x)
    local x_max_ = THIS.UITools.constrain(x_max, 1, self.__ScreenSize.x)

    local strLenOffset = x_min - x_min_ + 1
    for x = x_min_, x_max_, 1 do
        self.__screenBuffer[x][y].Text = text:sub(strLenOffset, 1)
        -- not transparent bg
        if (fg:sub(strLenOffset, 1) ~= THIS.Enums.Blit[THIS.Enums.Color.None]) then
            self.__screenBuffer[x][y].BG = fg:sub(strLenOffset, 1)
        end
        self.__screenBuffer[x][y].FG = bg:sub(strLenOffset, 1)
        strLenOffset = strLenOffset + 1
    end
    -- self._screen.bilt(text, fg, bg)

    self.__CursorPos.x = x_max_ + 1
end

-- Clears the entire screen.
function Screen_CC:clear()

    local FGStr = THIS.Enums.Blit[self.__FG]
    local BGStr = THIS.Enums.Blit[self.__BG]
    -- avoid transparent clear
    if (BGStr == THIS.Enums.Blit[THIS.Enums.Color.None]) then
        BGStr = THIS.Enums.Blit[THIS.Enums.Color.black]
    end

    for x = 1, self.__ScreenSize.x, 1 do
        for y = 1, self.__ScreenSize.y, 1 do
            self.__screenBuffer[x][y].Text = " "
            self.__screenBuffer[x][y].FG = FGStr
            self.__screenBuffer[x][y].BG = BGStr
        end
    end

    -- self._screen.clear()
    -- self._screen.clear()
end

-- Clears the line the cursor is on.
function Screen_CC:clearLine()
    local y = self.__CursorPos.y
    if y < 1 or y > self.__ScreenSize.y then return nil end

    local FGStr = THIS.Enums.Blit[self.__FG]
    local BGStr = THIS.Enums.Blit[self.__BG]

    -- avoid transparent bg
    if BGStr == THIS.Enums.Blit[THIS.Enums.Color.None] then
        BGStr = THIS.Enums.Blit[THIS.Enums.Color.black]
    end

    for x = 1, self.__ScreenSize.x, 1 do
        self.__screenBuffer[x][y].Text = " "
        self.__screenBuffer[x][y].FG = FGStr
        self.__screenBuffer[x][y].BG = BGStr
    end
    -- self._screen.clearLine()
end

-- Returns two arguments containing the x and the y position of the cursor.
---@return MathLib.Vector2
function Screen_CC:getCursorPos()
    local x, y = Screen_CC:getCursorPos_Raw()
    return Vector2:new(x, y)
end

-- Returns two arguments containing the x and the y position of the cursor. use only lua
---@return number, number
function Screen_CC:getCursorPos_Raw() return self.__screen.getCursorPos() end

-- Sets the cursor's position.
function Screen_CC:setCursorPos(pos)
    -- self._CursorPos = pos
    self:setCursorPos_Raw(pos.x, pos.y)
end

-- Sets the cursor's position. use only lua
-- change the real monitor cursor pos
function Screen_CC:setCursorPos_Raw(x, y)
    self.__CursorPos = Vector2:new(x, y)
    self.__screen.setCursorPos(x, y)
end

-- Disables the blinking or turns it on.
-- change the real monitor cursor blink
function Screen_CC:setCursorBlink(bool)
    self.__screen.setCursorBlink(bool)
end

-- Returns whether the terminal supports color.
-- get from real monitor
---@return boolean
function Screen_CC:isColor() return self.__screen.isColor() end

-- Returns two arguments containing the x and the y values stating the size of the screen.
---(Good for if you're making something to be compatible with both Turtles and Computers.)
---use only lua
---@return number, number
function Screen_CC:getSize_Raw()
    local x, y = self.__screen.getSize()

    -- if link with monitor lost, keep draw with screenbuffer
    if (x == nil) then
        return self.__ScreenSize.x, self.__ScreenSize.y
    else
        return self.__screen.getSize()
    end
end

-- Returns two arguments containing the x and the y values stating the size of the screen.
---(Good for if you're making something to be compatible with both Turtles and Computers.)
--- get size from real monitor
---@return MathLib.Vector2
function Screen_CC:getSize()
    local x, y = self:getSize_Raw()
    return Vector2:new(x, y)
end

-- Sets the text color of the terminal. Limited functionality without an Advanced machines.
---@param color Tabullet.Enums.Color
function Screen_CC:setTextColor(color)
    self.__FG = color
    -- self._screen.setTextColor(color)
end

-- Returns the current text color of the terminal. Requires version 1.74 or newer.
---@return Tabullet.Enums.Color
function Screen_CC:getTextColor() return self.__FG end

-- Sets the background color of the terminal. Limited functionality without an Advanced Computer / Turtle / Monitor.
---@param color Tabullet.Enums.Color
function Screen_CC:setBackgroundColor(color)
    self.__BG = color
    -- self._screen.setBackgroundColor(color)
end

-- Returns the current background color of the terminal. Requires version 1.74 or newer.
---@return Tabullet.Enums.Color
function Screen_CC:getBackgroundColor()
    return self.__BG
    -- return self._screen.getBackgroundColor()
end

-- Sets the text scale. Available only to monitor objects.
-- set the real monitor text scale and update the screen size immediately
---@param scale number
function Screen_CC:setTextScale(scale)
    self.__screen.setTextScale(scale)
    self.__ScreenSize = self:getSize()
end

-- [custom functions]

---add new render element to renderHistory
---@param element Tabullet.UIElement
function Screen_CC:addRenderElement(element)
    table.insert(self.__renderHistory, element)
end

---clear this screen
function Screen_CC:clearScreen()
    self:setBackgroundColor(THIS.Enums.Color.black)
    self:clear()

    self.__renderHistory = {}
end

function Screen_CC:clearRenderHistory() self.__renderHistory = {} end

---Get UIElement at position
---@param pos MathLib.Vector2
---@return Tabullet.UIElement|nil
function Screen_CC:getUIAtPos(pos)
    -- print(#(self._renderHistory), "aaaa")
    for i = #(self.__renderHistory), 1, -1 do
        if (self.__renderHistory[i]:isPositionOver(pos) == true) then
            return self.__renderHistory[i]
        end
    end
    -- print("aaaa2")
    return nil
end

---get screen side of this Screen module
---@return Tabullet.Enums.Side
function Screen_CC:getScreenSide() return self.__side end

---reflect screen buffer to action screen
function Screen_CC:reflect2Screen()
    self.__ScreenSize = self:getSize()

    local textStr = ""
    local fgStr = ""
    local bgStr = ""
    for y = 1, self.__ScreenSize.y, 1 do
        self.__screen.setCursorPos(1, y)

        textStr = ""
        fgStr = ""
        bgStr = ""
        for x = 1, self.__ScreenSize.x, 1 do
            textStr = textStr .. self.__screenBuffer[x][y].Text
            fgStr = fgStr .. self.__screenBuffer[x][y].FG
            bgStr = bgStr .. self.__screenBuffer[x][y].BG
        end

        self.__screen.blit(textStr, fgStr, bgStr)
    end

    self.__screen.setCursorPos(self.__CursorPos.x, self.__CursorPos.y)
end

return Screen_CC
