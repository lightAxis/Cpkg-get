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

    ---@type table<string, Tabullet.TextBlock>
    self.tbs_menu_1 = {}
    -- -@type table<string, Tabullet.TextBlock>
    self.tbs_menu_2 = {}
    -- -@type table<string, Tabullet.TextBlock>
    self.tbs_menu_3 = {}

    ---@type table<number, table<string, Tabullet.TextBlock>>
    self.tbs_menus = { [1] = self.tbs_menu_1, [2] = self.tbs_menu_2, [3] = self.tbs_menu_3 }

    self.eMenu = { ["stat"] = 1, ["state"] = 2, ["statistics"] = 3 }

    self.currMenu = self.eMenu.stat

    self:make_grid()

    ---@type Sallo.Web.Protocol.Struct.info_t
    self.selectedInfo = nil

    -- self:select_menu(self.eMenu.stat)
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

    self:make_grid_arrows(grid)
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

    local tb_username = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_username")
    tb_username:setText("[testUser]")
    self.PROJ.Style.TB.ListTitle(tb_username)
    self.tb_username = tb_username

    local tb_rankName = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_rankName")
    tb_rankName:setText("master challenger")
    self.PROJ.Style.TB.RankName(tb_rankName)
    self.tb_rankName = tb_rankName

    local pgb_exp_gauge = TBL.ProgressBar:new(self.rootScreenCanvas, self.attachingScreen, "pgb_exp_gauge")
    grid_main_infopanel1:setPosLen(pgb_exp_gauge, 1, 2, 1, 1)
    self.PROJ.Style.PGB.EXPBar(pgb_exp_gauge)
    pgb_exp_gauge:setValue(0.5)
    pgb_exp_gauge.BarDirection = TBL.Enums.Direction.horizontal
    self.pgb_exp_gauge = pgb_exp_gauge

    local tb_exp_gauge = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_exp_gauge")
    grid_main_infopanel1:setPosLen(tb_exp_gauge, 1, 2, 1, 1)
    self.PROJ.Style.TB.progressBar(tb_exp_gauge)
    tb_exp_gauge:setText("13224.33 / 44293 (26.35%)")
    self.tb_exp_gauge = tb_exp_gauge

    local pgb_cap_gauge = TBL.ProgressBar:new(self.rootScreenCanvas, self.attachingScreen, "pgb_cap_gauge")
    grid_main_infopanel1:setPosLen(pgb_cap_gauge, 1, 3, 1, 1)
    self.PROJ.Style.PGB.EXPBar2(pgb_cap_gauge)
    pgb_cap_gauge:setValue(0.5)
    pgb_cap_gauge.BarDirection = TBL.Enums.Direction.horizontal
    self.pgb_cap_gauge = pgb_cap_gauge

    local tb_cap_gauge = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_cap_gauge")
    grid_main_infopanel1:setPosLen(tb_cap_gauge, 1, 3, 1, 1)
    self.PROJ.Style.TB.progressBar(tb_cap_gauge)
    tb_cap_gauge:setText("13224.33 / 44293 (26.35%)")
    self.tb_cap_gauge = tb_cap_gauge

    self:set_exp_gauge(13224.33, 44293)
    self:set_cap_gauge(120, 480)
    self:set_info_top(132, "[testName!]", "master challenger")

    self:make_grid_info2(grid_main_infopanel1)
