local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.RemoveAccount : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.RemoveAccount
local SCENE_L = class("Golkin.App.Layout.RemoveAccount", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    self:main_layout()
end

function SCENE_L:main_layout()
    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3" })
    grid:updatePosLen()
    self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Send Money From : yourSendingAccount")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Fill the message textfields")
    self.PROJ.Style.TB.Info(info_tb)
    info_tb.Visible = true
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    -- --- bt refresh names
    -- local bt_refresh_list = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_list")
    -- bt_refresh_list:setText("Account Inquirey")
    -- grid:setPosLen(bt_refresh_list, 3, 4)
    -- self.PROJ.Style.BT.func(bt_refresh_list)
    -- self.bt_refresh_list = bt_refresh_list

    --- bt send
    local bt_register = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_register")
    bt_register:setText("Register")
    grid:setPosLen(bt_register, 5, 4)
    self.PROJ.Style.BT.func(bt_register)
    self.bt_register = bt_register

    self:make_grid_removeAccount(grid)
end

---make remove account grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_removeAccount(grid_p)
    local grid_removeacc = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_removeacc:setHorizontalSetting({ "1", "*", "1" })
    grid_removeacc:setVerticalSetting({ "*", "1", "3", "*", "1", "3", "*" })
    grid_removeacc:updatePosLen()

    local tb_removeacc_nameN, tb_removeacc_nameC, tb_removeacc_nameNL =
    self.PROJ.Style.make_infoPanel_pair("Removing Account Name", self.rootScreenCanvas, self.attachingScreen)
    grid_removeacc:setPosLen(tb_removeacc_nameN, 2, 2)
    grid_removeacc:setPosLen(tb_removeacc_nameC, 2, 3)
    tb_removeacc_nameN.Len.x = tb_removeacc_nameNL
    self.tb_removeacc_nameC = tb_removeacc_nameC

    local tb_balanceN, tb_balanceC, tb_balanceNL =
    self.PROJ.Style.make_infoPanel_pair("Balance Left", self.rootScreenCanvas, self.attachingScreen)
    grid_removeacc:setPosLen(tb_balanceN, 2, 5)
    grid_removeacc:setPosLen(tb_balanceC, 2, 6)
    tb_balanceN.Len.x = tb_balanceNL
    self.tb_balanceLeftC = tb_balanceC
end

return SCENE_L
