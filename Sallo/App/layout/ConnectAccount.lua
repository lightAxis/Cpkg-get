local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.ConnectAccount : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.ConnectAccount
local SCENE_L = class("Sallo.App.Layout.ConnectAccount", TBL.UILayout)

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

    local bt_link = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_link")
    bt_link:setText("Connect")
    grid:setPosLen(bt_link, 5, 4)
    self.PROJ.Style.BT.Good(bt_link)
    self.bt_buy = bt_link

    self:make_grid_main(grid)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_main(grid_p)
    local grid_main = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_main:setHorizontalSetting({ "1", "*", "3", "*", "1" })
    grid_main:setVerticalSetting({ "*" })
    grid_main:updatePosLen()

    self:make_grid_left(grid_main)
    self:make_grid_right(grid_main)

end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_left(grid_p)
    local grid_left = grid_p:genSubGrid(nil, 4, 1)
    grid_left:setHorizontalSetting({ "*" })
    grid_left:setVerticalSetting({ "1", "1", "1", "*", "1", "1", "*" })
    grid_left:updatePosLen()

    local prev_accN, prev_accC, prev_accNL =
    self.PROJ.Style.make_infoPanel_pair("Prev Account Name", self.rootScreenCanvas, self.attachingScreen)
    grid_left:setPosLen(prev_accN, 1, 2)
    grid_left:setPosLen(prev_accC, 1, 3)
    prev_accN.Len.x = prev_accNL
    self.tb_prev_accC = prev_accC

    local sel_accN, sel_accC, sel_accNL =
    self.PROJ.Style.make_infoPanel_pair("Selected Account", self.rootScreenCanvas, self.attachingScreen)
    grid_left:setPosLen(sel_accN, 1, 5)
    grid_left:setPosLen(sel_accC, 1, 6)
    sel_accN.Len.x = sel_accNL
    self.tb_sel_accC = sel_accC
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_right(grid_p)
    local grid_right = grid_p:genSubGrid(nil, 2, 1)
    grid_right:setHorizontalSetting({ "*", "1", "1" })
    grid_right:setVerticalSetting({ "1", "1", "4*", "1", "1", "1", "4*", "*" })
    grid_right:updatePosLen()

    local bt_refresh_accounts = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_accounts")
    bt_refresh_accounts:setText("Refresh")
    self.PROJ.Style.BT.func(bt_refresh_accounts)
    grid_right:setPosLen(bt_refresh_accounts, 1, 1)
    self.bt_refresh_accounts = bt_refresh_accounts

    local lb_accounts = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_accounts")
    grid_right:setPosLen(lb_accounts, 1, 3, 1, 5)
    self.lb_accounts = lb_accounts

    local bt_arrow_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_up")
    bt_arrow_up:setText("^")
    self.PROJ.Style.BT.keypad(bt_arrow_up)
    grid_right:setPosLen(bt_arrow_up, 3, 4)
    self.bt_arrow_up = bt_arrow_up

    local bt_arrow_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_arrow_down")
    bt_arrow_down:setText("v")
    self.PROJ.Style.BT.keypad(bt_arrow_down)
    grid_right:setPosLen(bt_arrow_down, 3, 6)
    self.bt_arrow_down = bt_arrow_down
end

return SCENE_L