end

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
function SCENE_L:set_cap_gauge(now, max)
    local text = tostring(string.format("%.2f / %.2f (%.2f", now, max, 100 * now / max) .. "%)")
    self.pgb_cap_gauge:setValue(now / max)
    self.tb_cap_gauge:setText(text)
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
    self.tbs_menu_1.CapPerMinN, self.tbs_menu_1.CapPerMinC = self:make_grid_info_combo("CAP/min", 1, 7,
        grid_main_infopanel2)

    self.tbs_menu_1.ExpPerCapN, self.tbs_menu_1.ExpPerCapC = self:make_grid_info_combo("EXP/CAP", 3, 1,
        grid_main_infopanel2)
    self.tbs_menu_1.GoldPerCapN, self.tbs_menu_1.GoldPerCapC = self:make_grid_info_combo("GOLD/CAP", 3, 4,
        grid_main_infopanel2)
    self.tbs_menu_1.CapAmpN, self.tbs_menu_1.CapAmpC = self:make_grid_info_combo("CAP Amplifier", 3, 7,
        grid_main_infopanel2)



    self.tbs_menu_2.TodayExpN, self.tbs_menu_2.TodayExpC = self:make_grid_info_combo("EXP Today", 1, 1,
        grid_main_infopanel2)
    self.tbs_menu_2.TodayCapN, self.tbs_menu_2.TodayCapC = self:make_grid_info_combo("CAP Today", 1, 4,
        grid_main_infopanel2)
    self.tbs_menu_2.TodayGoldN, self.tbs_menu_2.TodayGoldC = self:make_grid_info_combo("GOLD Today", 1, 7,
        grid_main_infopanel2)

    self.tbs_menu_2.TotalExpN, self.tbs_menu_2.TotalExpC = self:make_grid_info_combo("EXP Total", 3, 1,
        grid_main_infopanel2)
    self.tbs_menu_2.TotalCapN, self.tbs_menu_2.TotalCapC = self:make_grid_info_combo("CAP Total", 3, 4,
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

function SCENE_L:select_menu(eMenu)
    local bs = { false, false, false }
    local left_visible = false
    local right_visible = false
    if (eMenu == self.eMenu.stat) then
        bs[1] = true
        right_visible = true
    elseif eMenu == self.eMenu.state then
        bs[2] = true
        left_visible = true
        right_visible = true
    elseif eMenu == self.eMenu.statistics then
        bs[3] = true
        left_visible = true
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

    local rankLevel = param.Rank[self.selectedInfo.main.rank].rank_level
    if rankLevel < 4 then
        self.tbs_menu_1.ExpPerCapN.Visible = false
        self.tbs_menu_1.ExpPerCapC.Visible = false
        self.tbs_menu_3.TotalSPN.Visible = false
        self.tbs_menu_3.TotalSPC.Visible = false
        self.tbs_menu_3.LeftSPN.Visible = false
        self.tbs_menu_3.LeftSPC.Visible = false
        self.tbs_menu_3.EffLevelN.Visible = false
        self.tbs_menu_3.EffLevelC.Visible = false
        if (eMenu == self.eMenu.state) then
            self.bt_right_arrow.Visible = false
        end
    end
    if rankLevel < 8 then
        self.tbs_menu_1.GoldPerCapN.Visible = false
        self.tbs_menu_1.GoldPerCapC.Visible = false
        self.tbs_menu_3.ProLevelN.Visible = false
        self.tbs_menu_3.ProLevelC.Visible = false
    end
    if rankLevel < 12 then
        self.tbs_menu_1.CapAmpN.Visible = false
        self.tbs_menu_1.CapAmpC.Visible = false
        self.tbs_menu_3.ConLevelN.Visible = false
        self.tbs_menu_3.ConLevelC.Visible = false
    end

end

function SCENE_L:refresh_info()
    if (self.selectedInfo ~= nil) then
        self:set_info_top(self.selectedInfo.main.level, self.selectedInfo.name, self.selectedInfo.main.rank)
        self:set_exp_gauge(self.selectedInfo.main.exp, self.selectedInfo.main.exp_gauge)
        self:set_cap_gauge(self.selectedInfo.main.cap_left, self.selectedInfo.main.cap_gauge)

        self.tbs_menu_1.ExpPerMinC:setText(string.format("%.2f", self.selectedInfo.stat.exp_per_min))
        self.tbs_menu_1.GoldPerMinC:setText(string.format("%.2f", self.selectedInfo.stat.gold_per_minute))
        self.tbs_menu_1.CapPerMinC:setText(string.format("%.2f", self.selectedInfo.stat.cap_per_minute))
        self.tbs_menu_1.ExpPerCapC:setText(string.format("%.2f", self.selectedInfo.stat.exp_per_cap))
        self.tbs_menu_1.GoldPerCapC:setText(string.format("%.2f", self.selectedInfo.stat.gold_per_cap))
        self.tbs_menu_1.CapAmpC:setText(string.format("%.2f", self.selectedInfo.stat.cap_amplifier))

        self.tbs_menu_2.TodayExpC:setText(string.format("%.2f", self.selectedInfo.statistics.today_exp))
        self.tbs_menu_2.TodayCapC:setText(string.format("%.2f", self.selectedInfo.statistics.today_cap))
        self.tbs_menu_2.TodayGoldC:setText(string.format("%.2f", self.selectedInfo.statistics.today_gold))
        self.tbs_menu_2.TotalExpC:setText(string.format("%.2f", self.selectedInfo.statistics.total_exp))
        self.tbs_menu_2.TodayCapC:setText(string.format("%.2f", self.selectedInfo.statistics.total_cap))
        self.tbs_menu_2.TotalGoldC:setText(string.format("%.2f", self.selectedInfo.statistics.total_gold))

        self.tbs_menu_3.TotalSPC:setText(string.format("%.2f", self.selectedInfo.skillState.total_sp))
        self.tbs_menu_3.LeftSPC:setText(string.format("%.2f", self.selectedInfo.skillState.left_sp))
        self.tbs_menu_3.EffLevelC:setText(string.format("%.2f", self.selectedInfo.skillState.efficiency_level))
        self.tbs_menu_3.ProLevelC:setText(string.format("%.2f", self.selectedInfo.skillState.proficiency_level))
        self.tbs_menu_3.ConLevelC:setText(string.format("%.2f", self.selectedInfo.skillState.concentration_level))
    end
end

---comment
---@param elem Tabullet.UIElement
function SCENE_L:addToMainInfoGroup(elem)

end

return SCENE_L
