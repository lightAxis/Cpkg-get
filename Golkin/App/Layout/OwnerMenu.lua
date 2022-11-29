local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.OwnerMenu : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.OwnerMenu
local SCENE_L = class("Golkin.App.Layout.OwnerMenu", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    ---@type table<number, Tabullet.UIElement>
    self.__AccountPanelGroup = {}

    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3" })
    grid:updatePosLen()
    self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Welcome back, " .. "testName" .. "!")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Select your name")
    self.PROJ.Style.TB.Info(info_tb)
    info_tb.Visible = true
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    --- bt refresh names
    local bt_see_histories = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_list")
    bt_see_histories:setText("Account Inquirey")
    grid:setPosLen(bt_see_histories, 3, 4)
    self.PROJ.Style.BT.func(bt_see_histories)
    self.bt_see_histories = bt_see_histories

    --- bt sign in
    local bt_sendMoney = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_sendMoney")
    bt_sendMoney:setText("Send Money")
    grid:setPosLen(bt_sendMoney, 5, 4)
    self.PROJ.Style.BT.func(bt_sendMoney)
    self.bt_sendMoney = bt_sendMoney

    self:add_grid_refresh(grid)

    self:add_grid_mainFrame(grid)

    self:make_menu()
end

---add refresh button with grid
---@param grid_p Tabullet.Grid
function SCENE_L:add_grid_refresh(grid_p)
    -- make grid
    local grid_refresh = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_refresh:setHorizontalSetting({ "*", "11" })
    grid_refresh:setVerticalSetting({ "1", "*" })
    grid_refresh:updatePosLen()
    self.grid_refresh = grid_refresh

    -- refresh button
    local bt_refresh = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh")
    grid_refresh:setPosLen(bt_refresh, 2, 1)
    bt_refresh:setText("Refresh")
    self.PROJ.Style.BT.ImportantFunc(bt_refresh)
    self.bt_refresh = bt_refresh
end

---add grid with arrows
---@param grid_p Tabullet.Grid
function SCENE_L:add_grid_mainFrame(grid_p)
    -- make grid
    local grid_mainFrame = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_mainFrame:setHorizontalSetting({ "2", "1", "*", "1", "2" })
    grid_mainFrame:setVerticalSetting({ "1", "*", "3", "*", "1" })
    grid_mainFrame:updatePosLen()
    self.grid_mainFrame = grid_mainFrame

    -- make left arrow button
    local bt_left_arrow = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_left_arrow")
    bt_left_arrow:setText("<")
    self.PROJ.Style.BT.keypad(bt_left_arrow)
    grid_mainFrame:setPosLen(bt_left_arrow, 1, 3)
    self.bt_left_arrow = bt_left_arrow
    self:addToAccountGroup(bt_left_arrow)

    -- make right arrow button
    local bt_right_arrow = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_right_arrow")
    bt_right_arrow:setText(">")
    self.PROJ.Style.BT.keypad(bt_right_arrow)
    grid_mainFrame:setPosLen(bt_right_arrow, 5, 3)
    self.bt_right_arrow = bt_right_arrow
    self:addToAccountGroup(bt_right_arrow)

    self:add_grid_mainFrameName(grid_mainFrame)
    self:add_grid_mainFramePanel(grid_mainFrame)

end

