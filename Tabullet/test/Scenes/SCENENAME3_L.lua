local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

---@class Tabullet.ProjTemplate.SCENENAME3_L : Tabullet.UILayout
local SCENE_L = class("Tabullet.ProjTemplate.SCENENAME2_L")

---constructor
---@param attachedScreen Tabullet.Screen
---@param ProjNamespace ProjTemplate
function SCENE_L:initialize(attachedScreen, ProjNamespace)
    THIS.UILayout.initialize(self, attachedScreen, ProjNamespace)

    ---@type Tabullet.Grid
    local grid = THIS.Grid:new(attachedScreen:getSize())
    grid:setHorizontalSetting({ "*", "10", "*", "10", "*", "10", "*" })
    grid:setVerticalSetting({ "*", "3", "*", "3", "*", "3", "*" })
    grid:updatePosLen()
    self.grid = grid

    --- prev scene button
    ---@type Tabullet.Button
    local button2 = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "button2")
    button2:setText("prev scene")
    -- button2.ClickEvent = function() self:buttonClickEvent_prev() end
    button2:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    button2:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    button2.PosRel, button2.Len = grid:getPosLen(4, 6)
    self.button2 = button2

    --- next scene button
    ---@type Tabullet.Button
    local button3 = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen, "button3")
    button3:setText("next scene")
    -- button3.ClickEvent = function() self:buttonClickEvent_next() end
    button3:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    button3:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    button3.PosRel, button3.Len = grid:getPosLen(6, 6)
    self.button3 = button3

    --- progress bar horizontal, with text
    ---@type Tabullet.ProgressBar
    local progressbar1 = THIS.ProgressBar:new(self.rootScreenCanvas, self.attachingScreen, "progressbar1")
    progressbar1:setValue(1.0)
    progressbar1.BarDirection = THIS.Enums.Direction.horizontal
    progressbar1.PosRel, progressbar1.Len = grid:getPosLenWithMargin(2, 2, 5, 1, 0, 0, 0, 0)
    self.progressbar1 = progressbar1

    --- progress bar vertiacl without text
    ---@type Tabullet.ProgressBar
    local progressbar2 = THIS.ProgressBar:new(self.rootScreenCanvas, self.attachingScreen, "progressbar1")
    progressbar2:setValue(1.0)
    progressbar2.BarDirection = THIS.Enums.Direction.vertical
    progressbar2.PosRel, progressbar2.Len = grid:getPosLenWithMargin(5, 1, 1, 5, 0, 0, 1, 1)
    progressbar2.BG = THIS.Enums.Color.None
    progressbar2.BarBG = THIS.Enums.Color.lime
    self.progressbar2 = progressbar2

    --- progress bar horizontal text block
    ---@type Tabullet.TextBlock
    local tx1 = THIS.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "progressbar1_text")
    tx1:setText("now loading... (" .. tostring(self.progressbar1:getValue() * 100) .. "%)")
    tx1:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    tx1:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    tx1.BG = THIS.Enums.Color.None
    tx1.FG = THIS.Enums.Color.lightGray
    tx1.PosRel, tx1.Len = grid:getPosLenWithMargin(2, 2, 5, 1, 0, 0, 0, 0)
    self.tx1 = tx1

    --- button for test value up 0.1
    ---@type Tabullet.Button
    local button_up = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen, "button_up")
    button_up:setText("->")
    -- button_up.ClickEvent = function() self:buttonClickEvent_up() end
    button_up:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    button_up:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    button_up.PosRel, button_up.Len = grid:getPosLen(2, 4)
    self.button_up = button_up

    --- button for test value down 0.1
    ---@type Tabullet.Button
    local button_down = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen, "button_down")
    button_down:setText("<-")
    -- button_down.ClickEvent = function() self:buttonClickEvent_down() end
    button_down:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    button_down:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    button_down.PosRel, button_down.Len = grid:getPosLen(2, 6)
    self.button_down = button_down
end

return SCENE_L
