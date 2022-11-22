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
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Sign In - Select Profile")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Select your name")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    --- bt refresh names
    local bt_refresh_list = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_list")
    bt_refresh_list:setText("Refresh Names")
    grid:setPosLen(bt_refresh_list, 3, 4)
    self.PROJ.Style.BT.func(bt_refresh_list)
    self.bt_refresh_list = bt_refresh_list

    --- bt sign in
    local bt_Signin = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_signin")
    bt_Signin:setText("Sign In")
    grid:setPosLen(bt_Signin, 5, 4)
    self.PROJ.Style.BT.func(bt_Signin)
    self.bt_Signin = bt_Signin

    -- grid to display left side arrow
    local grid4_GotoLeft = grid:genSubGrid(nil, 1, 3, 5, 1)
    grid4_GotoLeft:setHorizontalSetting({ "1", "5", "*" })
    grid4_GotoLeft:setVerticalSetting({ "*", "3", "*" })
    grid4_GotoLeft:updatePosLen()
    self.grid4_GotoLeft = grid4_GotoLeft

    -- button to go login_register
    local bt_goto_login_register = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_goto_login_register")
    grid4_GotoLeft:setPosLen(bt_goto_login_register, 2, 2)
    self.PROJ.Style.BT.keypad(bt_goto_login_register)
    bt_goto_login_register:setText("<")
    self.bt_goto_login_register = bt_goto_login_register


    -- grid for display listbox & scroll
    local grid2 = grid:genSubGrid(nil, 1, 3, 5, 1)
    grid2:setHorizontalSetting({ "*", "30", "*" })
    grid2:setVerticalSetting({ "2", "3", "2", "*", "2" })
    grid2:updatePosLen()
    self.grid2 = grid2

    -- tb for name of player display
    local tb_name = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_name")
    grid2:setPosLen(tb_name, 2, 2)
    self.PROJ.Style.TB.ListTitle(tb_name)
    self.tb_name = tb_name

    -- listbox to display name
    local lb_names = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_names")
    self.lb_names = lb_names
    -- example data
    grid2:setPosLenMargin(lb_names, 2, 4, 1, 1, 6, 6, 0, 0)
    local tempTable = { "name1", "name2", "name3", "name4", "name5", "name6", "name1", "name2", "name3", "name4", "name5",
        "name6" }
    lb_names:setItemSource(tempTable)
    lb_names:setItemTemplate(function(obj) return obj end)
    lb_names:Refresh()

    -- grid3 for button scroll
    local grid3 = grid2:genSubGrid(nil, 2, 4)
    grid3:setHorizontalSetting({ "*", "1", "4" })
    grid3:setVerticalSetting({ "*", "1", "1", "1", "*" })
    grid3:updatePosLen()

    -- button scroll up player list
    local bt_scroll_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_scroll_up")
    bt_scroll_up:setText("^")
    grid3:setPosLen(bt_scroll_up, 2, 2)
    self.PROJ.Style.BT.keypad(bt_scroll_up)
    self.bt_scroll_up = bt_scroll_up

    -- button scroll down player list
    local bt_scroll_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_scroll_down")
    bt_scroll_down:setText("v")
    grid3:setPosLen(bt_scroll_down, 2, 4)
    self.PROJ.Style.BT.keypad(bt_scroll_down)
    self.bt_scroll_down = bt_scroll_down
end

return SCENE_L