---add grid with main frame name tb
---@param grid_p Tabullet.Grid
function SCENE_L:add_grid_mainFrameName(grid_p)

    local framename = "test name!"
    local grid_mainframe_name = grid_p:genSubGrid(nil, 3, 2)
    grid_mainframe_name:setHorizontalSetting({ "*", tostring(2 + #framename), "*" })
    grid_mainframe_name:setVerticalSetting({ "1", "*" })
    grid_mainframe_name:updatePosLen()
    self.grid_mainframe_name = grid_mainframe_name

    local tb_mainframeName = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_mainframeName")
    tb_mainframeName:setText(framename)
    self.PROJ.Style.TB.ListTitle(tb_mainframeName)
    grid_mainframe_name:setPosLen(tb_mainframeName, 2, 1)
    self.tb_mainframeName = tb_mainframeName
    self:addToAccountGroup(tb_mainframeName)
end

---add mainframe panel grid
---@param grid_p Tabullet.Grid
function SCENE_L:add_grid_mainFramePanel(grid_p)

    local grid_mainframe_content = grid_p:genSubGrid(nil, 3, 2, 1, 3)
    grid_mainframe_content:setHorizontalSetting({ "*", "3", "*" })
    grid_mainframe_content:setVerticalSetting({ "*", "1", "1", "*", "1", "1", "*", "1", "1", "*" })
    grid_mainframe_content:updatePosLen()

    local tb_mainframe_balanceN, tb_mainframe_balanceC, tb_mainframe_balanceNL =
    self.PROJ.Style.make_infoPanel_pair("Balance", self.rootScreenCanvas, self.attachingScreen)
    grid_mainframe_content:setPosLen(tb_mainframe_balanceN, 1, 2)
    grid_mainframe_content:setPosLen(tb_mainframe_balanceC, 1, 3)
    tb_mainframe_balanceN.Len.x = tb_mainframe_balanceNL
    tb_mainframe_balanceC:setText("000,000")
    self.tb_mainframe_balanceC = tb_mainframe_balanceC
    self:addToAccountGroup(tb_mainframe_balanceN)
    self:addToAccountGroup(tb_mainframe_balanceC)

    local tb_mainframe_ownerN, tb_mainframe_ownerC, tb_mainframe_ownerNL =
    self.PROJ.Style.make_infoPanel_pair("Owner", self.rootScreenCanvas, self.attachingScreen)
    grid_mainframe_content:setPosLen(tb_mainframe_ownerN, 1, 5)
    grid_mainframe_content:setPosLen(tb_mainframe_ownerC, 1, 6)
    tb_mainframe_ownerN.Len.x = tb_mainframe_ownerNL
    tb_mainframe_ownerC:setText("ownerID")
    self.tb_mainframe_ownerC = tb_mainframe_ownerC
    self:addToAccountGroup(tb_mainframe_ownerN)
    self:addToAccountGroup(tb_mainframe_ownerC)

    local tb_mainframe_dateN, tb_mainframe_dateC, tb_mainframe_dateNL =
    self.PROJ.Style.make_infoPanel_pair("Date", self.rootScreenCanvas, self.attachingScreen)
    grid_mainframe_content:setPosLen(tb_mainframe_dateN, 1, 8)
    grid_mainframe_content:setPosLen(tb_mainframe_dateC, 1, 9)
    tb_mainframe_dateN.Len.x = tb_mainframe_dateNL
    tb_mainframe_dateC:setText(os.date('%y/%m/%d %H:%M %a'))
    self.tb_mainframe_dateC = tb_mainframe_dateC
    self:addToAccountGroup(tb_mainframe_dateN)
    self:addToAccountGroup(tb_mainframe_dateC)

    local tb_mainframe_historyN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "bt_mainframe_historyN")
    tb_mainframe_historyN:setText("History")
    self.PROJ.Style.TB.infoName(tb_mainframe_historyN)
    tb_mainframe_historyN:setMarginLeft(1)
    tb_mainframe_historyN:setMarginRight(1)
    grid_mainframe_content:setPosLen(tb_mainframe_historyN, 3, 2)
    tb_mainframe_historyN.Len.x = #("History") + 2
    self:addToAccountGroup(tb_mainframe_historyN)


    local lb_mainframe_historyC = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_mainframe_historyC")
    grid_mainframe_content:setPosLen(lb_mainframe_historyC, 3, 3, 1, 8)
    -- self.PROJ.Style.LB.Content(lb_mainframe_historyC)
    self.lb_mainframe_historyC = lb_mainframe_historyC
    self:addToAccountGroup(lb_mainframe_historyC)

    -- local tempDate = {}
    -- for i = 1, 20, 1 do
    --     table.insert(tempDate, { ["i"] = "salary!!", ["b"] = tostring(i * 10000) })
    -- end
    -- lb_mainframe_historyC:setItemSource(tempDate)
    -- lb_mainframe_historyC.ItemTemplete = function(obj)
    --     return obj.i .. "/" .. obj.b
    -- end
    -- lb_mainframe_historyC:Refresh()

end

---make menu
function SCENE_L:make_menu()
    local grid_menu = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid_menu:setHorizontalSetting({ "6", "4", "*" })
    grid_menu:setVerticalSetting({ "1", "3", "3", "3", "3", "3", "*" })
    grid_menu:updatePosLen()

    local bt_menu = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_menu")
    bt_menu:setText("Menu")
    bt_menu.IsToggleable = true
    grid_menu:setPosLen(bt_menu, 1, 1)
    self.PROJ.Style.BT.ImportantFunc(bt_menu)
    bt_menu.BGPressed = TBL.Enums.Color.blue
    bt_menu.FGPressed = TBL.Enums.Color.black
    self.bt_menu = bt_menu

    local bts_menu = {}
    bts_menu.Send = self:make_menu_bt("Send")
    bts_menu.Inquire = self:make_menu_bt("Inquire")
    bts_menu.Register = self:make_menu_bt("Register")
    bts_menu.Remove = self:make_menu_bt("Remove")
    bts_menu.Addon = self:make_menu_bt("Addon")
    grid_menu:setPosLen(bts_menu.Send, 1, 2, 2, 1)
    grid_menu:setPosLen(bts_menu.Inquire, 1, 3, 2, 1)
    grid_menu:setPosLen(bts_menu.Register, 1, 4, 2, 1)
    grid_menu:setPosLen(bts_menu.Remove, 1, 5, 2, 1)
    grid_menu:setPosLen(bts_menu.Addon, 1, 6, 2, 1)
    bts_menu.Send.Visible = true
    bts_menu.Inquire.Visible = true
    bts_menu.Register.Visible = true
    bts_menu.Remove.Visible = true
    bts_menu.Addon.Visible = true
    self.bts_menu = bts_menu

end

function SCENE_L:make_menu_bt(bt_name)
    local bt_menu = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_menu_" .. bt_name)
    bt_menu:setText(bt_name)
    self.PROJ.Style.BT.ImportantFunc(bt_menu)
    return bt_menu
end

---comment
---@param ui Tabullet.UIElement
function SCENE_L:addToAccountGroup(ui)
    table.insert(self.__AccountPanelGroup, ui)
end

---comment
---@return table<number, Tabullet.UIElement>
function SCENE_L:getAccountContentGroups()
    return self.__AccountPanelGroup
end

return SCENE_L
