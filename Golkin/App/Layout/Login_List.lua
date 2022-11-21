local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.Login_List : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.Login_List
local SCENE_L = class("Golkin.App.Layout.Login_List", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3" })
    grid:updatePosLen()
    self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    title_textblock.PosRel, title_textblock.Len = grid:getPosLenWithMargin(1, 1, 5, 1)
    title_textblock:setText("Sign In - Select Profile")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    info_tb.PosRel, info_tb.Len = grid:getPosLen(1, 2, 5, 1)
    info_tb:setText("Select your name")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    bt_back.PosRel, bt_back.Len = grid:getPosLen(1, 4, 1, 1)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    --- bt refresh names
    local bt_refresh_list = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_list")
    bt_refresh_list:setText("Refresh Names")
    bt_refresh_list.PosRel, bt_refresh_list.Len = grid:getPosLen(3, 4, 1, 1)
    self.PROJ.Style.BT.func(bt_refresh_list)
    self.bt_refresh_list = bt_refresh_list

    --- bt sign in
    local bt_Signin = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_signin")
    bt_Signin:setText("Sign In")
    bt_Signin.PosRel, bt_Signin.Len = grid:getPosLen(5, 4, 1, 1)
    self.PROJ.Style.BT.func(bt_Signin)
    self.bt_Signin = bt_Signin


    local grid2_pos, grid2_len = grid:getPosLen(1, 3, 5, 1)
    local grid2 = TBL.Grid:new(grid2_len, grid2_pos)
    grid2:setHorizontalSetting({ "*", "30", "*" })
    grid2:setVerticalSetting({ "2", "3", "2", "*", "2" })
    grid2:updatePosLen()
    self.grid2 = grid2

    local tb_name = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_name")
    tb_name.PosRel, tb_name.Len = grid2:getPosLen(2, 2, 1, 1)
    self.PROJ.Style.TB.ListTitle(tb_name)
    self.tb_name = tb_name

    local lb_names = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_names")
    lb_names.PosRel, lb_names.Len = grid2:getPosLenWithMargin(2, 4, 1, 1, 6, 6, 0, 0)
    local tempTable = { "name1", "name2", "name3", "name4", "name5", "name6", "name1", "name2", "name3", "name4", "name5",
        "name6" }
    lb_names:setItemSource(tempTable)
    lb_names:setItemTemplate(function(obj) return obj end)
    lb_names:Refresh()
    self.lb_names = lb_names

    local grid3_pos, grid3_len = grid2:getPosLen(2, 4, 1, 1)
    local grid3 = TBL.Grid:new(grid3_len, grid3_pos)
    grid3:setHorizontalSetting({ "*", "1", "4" })
    grid3:setVerticalSetting({ "*", "1", "1", "1", "*" })
    grid3:updatePosLen()

    local bt_scroll_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_scroll_up")
    bt_scroll_up:setText("^")
    bt_scroll_up.PosRel, bt_scroll_up.Len = grid3:getPosLen(2, 2, 1, 1)
    self.PROJ.Style.BT.keypad(bt_scroll_up)
    self.bt_scroll_up = bt_scroll_up

    local bt_scroll_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_scroll_down")
    bt_scroll_down:setText("v")
    bt_scroll_down.PosRel, bt_scroll_down.Len = grid3:getPosLen(2, 4, 1, 1)
    self.PROJ.Style.BT.keypad(bt_scroll_down)
    self.bt_scroll_down = bt_scroll_down
end

return SCENE_L
