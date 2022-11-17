local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

---@class Tabullet.ProjTemplate.SCENENAME2_L : Tabullet.UILayout
local SCENE_L = class("Tabullet.ProjTemplate.SCENENAME2_L")

---constructor
---@param attachedScreen Tabullet.Screen
---@param ProjNamespace ProjTemplate
function SCENE_L:initialize(attachedScreen, ProjNamespace)
    THIS.UILayout.initialize(self, attachedScreen, ProjNamespace)

    ---@type Tabullet.Grid
    local grid = THIS.Grid:new(attachedScreen:getSize())
    grid:setHorizontalSetting({ "*", "10", "*", "10", "*", "10", "*" })
    grid:setVerticalSetting({ "*", "10", "*", "3", "*" })
    grid:updatePosLen()
    self.grid = grid

    ---@type Tabullet.Button
    local button2 = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "button2")
    button2:setText("prev scene")
    -- button2.ClickEvent = function() self:buttonClickEvent_prev() end
    button2:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    button2:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    button2.PosRel, button2.Len = grid:getPosLen(4, 4)
    self.button2 = button2

    ---@type Tabullet.Button
    local button3 = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen, "button3")
    button3:setText("next scene")
    -- button3.ClickEvent = function() self:buttonClickEvent_next() end
    button3:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    button3:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    button3.PosRel, button3.Len = grid:getPosLen(6, 4)
    self.button3 = button3

    ---@type Tabullet.Button
    local toggleButton = THIS.Button:new(self.rootScreenCanvas, self.attachingScreen, "togglebutton")
    toggleButton:setText("toggle!")
    -- toggleButton.ClickEvent = function() self:togglebuttonClickEvent() end
    toggleButton.BGPressed = THIS.Enums.Color.lightBlue
    toggleButton.FGPressed = THIS.Enums.Color.black
    toggleButton.IsToggleable = true
    toggleButton:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    toggleButton:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    toggleButton.PosRel, toggleButton.Len = grid:getPosLen(2, 4)
    self.toggleButton = toggleButton

    ---@type Tabullet.TextBlock
    local textblock = THIS.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "textblock")
    textblock:setText("toggle test!\ninit")
    textblock:setBorderColor(THIS.Enums.Color.blue)
    textblock:setBorderThickness(1)
    textblock:setMarginAll(2)
    textblock:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    textblock:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    textblock:setBackgroundColor(THIS.Enums.Color.gray)
    textblock:setTextColor(THIS.Enums.Color.white)
    textblock.PosRel, textblock.Len = grid:getPosLen(2, 2, 5, 1)
    self.testTextBlock = textblock

    ---@type Tabullet.TextBlock
    local textblock2 = THIS.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "textblock2")
    textblock2:setText("This is transparent background!! This is transparent background!! This is transparent background!! ")
    textblock2:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    textblock2:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.top)
    textblock2:setBackgroundColor(THIS.Enums.Color.None)
    textblock2:setTextColor(THIS.Enums.Color.purple)
    textblock2.PosRel, textblock2.Len = grid:getPosLen(5, 1, 1, 4)
    self.textblock2 = textblock2
end

return SCENE_L
