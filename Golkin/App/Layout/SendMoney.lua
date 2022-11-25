local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.SendMoney : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.SendMoney
local SCENE_L = class("Golkin.App.Layout.SendMoney", TBL.UILayout)

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
    info_tb:setText("fill send msg & recieve msg")
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
    local bt_next = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_next")
    bt_next:setText("Next")
    grid:setPosLen(bt_next, 5, 4)
    self.PROJ.Style.BT.func(bt_next)
    self.bt_next = bt_next

    self:make_send_profile(grid)
end

---make send profile elements
---@param grid_p Tabullet.Grid
function SCENE_L:make_send_profile(grid_p)
    local grid_send_profile = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_send_profile:setHorizontalSetting({ "1", "*", "3", "*", "1" })
    grid_send_profile:setVerticalSetting({ "1", "*", "1" })
    grid_send_profile:updatePosLen()

    self:grid_sending_balance(grid_send_profile)
    self:grid_recieve_accountList(grid_send_profile)
end

---make sending balance
---@param grid_p Tabullet.Grid
function SCENE_L:grid_sending_balance(grid_p)
    local grid_sending_balance = grid_p:genSubGrid(nil, 2, 2)
    grid_sending_balance:setHorizontalSetting({ "*" })
    grid_sending_balance:setVerticalSetting({ "1", "1", "1", "1", "1", "*" })
    grid_sending_balance:updatePosLen()

    local tb_info_balanceN, tb_info_balanceC, tb_info_balanceNL =
    self.PROJ.Style.make_infoPanel_pair("Left", self.rootScreenCanvas, self.attachingScreen)
    grid_sending_balance:setPosLen(tb_info_balanceN, 1, 1)
    grid_sending_balance:setPosLen(tb_info_balanceC, 1, 2)
    tb_info_balanceN.Len.x = tb_info_balanceNL
    tb_info_balanceC:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.right)
    self.tb_info_balanceC = tb_info_balanceC

    local tb_info_sendingN, tb_info_sendingC, tb_info_sendingNL =
    self.PROJ.Style.make_infoPanel_pair("Sending", self.rootScreenCanvas, self.attachingScreen)
    grid_sending_balance:setPosLen(tb_info_sendingN, 1, 4)
    grid_sending_balance:setPosLen(tb_info_sendingC, 1, 5)
    tb_info_sendingN.Len.x = tb_info_sendingNL
    tb_info_sendingC:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.left)
    self.tb_info_sendingC = tb_info_sendingC

    self:grid_sending_numpad(grid_sending_balance)
end

---make sending numpad grid
---@param grid_p Tabullet.Grid
function SCENE_L:grid_sending_numpad(grid_p)
    local grid_numpad = grid_p:genSubGrid(nil, 1, 6)
    grid_numpad:setHorizontalSetting({ "*", "3", "1", "3", "1", "3", "1", "3", "1", "3", "*" })
    grid_numpad:setVerticalSetting({ "*", "1", "1", "1", "1", "1", "*" })
    grid_numpad:updatePosLen()

    -- button list numpads
    ---@type table<number, Tabullet.Button>
    local bts_numpad = {}
    for i = 1, 10, 1 do

        local displayNum = i
        if (i == 10) then
            displayNum = 0
        end
        local numpad = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_numpad_" .. tostring(displayNum))
        numpad:setText(tostring(displayNum))

        local hori_i
        local vert_i
        if (i <= 5) then
            hori_i = i * 2
            vert_i = 2
        else
            hori_i = i * 2 - 10
            vert_i = 4
        end
        grid_numpad:setPosLen(numpad, hori_i, vert_i)

        self.PROJ.Style.BT.keypad(numpad)
        table.insert(bts_numpad, numpad)
    end
    self.bts_numpad = bts_numpad

    -- button numpad reset
    local bt_numpad_reset = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_numpad_reset")
    grid_numpad:setPosLen(bt_numpad_reset, 2, 6, 3, 1)
    bt_numpad_reset:setText("Reset")
    self.PROJ.Style.BT.keypad(bt_numpad_reset)
    self.bt_numpad_reset = bt_numpad_reset

    -- button numpad backspace
    local bt_numpad_backspace = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_numpad_backspace")
    grid_numpad:setPosLen(bt_numpad_backspace, 8, 6, 3, 1)
    bt_numpad_backspace:setText("<--")
    self.PROJ.Style.BT.keypad(bt_numpad_backspace)
    self.bt_numpad_backspace = bt_numpad_backspace
end

---make recieving account list grid
---@param grid_p Tabullet.Grid
function SCENE_L:grid_recieve_accountList(grid_p)
    local grid_recieve = grid_p:genSubGrid(nil, 4, 2)
    grid_recieve:setHorizontalSetting({ "*", "1", "1" })
    grid_recieve:setVerticalSetting({ "1", "1", "1", "*", "1", "1", "1", "*" })
    grid_recieve:updatePosLen()

    local tb_info_recieveAccN, tb_info_recieveAccC, tb_info_recieveAccNL =
    self.PROJ.Style.make_infoPanel_pair("To", self.rootScreenCanvas, self.attachingScreen)
    grid_recieve:setPosLen(tb_info_recieveAccN, 1, 1, 3, 1)
    grid_recieve:setPosLen(tb_info_recieveAccC, 1, 2, 3, 1)
    tb_info_recieveAccN.Len.x = tb_info_recieveAccNL
    self.tb_info_recieveAccC = tb_info_recieveAccC

    local lb_available_accounts = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_available_accounts")
    grid_recieve:setPosLen(lb_available_accounts, 1, 4, 1, 5)
    self.lb_available_accounts = lb_available_accounts

    local tempDate = {}
    for i = 1, 20, 1 do
        table.insert(tempDate, { ["i"] = "salary!!", ["b"] = tostring(i * 10000) })
    end
    lb_available_accounts:setItemSource(tempDate)
    lb_available_accounts.ItemTemplete = function(obj)
        return obj.i .. "/" .. obj.b
    end
    lb_available_accounts:Refresh()

    local bt_avaialbe_account_scrolUp = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_avaialbe_account_scrolUp")
    bt_avaialbe_account_scrolUp:setText("^")
    grid_recieve:setPosLen(bt_avaialbe_account_scrolUp, 3, 5)
    self.PROJ.Style.BT.keypad(bt_avaialbe_account_scrolUp)
    self.bt_avaialbe_account_scrolUp = bt_avaialbe_account_scrolUp

    local bt_avaialbe_account_scrolDown = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_avaialbe_account_scrolDown")
    bt_avaialbe_account_scrolDown:setText("v")
    grid_recieve:setPosLen(bt_avaialbe_account_scrolDown, 3, 7)
    self.PROJ.Style.BT.keypad(bt_avaialbe_account_scrolDown)
    self.bt_avaialbe_account_scrolDown = bt_avaialbe_account_scrolDown

end

return SCENE_L
