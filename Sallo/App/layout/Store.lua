local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.Store : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.Store
local SCENE_L = class("Sallo.App.Layout.Store", TBL.UILayout)

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
    title_textblock:setText("Store")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Anything to buy?")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    local bt_buy = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_link")
    bt_buy:setText("Buy")
    grid:setPosLen(bt_buy, 5, 4)
    self.PROJ.Style.BT.Good(bt_buy)
    self.bt_buy = bt_buy

    self:make_grid_main(grid)

end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_main(grid_p)
    local grid_main = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_main:setHorizontalSetting({ "1", "*", "3", "*", "1" })
    grid_main:setVerticalSetting({ "1", "*", "1" })
    grid_main:updatePosLen()
    self:make_grid_itemList(grid_main)
    self:make_grid_itemSpec(grid_main)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_itemList(grid_p)
    local grid_itemList = grid_p:genSubGrid(nil, 2, 2)
    grid_itemList:setHorizontalSetting({ "*", "1", "1" })
    grid_itemList:setVerticalSetting({ "1", "1", "4*", "1", "1", "1", "4*", "*" })
    grid_itemList:updatePosLen()

    local bt_refresh_list = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refreshList")
    bt_refresh_list:setText("Refresh")
    self.PROJ.Style.BT.func(bt_refresh_list)
    grid_itemList:setPosLen(bt_refresh_list, 1, 1)
    self.bt_refresh_list = bt_refresh_list

    local lb_items = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_items")
    grid_itemList:setPosLen(lb_items, 1, 3, 1, 5)
    self.lb_items = lb_items

    local bt_arrow_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_up")
    bt_arrow_up:setText("^")
    self.PROJ.Style.BT.keypad(bt_arrow_up)
    grid_itemList:setPosLen(bt_arrow_up, 3, 4)
    self.bt_arrow_up = bt_arrow_up

    local bt_arrow_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_down")
    bt_arrow_down:setText("v")
    self.PROJ.Style.BT.keypad(bt_arrow_down)
    grid_itemList:setPosLen(bt_arrow_down, 3, 6)
    self.bt_arrow_down = bt_arrow_down
end

---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_itemSpec(grid_p)
    local grid_itemSpec = grid_p:genSubGrid(nil, 4, 2)
    grid_itemSpec:setHorizontalSetting({ "*" })
    grid_itemSpec:setVerticalSetting({ "1", "1", "4*", "3", "4*", "*" })
    grid_itemSpec:updatePosLen()

    local tb_itemNameN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_itemNameN")
    tb_itemNameN:setText("testText")
    tb_itemNameN:setMarginLeft(1)
    tb_itemNameN:setMarginRight(1)
    self.PROJ.Style.TB.infoName(tb_itemNameN)
    grid_itemSpec:setPosLen(tb_itemNameN, 1, 1)
    self.tb_itemNameN = tb_itemNameN

    local tb_itemPriceN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_itemPriceN")
    tb_itemPriceN:setText("243434")
    self.PROJ.Style.TB.ListTitle(tb_itemPriceN)
    grid_itemSpec:setPosLen(tb_itemPriceN, 1, 2)
    self.tb_itemPriceN = tb_itemPriceN

    local tb_itemDetailC = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_itemDetailC")
    tb_itemDetailC:setText("this is test!\n\n details; \b reqs \n sdf")
    self.PROJ.Style.TB.infoContent(tb_itemDetailC)
    tb_itemDetailC:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.left)
    tb_itemDetailC:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.top)
    tb_itemDetailC:setMarginAll(1)
    grid_itemSpec:setPosLen(tb_itemDetailC, 1, 3, 1, 3)
    self.tb_itemDetailC = tb_itemDetailC

end

---set item name display
---@param string string
function SCENE_L:setItemName(string)
    self.tb_itemNameN:setText(string)
    self.tb_itemNameN.Len.x = #string + 2
end

function SCENE_L:setItemPrice(number)
    self.tb_itemPriceN:setText(self.PROJ.Style.STR.Balance(string.format("%2.f", number)))
end

---@param bool boolean
function SCENE_L:itemDetail_control(bool)
    self.tb_itemDetailC.Visible = bool
    self.tb_itemNameN.Visible = bool
    self.tb_itemPriceN.Visible = bool
end

return SCENE_L
