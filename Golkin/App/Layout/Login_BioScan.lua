local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local AppLib = DEPS.Golkin.AppLib

---@class Golkin.App.Layout.Login_BioScan : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.Login_BioScan
local SCENE_L = class("Golkin.App.Layout.Login_BioScan", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3", "*", "3" })
    grid:updatePosLen()

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Sign In - BioScan")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Click Player Detection to Sign In!")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    local grid_playernameLine_pos, grid_playernameLine_len = grid:getPosLen(1, 3, 5, 3)
    local grid_playernameLine = TBL.Grid:new(grid_playernameLine_len, grid_playernameLine_pos)
    -- local grid_playernameLine = grid:genSubGrid(nil, 1, 3, 5, 3)
    grid_playernameLine:setHorizontalSetting({ "*", "20", "*" })
    grid_playernameLine:setVerticalSetting({ "*", "3", "*" })
    grid_playernameLine:updatePosLen();

    --- player name block
    local playerName_textblock = TBL.TextBlock:new(self.rootScreenCanvas,
        self.attachingScreen,
        "player_textblock")
    grid_playernameLine:setPosLen(playerName_textblock, 2, 2)
    self.PROJ.Style.TB.ListTitle(playerName_textblock)
    self.tb_playerName = playerName_textblock

    --- autenticate button
    local auth_bt = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "auth_bt")
    grid:setPosLen(auth_bt, 3, 6)
    auth_bt:setText("Login!")
    self.PROJ.Style.BT.func(auth_bt)
    self.bt_auth = auth_bt

    --- back button
    local back_bt = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "back_bt")
    grid:setPosLen(back_bt, 1, 6)
    back_bt:setText("back")
    self.PROJ.Style.BT.Back(back_bt)
    self.bt_back = back_bt

    local grid_sidebar_pos, grid_sidebar_len = grid:getPosLen(5, 3, 1, 3)
    local grid_sidebar = TBL.Grid:new(grid_sidebar_len, grid_sidebar_pos)
    -- local grid_sidebar = grid:genSubGrid(nil, 5, 3, 1, 3)
    grid_sidebar:setHorizontalSetting({ "*", "5", "1" })
    grid_sidebar:setVerticalSetting({ "*", "3", "*" })
    grid_sidebar:updatePosLen()

    --- goto login_list button
    local bt_gotoList = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_gotoList")
    grid_sidebar:setPosLen(bt_gotoList, 2, 2)
    self.PROJ.Style.BT.keypad(bt_gotoList)
    bt_gotoList:setText(">")
    self.bt_gotoList = bt_gotoList

end

return SCENE_L
