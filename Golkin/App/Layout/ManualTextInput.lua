local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

--- manual text input class to use only in term devices.
--- does not work when used in monitor. be carefull.
---@class Golkin.App.Layout.ManualTextInput : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.ManualTextInput
local SCENE_L = class("Golkin.App.Layout.ManualTextInput", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    self:make_grid_main()
end

function SCENE_L:make_grid_main()
    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "1", "*", "1" })
    grid:setVerticalSetting({ "1", "1", "*", "3", "*" })
    grid:updatePosLen()

    local tb_title = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_title")
    tb_title:setText("Text Manual Input")
    grid:setPosLen(tb_title, 1, 1, 3, 1)
    self.PROJ.Style.TB.title(tb_title)
    self.tb_title = tb_title

    local tb_info = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_info")
    tb_info:setText("Wait for textblock to connect..")
    grid:setPosLen(tb_info, 1, 2, 3, 1)
    self.PROJ.Style.TB.Info(tb_info)
    self.tb_info = tb_info

    local tb_input = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_input")
    tb_input:setText("")
    tb_input:setMarginLeft(1)
    tb_input:setMarginRight(1)
    tb_input:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
    tb_input:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.center)
    tb_input:setIsTextEditable(false)
    grid:setPosLen(tb_input, 2, 4)
    self.tb_input = tb_input

    -- local grid_spec = grid:genSubGrid(nil, 1, 3, 3, 3)
    -- grid_spec
end

return SCENE_L
