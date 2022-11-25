local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.Histories : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.Histories
local SCENE_L = class("Golkin.App.Layout.Histories", TBL.UILayout)

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
    -- self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Histories : yourSendingAccount")
    self.PROJ.Style.TB.title(title_textblock)
    -- self.tb_title = title_textblock

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

    -- --- bt refresh names
    -- local bt_refresh_list = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh_list")
    -- bt_refresh_list:setText("Account Inquirey")
    -- grid:setPosLen(bt_refresh_list, 3, 4)
    -- self.PROJ.Style.BT.func(bt_refresh_list)
    -- self.bt_refresh_list = bt_refresh_list

    -- --- bt send
    -- local bt_send = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
    --     "bt_send")
    -- bt_send:setText("Send")
    -- grid:setPosLen(bt_send, 5, 4)
    -- self.PROJ.Style.BT.func(bt_send)
    -- self.bt_send = bt_send

    self:make_historyWindow(grid)
end

---make history window grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_historyWindow(grid_p)
    local grid_historyWindow = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_historyWindow:setHorizontalSetting({ "1", "*", "3", "*", "1" })
    grid_historyWindow:setVerticalSetting({ "1", "*", "1" })
    grid_historyWindow:updatePosLen()

    self:make_history_listbox(grid_historyWindow)
    self:make_history_viewtable(grid_historyWindow)
end

---make history listbox grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_history_listbox(grid_p)
    local grid_history_listbox = grid_p:genSubGrid(nil, 2, 2)
    grid_history_listbox:setHorizontalSetting({ "*", "1", "1" })
    grid_history_listbox:setVerticalSetting({ "1", "*" })
    grid_history_listbox:updatePosLen()

    local tb_info_historyN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_info_historyN")
    tb_info_historyN:setText("Histories")
    tb_info_historyN:setMarginLeft(1)
    tb_info_historyN:setMarginRight(1)
    grid_history_listbox:setPosLen(tb_info_historyN, 1, 1, 3, 1)
    self.PROJ.Style.TB.infoName(tb_info_historyN)
    tb_info_historyN.Len.x = #("Histories") + 2

    local lb_info_history = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_info_history")
    grid_history_listbox:setPosLen(lb_info_history, 1, 2, 1, 1)
    self.lb_info_history = lb_info_history

    local tempDate = {}
    for i = 1, 20, 1 do
        table.insert(tempDate, { ["i"] = "salary!!", ["b"] = tostring(i * 10000) })
    end
    lb_info_history:setItemSource(tempDate)
    lb_info_history.ItemTemplete = function(obj)
        return obj.i .. "/" .. obj.b
    end
    lb_info_history:Refresh()

end

---make history viewtable grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_history_viewtable(grid_p)
    local grid_history_viewtable = grid_p:genSubGrid(nil, 4, 2)
    grid_history_viewtable:setHorizontalSetting({ "*" })
    grid_history_viewtable:setVerticalSetting({ "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "*" })
    grid_history_viewtable:updatePosLen()

    local tbs_history_viewtable = {}

    local tb_nameN, tb_nameC, tb_nameNL =
    self.PROJ.Style.make_infoPanel_pair("Name", self.rootScreenCanvas, self.attachingScreen)
    grid_history_viewtable:setPosLen(tb_nameN, 1, 1)
    grid_history_viewtable:setPosLen(tb_nameC, 1, 2)
    tb_nameN.Len.x = tb_nameNL
    tbs_history_viewtable.Name = tb_nameC

    local tb_inoutN, tb_inoutC, tb_intoutNL =
    self.PROJ.Style.make_infoPanel_pair("InOut", self.rootScreenCanvas, self.attachingScreen)
    grid_history_viewtable:setPosLen(tb_inoutN, 1, 4)
    grid_history_viewtable:setPosLen(tb_inoutC, 1, 5)
    tb_inoutN.Len.x = tb_intoutNL
    tbs_history_viewtable.InOut = tb_inoutC

    local tb_balanceLeftN, tb_balanceLeftC, tb_balanceLeftNL =
    self.PROJ.Style.make_infoPanel_pair("BalanceLeft", self.rootScreenCanvas, self.attachingScreen)
    grid_history_viewtable:setPosLen(tb_balanceLeftN, 1, 7)
    grid_history_viewtable:setPosLen(tb_balanceLeftC, 1, 8)
    tb_balanceLeftN.Len.x = tb_balanceLeftNL
    tbs_history_viewtable.BalanceLeft = tb_balanceLeftC

    local tb_dateN, tb_dateC, tb_dateNL =
    self.PROJ.Style.make_infoPanel_pair("DateTime", self.rootScreenCanvas, self.attachingScreen)
    grid_history_viewtable:setPosLen(tb_dateN, 1, 10)
    grid_history_viewtable:setPosLen(tb_dateC, 1, 11)
    tb_dateN.Len.x = tb_dateNL
    tbs_history_viewtable.DateTime = tb_dateC

    self.tbs_history_viewtable = tbs_history_viewtable
end

return SCENE_L
