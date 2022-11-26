local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.SendMoneyName : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.SendMoneyName
local SCENE_L = class("Golkin.App.Layout.SendMoneyName", TBL.UILayout)

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
    title_textblock:setText("Send Money Msgs")
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
    local bt_send = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_send")
    bt_send:setText("Send")
    grid:setPosLen(bt_send, 5, 4)
    self.PROJ.Style.BT.func(bt_send)
    self.bt_send = bt_send

    self:make_grid_infos(grid)
end

---make infos grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_infos(grid_p)
    local grid_infos = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_infos:setHorizontalSetting({ "*", "2*", "*" })
    grid_infos:setVerticalSetting({ "1", "1", "1", "*", "5*" })
    grid_infos:updatePosLen()

    local tb_info_balanceN, tb_info_balanceC, tb_info_balanceNL =
    self.PROJ.Style.make_infoPanel_pair("Sending", self.rootScreenCanvas, self.attachingScreen)
    grid_infos:setPosLen(tb_info_balanceN, 2, 2)
    grid_infos:setPosLen(tb_info_balanceC, 2, 3)
    tb_info_balanceN.Len.x = tb_info_balanceNL
    self.tb_info_balanceC = tb_info_balanceC

    self:make_grid_sender_recieverInfo(grid_infos)

end

---make sender info grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_sender_recieverInfo(grid_p)
    local grid_infos_sender = grid_p:genSubGrid(nil, 1, 5, 3, 1)
    grid_infos_sender:setHorizontalSetting({ "1", "*", "7", "*", "1" })
    grid_infos_sender:setVerticalSetting({ "1", "1", "1", "1", "*", "1", "1", "3*" })
    grid_infos_sender:updatePosLen()

    local tb_sender = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_sender")
    grid_infos_sender:setPosLenMargin(tb_sender, 2, 1, 1, 1, 0, 0, 0, 0)
    tb_sender:setText("Sender")
    self.PROJ.Style.TB.ListTitle(tb_sender)

    local tb_sender_accnameN, tb_sender_accnameC, tb_sender_accnameNL =
    self.PROJ.Style.make_infoPanel_pair("AccountName", self.rootScreenCanvas, self.attachingScreen)
    grid_infos_sender:setPosLen(tb_sender_accnameN, 2, 3)
    grid_infos_sender:setPosLen(tb_sender_accnameC, 2, 4)
    tb_sender_accnameN.Len.x = tb_sender_accnameNL
    self.tb_sender_accnameC = tb_sender_accnameC

    local tb_sender_msgN, tb_sender_msgC, tb_sender_msgNL =
    self.PROJ.Style.make_infoPanel_pair("Message", self.rootScreenCanvas, self.attachingScreen)
    grid_infos_sender:setPosLen(tb_sender_msgN, 2, 6)
    grid_infos_sender:setPosLen(tb_sender_msgC, 2, 7)
    tb_sender_msgN.Len.x = tb_sender_msgNL
    self.tb_sender_msgC = tb_sender_msgC

    local tb_reciever = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_reciever")
    grid_infos_sender:setPosLenMargin(tb_reciever, 4, 1, 1, 1, 0, 0, 0, 0)
    tb_reciever:setText("Reciever")
    self.PROJ.Style.TB.ListTitle(tb_reciever)

    local tb_reciever_accnameN, tb_reciever_accnameC, tb_reciever_accnameNL =
    self.PROJ.Style.make_infoPanel_pair("AccountName", self.rootScreenCanvas, self.attachingScreen)
    grid_infos_sender:setPosLen(tb_reciever_accnameN, 4, 3)
    grid_infos_sender:setPosLen(tb_reciever_accnameC, 4, 4)
    tb_reciever_accnameN.Len.x = tb_reciever_accnameNL
    self.tb_reciever_accnameC = tb_reciever_accnameC

    local tb_reciever_msgN, tb_reciever_msgC, tb_reciever_msgNL =
    self.PROJ.Style.make_infoPanel_pair("Message", self.rootScreenCanvas, self.attachingScreen)
    grid_infos_sender:setPosLen(tb_reciever_msgN, 4, 6)
    grid_infos_sender:setPosLen(tb_reciever_msgC, 4, 7)
    tb_reciever_msgN.Len.x = tb_reciever_msgNL
    self.tb_reciever_msgC = tb_reciever_msgC
end

return SCENE_L
