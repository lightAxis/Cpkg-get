local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.Inspector : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.Inspector
local SCENE_L = class("Sallo.App.Layout.Inspector", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Sallo.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    ---@type table<number, Tabullet.UIElement>
    self.SelectionViewGroup = {}

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
    title_textblock:setText("Account Inspector")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Search & Inspect accounts")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    local bt_inspect = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_inspect")
    bt_inspect:setText("Inspect")
    grid:setPosLen(bt_inspect, 5, 4)
    self.PROJ.Style.BT.Good(bt_inspect)
    self.bt_inspect = bt_inspect
    table.insert(self.SelectionViewGroup, bt_inspect)

    self:make_grid_main(grid)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_main(grid_p)
    local grid_main = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_main:setHorizontalSetting({ "1", "*", "3", "*", "1" })
    grid_main:setVerticalSetting({ "1", "*", "1" })
    grid_main:updatePosLen()

    self:make_grid_left(grid_main)
    self:make_grid_right(grid_main)
end

---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_left(grid_p)
    local grid_left = grid_p:genSubGrid(nil, 2, 2)
    grid_left:setHorizontalSetting({ "*" })
    grid_left:setVerticalSetting({ "*", "1", "1", "*", "1", "1", "*", "1", "1", "*" })
    grid_left:updatePosLen()

    local tb_levelN, tb_levelC, tb_levelNL =
    self.PROJ.Style.make_infoPanel_pair("Level", self.rootScreenCanvas, self.attachingScreen)
    grid_left:setPosLen(tb_levelN, 1, 2)
    grid_left:setPosLen(tb_levelC, 1, 3)
    tb_levelN.Len.x = tb_levelNL
    table.insert(self.SelectionViewGroup, tb_levelN)
    table.insert(self.SelectionViewGroup, tb_levelC)
    self.tb_levelC = tb_levelC

    local tb_RankN, tb_RankC, tb_RankNL =
    self.PROJ.Style.make_infoPanel_pair("Rank", self.rootScreenCanvas, self.attachingScreen)
    grid_left:setPosLen(tb_RankN, 1, 5)
    grid_left:setPosLen(tb_RankC, 1, 6)
    tb_RankN.Len.x = tb_RankNL
    table.insert(self.SelectionViewGroup, tb_RankN)
    table.insert(self.SelectionViewGroup, tb_RankC)
    self.tb_RankC = tb_RankC

    local tb_ThemaN, tb_ThemaC, tb_ThemaNL =
    self.PROJ.Style.make_infoPanel_pair("Thema", self.rootScreenCanvas, self.attachingScreen)
    grid_left:setPosLen(tb_ThemaN, 1, 8)
    grid_left:setPosLen(tb_ThemaC, 1, 9)
    tb_ThemaN.Len.x = tb_ThemaNL
    table.insert(self.SelectionViewGroup, tb_ThemaN)
    table.insert(self.SelectionViewGroup, tb_ThemaC)
    self.tb_ThemaC = tb_ThemaC
end

---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_right(grid_p)
    local grid_right = grid_p:genSubGrid(nil, 4, 2)
    grid_right:setHorizontalSetting({ "*", "1", "1" })
    grid_right:setVerticalSetting({ "1", "*", "1", "1", "1", "*", "1" })
    grid_right:updatePosLen()

    local tb_listTitle = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_listTitle")
    tb_listTitle:setText("Infos")
    self.PROJ.Style.TB.ListTitle(tb_listTitle)
    grid_right:setPosLen(tb_listTitle, 1, 1, 3, 1)

    local lb_infoList = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_infoList")
    grid_right:setPosLen(lb_infoList, 1, 2, 3, 5)
    self.lb_infoList = lb_infoList

    local bt_arrow_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_up")
    bt_arrow_up:setText("^")
    grid_right:setPosLen(bt_arrow_up, 3, 3)
    self.PROJ.Style.BT.keypad(bt_arrow_up)
    self.bt_arrow_up = bt_arrow_up

    local bt_arrow_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_down")
    bt_arrow_down:setText("v")
    grid_right:setPosLen(bt_arrow_down, 3, 5)
    self.PROJ.Style.BT.keypad(bt_arrow_down)
    self.bt_arrow_down = bt_arrow_down
end

---@param bool boolean
function SCENE_L:control_selectionViewGroup(bool)
    for k, v in pairs(self.SelectionViewGroup) do
        v.Visible = bool
    end
end

---refresh layout by info struct
---@param info_t Sallo.Web.Protocol.Struct.info_t
function SCENE_L:refresh_infoPanels(info_t)
    self.tb_levelC:setText(string.format("%.0f", info_t.Main.Level))
    local rankStr = param.Rank[info_t.Main.Rank].rank_name
    self.tb_RankC:setText(rankStr)

    local themaStr = ""
    if param.Price.Thema[info_t.Thema] == nil then
        themaStr = "NO THEMA"
    else
        themaStr = param.Price.Thema[info_t.Thema].themaName
    end
    self.tb_ThemaC:setText(themaStr)
end

return SCENE_L
