local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.ChangeThema : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.ChangeThema
local SCENE_L = class("Sallo.App.Layout.ChangeThema", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Sallo.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    self:make_grid()
end

function SCENE_L:make_grid()
    --- main grid
    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3" })
    grid:updatePosLen()
    self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Connect Wallet")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("There is no info for " .. "[testname]")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    local bt_apply = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_link")
    bt_apply:setText("Apply")
    grid:setPosLen(bt_apply, 5, 4)
    self.PROJ.Style.BT.Good(bt_apply)
    self.bt_apply = bt_apply

    self:make_grid_main(grid)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_main(grid_p)
    local grid_main = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_main:setHorizontalSetting({ "*", "5*", "2", "1", "2", "5*", "*" })
    grid_main:setVerticalSetting({ "*", "3", "1", "1", "*" })
    grid_main:updatePosLen()

    local tb_nameExample = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_nameExample")
    tb_nameExample:setText("TEST TEXT")
    self.PROJ.Style.TB.InfoWarning(tb_nameExample)
    grid_main:setPosLen(tb_nameExample, 2, 2, 5, 1)
    self.tb_nameExample = tb_nameExample

    local bt_arrow_left = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_left")
    bt_arrow_left:setText("<-")
    grid_main:setPosLen(bt_arrow_left, 3, 4)
    self.PROJ.Style.BT.keypad(bt_arrow_left)
    self.bt_arrow_left = bt_arrow_left

    local bt_arrow_right = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_right")
    bt_arrow_right:setText("->")
    grid_main:setPosLen(bt_arrow_right, 5, 4)
    self.PROJ.Style.BT.keypad(bt_arrow_right)
    self.bt_arrow_right = bt_arrow_right
end

---@param themaIdx Sallo.Web.Protocol.Enum.THEMA
function SCENE_L:show_thema(themaIdx)
    local BG = TBL.Enums.Color[param.Thema[themaIdx].BG]
    local FG = TBL.Enums.Color[param.Thema[themaIdx].FG]
    local Name = param.Thema[themaIdx].themaName

    self.tb_nameExample:setText(Name)
    self.tb_nameExample:setBackgroundColor(BG)
    self.tb_nameExample:setTextColor(FG)
end

return SCENE_L
