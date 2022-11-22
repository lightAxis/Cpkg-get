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
    info_tb.Visible = false
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    --- bt refresh names
    local bt_refresh_list = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_list")
    bt_refresh_list:setText("Account Inquirey")
    grid:setPosLen(bt_refresh_list, 3, 4)
    self.PROJ.Style.BT.func(bt_refresh_list)
    self.bt_refresh_list = bt_refresh_list

    --- bt sign in
    local bt_Signin = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_signin")
    bt_Signin:setText("Send Money")
    grid:setPosLen(bt_Signin, 5, 4)
    self.PROJ.Style.BT.func(bt_Signin)
    self.bt_Signin = bt_Signin

    --- grid for refresh button
    local grid_refresh_bt = grid:genSubGrid(nil, 1, 3, 5, 1)
    grid_refresh_bt:setHorizontalSetting({ "*", "11" })
    grid_refresh_bt:setVerticalSetting({ "3", "*" })
    grid_refresh_bt:updatePosLen()
    self.grid_refresh_bt = grid_refresh_bt

    local bt_refresh = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh")
    grid_refresh_bt:setPosLen(bt_refresh, 2, 1)
    bt_refresh:setText("Refresh")
    self.PROJ.Style.BT.ImportantFunc(bt_refresh)
    self.bt_refresh = bt_refresh
end

return SCENE_L
