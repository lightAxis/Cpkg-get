local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.InfoMenu : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.InfoMenu
local SCENE_L = class("Sallo.App.Layout.InfoMenu", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Sallo.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    self.tbs_main = {}
    ---@type table<string, Tabullet.TextBlock>
    self.tbs_menu_1 = {}
    -- -@type table<string, Tabullet.TextBlock>
    self.tbs_menu_2 = {}
    -- -@type table<string, Tabullet.TextBlock>
    self.tbs_menu_3 = {}

    ---@type table<number, table<string, Tabullet.TextBlock>>
    self.tbs_menus = { [1] = self.tbs_menu_1, [2] = self.tbs_menu_2, [3] = self.tbs_menu_3 }

    ---@enum Sallo.App.Scene.InfoMenu.eMenu
    self.eMenu = { ["NONE"] = 0, ["stat"] = 1, ["statistics"] = 2, ["skillstate"] = 3 }
    self.currMenu = self.eMenu.stat

    ---@enum Sallo.App.Scene.InfoMenu.eMode
    self.eMode = { ["OWNER"] = 1, ["VIEWER"] = 2 }
    self.currMode = self.eMode.OWNER

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
    title_textblock:setText("InfoMenu")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("WellCome back! " .. "[testname]")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    --- bt skill
    local bt_skill = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_skill")
    bt_skill:setText("Skill")
    grid:setPosLen(bt_skill, 3, 4)
    self.PROJ.Style.BT.ImportantFunc(bt_skill)
    self.bt_skill = bt_skill

    --- bt store
    local bt_store = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_store")
    bt_store:setText("Store")
    grid:setPosLen(bt_store, 5, 4)
    self.PROJ.Style.BT.func(bt_store)
    self.bt_store = bt_store

    self:make_grid_arrows(grid)
    self:make_grid_menubar()
    self:make_grid_refresh(grid)
    self:make_grid_registerBt(grid)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_arrows(grid_p)
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

    -- make right arrow button
    local bt_right_arrow = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_right_arrow")
    bt_right_arrow:setText(">")
    self.PROJ.Style.BT.keypad(bt_right_arrow)
    grid_mainFrame:setPosLen(bt_right_arrow, 5, 3)
    self.bt_right_arrow = bt_right_arrow

    self:make_grid_namemxp(grid_mainFrame)
end

---comment
function SCENE_L:make_grid_menubar()
    local grid_menu = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid_menu:setHorizontalSetting({ "6", "6", "*" })
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
    bts_menu.Wallet = self:make_menu_bt("Wallet")
    bts_menu.Inspector = self:make_menu_bt("Inspector")
    bts_menu.Thema = self:make_menu_bt("Thema")
    bts_menu.LeaderBoard = self:make_menu_bt("LeaderBoard")
    grid_menu:setPosLen(bts_menu.Wallet, 1, 2, 2, 1)
    grid_menu:setPosLen(bts_menu.Inspector, 1, 3, 2, 1)
    grid_menu:setPosLen(bts_menu.Thema, 1, 4, 2, 1)
    grid_menu:setPosLen(bts_menu.LeaderBoard, 1, 5, 2, 1)
    bts_menu.Wallet.Visible = true
    bts_menu.Inspector.Visible = true
    bts_menu.Thema.Visible = true
    bts_menu.LeaderBoard.Visible = true
    self.bts_menu = bts_menu
end

function SCENE_L:make_menu_bt(bt_name)
    local bt_menu = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_menu_" .. bt_name)
    bt_menu:setText(bt_name)
    self.PROJ.Style.BT.ImportantFunc(bt_menu)
    return bt_menu
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_registerBt(grid_p)
    local grid_register = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_register:setHorizontalSetting({ "*", "8*", "*" })
    grid_register:setVerticalSetting({ "*", "3", "*" })
    grid_register:updatePosLen()

    local bt_transferInfo = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_transferInfo")
    bt_transferInfo:setText("Transfer Account From Golkin")
    grid_register:setPosLen(bt_transferInfo, 2, 2)
    self.PROJ.Style.BT.ImportantFunc(bt_transferInfo)
    self.bt_trasferInfo = bt_transferInfo
end

---add refresh button with grid
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_refresh(grid_p)
    -- make grid
    local grid_refresh = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_refresh:setHorizontalSetting({ "*", "11" })
    grid_refresh:setVerticalSetting({ "1", "*" })
    grid_refresh:updatePosLen()

    -- refresh button
    local bt_refresh = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_refresh")
    grid_refresh:setPosLen(bt_refresh, 2, 1)
    bt_refresh:setText("Refresh")
    self.PROJ.Style.BT.ImportantFunc(bt_refresh)
    self.bt_refresh = bt_refresh
end

---comment
---@param name string
---@param row number
---@param col number
---@param grid Tabullet.Grid
---@return Tabullet.TextBlock tempN
---@return Tabullet.TextBlock tempC
function SCENE_L:make_grid_info_combo(name, col, row, grid)
    local tempN, tempC, tempNL =
    self.PROJ.Style.make_infoPanel_pair(name, self.rootScreenCanvas, self.attachingScreen)
    grid:setPosLen(tempN, col, row)
    grid:setPosLen(tempC, col, row + 1)
    tempN.Len.x = tempNL
    return tempN, tempC
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_namemxp(grid_p)
    local grid_main_infopanel1 = grid_p:genSubGrid(nil, 3, 2, 1, 3)
    grid_main_infopanel1:setHorizontalSetting({ "*" })
    grid_main_infopanel1:setVerticalSetting({ "1", "1", "1", "1", "*" })
    grid_main_infopanel1:updatePosLen()

    local grid_main_infoTop = grid_main_infopanel1:genSubGrid(nil, 1, 1)
    grid_main_infoTop:setHorizontalSetting({ "7", "*", "*", "*" })
    grid_main_infoTop:setVerticalSetting({ "*" })
    grid_main_infoTop:updatePosLen()
    self.grid_main_infoTop = grid_main_infoTop

    local tb_level = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_level")
    tb_level:setText("Lv. 35")
    self.PROJ.Style.TB.Level(tb_level)
    self.tb_level = tb_level
    self.tbs_main.Level = tb_level

    local tb_username = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_username")
    tb_username:setText("[testUser]")
    self.PROJ.Style.TB.ListTitle(tb_username)
    self.tb_username = tb_username
    self.tbs_main.UserName = tb_username

    local tb_rankName = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_rankName")
    tb_rankName:setText("master challenger")
    self.PROJ.Style.TB.RankName(tb_rankName)
    self.tb_rankName = tb_rankName
    self.tbs_main.RankName = tb_rankName

    local pgb_exp_gauge = TBL.ProgressBar:new(self.rootScreenCanvas, self.attachingScreen, "pgb_exp_gauge")
    grid_main_infopanel1:setPosLen(pgb_exp_gauge, 1, 2, 1, 1)
    self.PROJ.Style.PGB.EXPBar(pgb_exp_gauge)
    pgb_exp_gauge:setValue(0.5)
    pgb_exp_gauge.BarDirection = TBL.Enums.Direction.horizontal
    self.pgb_exp_gauge = pgb_exp_gauge
    self.tbs_main.ExpGuage_pgb = pgb_exp_gauge

    local tb_exp_gauge = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_exp_gauge")
    grid_main_infopanel1:setPosLen(tb_exp_gauge, 1, 2, 1, 1)
    self.PROJ.Style.TB.progressBar(tb_exp_gauge)
    tb_exp_gauge:setText("13224.33 / 44293 (26.35%)")
    self.tb_exp_gauge = tb_exp_gauge
    self.tbs_main.ExpGuage_tb = tb_exp_gauge

    local pgb_act_gauge = TBL.ProgressBar:new(self.rootScreenCanvas, self.attachingScreen, "pgb_act_gauge")
    grid_main_infopanel1:setPosLen(pgb_act_gauge, 1, 3, 1, 1)
    self.PROJ.Style.PGB.EXPBar2(pgb_act_gauge)
    pgb_act_gauge:setValue(0.5)
    pgb_act_gauge.BarDirection = TBL.Enums.Direction.horizontal
    self.pgb_act_gauge = pgb_act_gauge
    self.tbs_main.ActGauge_pgb = pgb_act_gauge

    local tb_act_gauge = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_act_gauge")
    grid_main_infopanel1:setPosLen(tb_act_gauge, 1, 3, 1, 1)
    self.PROJ.Style.TB.progressBar(tb_act_gauge)
    tb_act_gauge:setText("13224.33 / 44293 (26.35%)")
    self.tb_act_gauge = tb_act_gauge
    self.tbs_main.ActGauge_tb = tb_act_gauge

    self:set_exp_gauge(13224.33, 44293)
    self:set_act_gauge(120, 480)
    self:set_info_top(132, "[testName!]", "master challenger")

    self:make_grid_info2(grid_main_infopanel1)
end

---comment
---@param level number
---@param name string
---@param rank string
function SCENE_L:set_info_top(level, name, rank)
    self.tb_level:setText("Lv." .. tostring(level))
    self.tb_username:setText(name)
    self.tb_rankName:setText(rank)

    self.grid_main_infoTop:setHorizontalSetting({ "6",
        tostring(#self.tb_username:getText() + 2),
        "*",
        tostring(#self.tb_rankName:getText()) })
    self.grid_main_infoTop:updatePosLen()
    self.grid_main_infoTop:setPosLen(self.tb_level, 1, 1)
    self.grid_main_infoTop:setPosLen(self.tb_username, 2, 1)
    self.grid_main_infoTop:setPosLen(self.tb_rankName, 4, 1)
end

---comment
---@param now number
---@param max number
function SCENE_L:set_exp_gauge(now, max)
    local text = tostring(string.format("%.2f / %.2f (%.2f", now, max, 100 * now / max) .. "%)")
    self.pgb_exp_gauge:setValue(now / max)
    self.tb_exp_gauge:setText(text)
end

---comment
---@param now number
---@param max number
function SCENE_L:set_act_gauge(now, max)
    local text = tostring(string.format("%.2f / %.2f (%.2f", now, max, 100 * now / max) .. "%)")
    self.pgb_act_gauge:setValue(now / max)
    self.tb_act_gauge:setText(text)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_info1(grid_p)
    local grid_main_infopanel1 = grid_p:genSubGrid(nil, 1, 5, 1, 1)
    grid_main_infopanel1:setHorizontalSetting({ "*", "3", "*" })
    grid_main_infopanel1:setVerticalSetting({ "1", "1", "1", "1", "1", "1", "1", "1", "*" })
    grid_main_infopanel1:updatePosLen()
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_info2(grid_p)

    local grid_main_infopanel2 = grid_p:genSubGrid(nil, 1, 5, 1, 1)
    grid_main_infopanel2:setHorizontalSetting({ "*", "3", "*" })
    grid_main_infopanel2:setVerticalSetting({ "1", "1", "1", "1", "1", "1", "1", "1", "*" })
    grid_main_infopanel2:updatePosLen()

    self.tbs_menu_1.ExpPerMinN, self.tbs_menu_1.ExpPerMinC = self:make_grid_info_combo("EXP/min", 1, 1,
        grid_main_infopanel2)
    self.tbs_menu_1.GoldPerMinN, self.tbs_menu_1.GoldPerMinC = self:make_grid_info_combo("GOLD/min", 1, 4,
        grid_main_infopanel2)
    self.tbs_menu_1.ActPerMinN, self.tbs_menu_1.ActPerMinC = self:make_grid_info_combo("ACT/min", 1, 7,
        grid_main_infopanel2)

    self.tbs_menu_1.ExpPerActN, self.tbs_menu_1.ExpPerActC = self:make_grid_info_combo("EXP/CAP", 3, 1,
        grid_main_infopanel2)
    self.tbs_menu_1.GoldPerActN, self.tbs_menu_1.GoldPerActC = self:make_grid_info_combo("GOLD/CAP", 3, 4,
        grid_main_infopanel2)
    self.tbs_menu_1.ActAmpN, self.tbs_menu_1.ActAmpC = self:make_grid_info_combo("ACT Amplifier", 3, 7,
        grid_main_infopanel2)



    self.tbs_menu_2.TodayExpN, self.tbs_menu_2.TodayExpC = self:make_grid_info_combo("EXP Today", 1, 1,
        grid_main_infopanel2)
    self.tbs_menu_2.TodayActN, self.tbs_menu_2.TodayActC = self:make_grid_info_combo("ACT Today", 1, 4,
        grid_main_infopanel2)
    self.tbs_menu_2.TodayGoldN, self.tbs_menu_2.TodayGoldC = self:make_grid_info_combo("GOLD Today", 1, 7,
        grid_main_infopanel2)

    self.tbs_menu_2.TotalExpN, self.tbs_menu_2.TotalExpC = self:make_grid_info_combo("EXP Total", 3, 1,
        grid_main_infopanel2)
    self.tbs_menu_2.TotalActN, self.tbs_menu_2.TotalActC = self:make_grid_info_combo("ACT Total", 3, 4,
        grid_main_infopanel2)
    self.tbs_menu_2.TotalGoldN, self.tbs_menu_2.TotalGoldC = self:make_grid_info_combo("GOLD Total", 3, 7,
        grid_main_infopanel2)


    self.tbs_menu_3.TotalSPN, self.tbs_menu_3.TotalSPC = self:make_grid_info_combo("Total SKp", 1, 1,
        grid_main_infopanel2)
    self.tbs_menu_3.LeftSPN, self.tbs_menu_3.LeftSPC = self:make_grid_info_combo("Left SKp", 1, 4,
        grid_main_infopanel2)

    self.tbs_menu_3.EffLevelN, self.tbs_menu_3.EffLevelC = self:make_grid_info_combo("Eff Level", 3, 1,
        grid_main_infopanel2)
    self.tbs_menu_3.ProLevelN, self.tbs_menu_3.ProLevelC = self:make_grid_info_combo("Pro Level", 3, 4,
        grid_main_infopanel2)
    self.tbs_menu_3.ConLevelN, self.tbs_menu_3.ConLevelC = self:make_grid_info_combo("Con Level", 3, 7,
        grid_main_infopanel2)

end

---comment
---@param eMenu Sallo.App.Scene.InfoMenu.eMenu
---@param info_t Sallo.Web.Protocol.Struct.info_t|nil nil if eMenu is NONE
function SCENE_L:select_menu(eMenu, info_t)
    self.currMenu = eMenu
    local bs = { false, false, false }
    local left_visible = false
    local right_visible = false
    if (eMenu == self.eMenu.stat) then
        bs[1] = true
        right_visible = true
    elseif eMenu == self.eMenu.statistics then
        bs[2] = true
        left_visible = true
        right_visible = true
    elseif eMenu == self.eMenu.skillstate then
        bs[3] = true
        left_visible = true
    elseif eMenu == self.eMenu.NONE then
        left_visible = false
        right_visible = false
    else
        error("error in Sallo, InfoMenu:" .. eMenu)
    end

    for i = 1, 3, 1 do
        for k, v in pairs(self.tbs_menus[i]) do
            v.Visible = bs[i]
        end
    end

    self.bt_left_arrow.Visible = left_visible
    self.bt_right_arrow.Visible = right_visible

    local show_main = true
    -- if emenu is none, stop at here. turn off everything, but register button
    if eMenu == self.eMenu.NONE then
        show_main = false
        for k, v in pairs(self.tbs_main) do
            v.Visible = show_main
        end
        self:setMode(self.eMode.VIEWER)
        self.bt_refresh.Visible = false
        self.bt_trasferInfo.Visible = true
        return nil
    end
    for k, v in pairs(self.tbs_main) do
        v.Visible = show_main
    end

    self.bt_menu.Visible = true
    self.bt_skill.Visible = true
    self.bt_store.Visible = true
    self.bt_refresh.Visible = true
    self.bt_trasferInfo.Visible = false


    if info_t == nil then
        error("info cannot be nil when eMenu is not NONE!")
    end

    local rankLevel = param.Rank[info_t.Main.Rank].rank_level
    if rankLevel <= 4 then
        self.tbs_menu_1.ExpPerActN.Visible = false
        self.tbs_menu_1.ExpPerActC.Visible = false
        self.tbs_menu_3.TotalSPN.Visible = false
        self.tbs_menu_3.TotalSPC.Visible = false
        self.tbs_menu_3.LeftSPN.Visible = false
        self.tbs_menu_3.LeftSPC.Visible = false
        self.tbs_menu_3.EffLevelN.Visible = false
        self.tbs_menu_3.EffLevelC.Visible = false
        if (eMenu == self.eMenu.statistics) then
            self.bt_right_arrow.Visible = false
        end
    end
    if rankLevel <= 8 then
        self.tbs_menu_1.GoldPerActN.Visible = false
        self.tbs_menu_1.GoldPerActC.Visible = false
        self.tbs_menu_3.ProLevelN.Visible = false
        self.tbs_menu_3.ProLevelC.Visible = false
    end
    if rankLevel <= 12 then
        self.tbs_menu_1.ActAmpN.Visible = false
        self.tbs_menu_1.ActAmpC.Visible = false
        self.tbs_menu_3.ConLevelN.Visible = false
        self.tbs_menu_3.ConLevelC.Visible = false
    end

    if self.currMode == self.eMode.VIEWER then
        self:setMode(self.eMode.VIEWER)
    end
end

---scroll menu to left
---@param info_t Sallo.Web.Protocol.Struct.info_t
function SCENE_L:scrollMenu_left(info_t)
    if (self.currMenu == self.eMenu.stat) then
        -- nothing
    elseif self.currMenu == self.eMenu.statistics then
        self:select_menu(self.eMenu.stat, info_t)
    elseif self.currMenu == self.eMenu.skillstate then
        self:select_menu(self.eMenu.statistics, info_t)
    elseif self.currMenu == self.eMenu.NONE then
        self:select_menu(self.eMenu.NONE, nil)
    end
end

---scroll menu to right
---@param info_t Sallo.Web.Protocol.Struct.info_t
function SCENE_L:scrollMenu_right(info_t)
    if self.currMenu == self.eMenu.stat then
        self:select_menu(self.eMenu.statistics, info_t)
    elseif self.currMenu == self.eMenu.statistics then
        self:select_menu(self.eMenu.skillstate, info_t)
    elseif self.currMenu == self.eMenu.skillstate then
        -- nothing
    elseif self.currMenu == self.eMenu.NONE then
        self:select_menu(self.eMenu.NONE, nil)
    end
end

---comment
---@param info_t Sallo.Web.Protocol.Struct.info_t
function SCENE_L:refresh_info(info_t)
    if (info_t ~= nil) then
        local rankName = param.Rank[info_t.Main.Rank].rank_name
        self:set_info_top(info_t.Main.Level, info_t.Name, rankName)
        self:set_exp_gauge(info_t.Main.Exp, info_t.Main.Exp_gauge)
        self:set_act_gauge(info_t.Main.Act_left, info_t.Main.Act_gauge)

        local bal = self.PROJ.Style.STR.Balance
        self.tbs_menu_1.ExpPerMinC:setText(bal(string.format("%.2f", info_t.Stat.Exp_per_min)))
        self.tbs_menu_1.GoldPerMinC:setText(bal(string.format("%.2f", info_t.Stat.Gold_per_minute)))
        self.tbs_menu_1.ActPerMinC:setText(bal(string.format("%.2f", info_t.Stat.Act_per_minute)))
        self.tbs_menu_1.ExpPerActC:setText(bal(string.format("%.2f", info_t.Stat.Exp_per_act)))
        self.tbs_menu_1.GoldPerActC:setText(bal(string.format("%.2f", info_t.Stat.Gold_per_act)))
        self.tbs_menu_1.ActAmpC:setText(bal(string.format("%.2f", info_t.Stat.Act_amplifier)))

        self.tbs_menu_2.TodayExpC:setText(bal(string.format("%.2f", info_t.Statistics.Today_exp)))
        self.tbs_menu_2.TodayActC:setText(bal(string.format("%.2f", info_t.Statistics.Today_act)))
        self.tbs_menu_2.TodayGoldC:setText(bal(string.format("%.2f", info_t.Statistics.Today_gold)))
        self.tbs_menu_2.TotalExpC:setText(bal(string.format("%.2f", info_t.Statistics.Total_exp)))
        self.tbs_menu_2.TotalActC:setText(bal(string.format("%.2f", info_t.Statistics.Total_act)))
        self.tbs_menu_2.TotalGoldC:setText(bal(string.format("%.2f", info_t.Statistics.Total_gold)))

        self.tbs_menu_3.TotalSPC:setText(bal(string.format("%.0f", info_t.SkillState.Total_sp)))
        self.tbs_menu_3.LeftSPC:setText(bal(string.format("%.0f", info_t.SkillState.Left_sp)))
        self.tbs_menu_3.EffLevelC:setText(bal(string.format("%.0f", info_t.SkillState.Efficiency_level)))
        self.tbs_menu_3.ProLevelC:setText(bal(string.format("%.0f", info_t.SkillState.Proficiency_level)))
        self.tbs_menu_3.ConLevelC:setText(bal(string.format("%.0f", info_t.SkillState.Concentration_level)))

        if info_t.Main.Rank <= 4 then
            self.bt_skill.Visible = false
        else
            self.bt_skill.Visible = true
        end
    end
end

---set mode of info memu view
---@param mode Sallo.App.Scene.InfoMenu.eMode
function SCENE_L:setMode(mode)
    self.currMode = mode
    if mode == self.eMode.OWNER then
        self.bt_menu.Visible = true
        self.bt_skill.Visible = true
        self.bt_store.Visible = true
    elseif mode == self.eMode.VIEWER then
        self.bt_menu.Visible = false
        self.bt_skill.Visible = false
        self.bt_store.Visible = false
    else
        error("strange mode num " .. mode)
    end
end

return SCENE_L
