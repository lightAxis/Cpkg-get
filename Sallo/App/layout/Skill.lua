local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.Skill : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.Skill
local SCENE_L = class("Sallo.App.Layout.Skill", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Sallo.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    self.EFFs = {}
    self.PROs = {}
    self.CONs = {}
    self.SkillElems = { [1] = self.EFFs, [2] = self.PROs, [3] = self.CONs }

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

    local bt_apply = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_link")
    bt_apply:setText("Apply")
    grid:setPosLen(bt_apply, 5, 4)
    self.PROJ.Style.BT.Good(bt_apply)
    self.bt_apply = bt_apply

    self:make_grid_main(grid)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_main(grid_p)
    local grid_main = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_main:setHorizontalSetting({ "1", "*", "3", "*", "3", "*", "1" })
    grid_main:setVerticalSetting({ "1", "*", "1" })
    grid_main:updatePosLen()

    self:make_grid_left(grid_main)
    self:make_grid_middle(grid_main)
    self:make_grid_right(grid_main)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_table(grid_p)
    grid_p:setHorizontalSetting({ "*", "1", "1", "1" })
    grid_p:setVerticalSetting({ "1", "1", "1", "1", "1", "*" })
    grid_p:updatePosLen()
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_left(grid_p)
    local grid_left = grid_p:genSubGrid(nil, 2, 2)
    self:make_grid_table(grid_left)

    local tb_used_spN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_used_sp")
    tb_used_spN:setText("Used SP")
    grid_left:setPosLen(tb_used_spN, 1, 1, 4, 1)
    self.PROJ.Style.TB.InfoSuccess(tb_used_spN)

    local tb_used_spC = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_used_spC")
    tb_used_spC:setText("123")
    grid_left:setPosLen(tb_used_spC, 1, 2, 4, 1)
    self.PROJ.Style.TB.infoContent(tb_used_spC)
    tb_used_spC:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
    self.tb_used_spC = tb_used_spC

    local tb_EFF_N = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_EFF_N")
    tb_EFF_N:setText("Efficiency")
    grid_left:setPosLen(tb_EFF_N, 1, 4, 4, 1)
    self.PROJ.Style.TB.ListTitle(tb_EFF_N)
    table.insert(self.EFFs, tb_EFF_N)
    -- self.tb_EFF_N = tb_EFF_N

    local tb_EFF_Level = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_EFF_Level")
    tb_EFF_Level:setText("14")
    grid_left:setPosLen(tb_EFF_Level, 1, 5, 1, 1)
    self.PROJ.Style.TB.InfoSuccess(tb_EFF_Level)
    self.tb_EFF_Level = tb_EFF_Level
    table.insert(self.EFFs, tb_EFF_Level)

    local bt_EFF_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_EFF_down")
    bt_EFF_down:setText("-")
    grid_left:setPosLen(bt_EFF_down, 2, 5, 1, 1)
    self.PROJ.Style.BT.keypad(bt_EFF_down)
    self.bt_EFF_down = bt_EFF_down
    table.insert(self.EFFs, bt_EFF_down)

    local bt_EFF_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_EFF_up")
    bt_EFF_up:setText("+")
    grid_left:setPosLen(bt_EFF_up, 4, 5, 1, 1)
    self.PROJ.Style.BT.keypad(bt_EFF_up)
    self.bt_EFF_up = bt_EFF_up
    table.insert(self.EFFs, bt_EFF_up)

    local tb_EFF_desc = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_EFF_desc")
    tb_EFF_desc:setText("Increase Efficiency of working.\nEXP/ACT : 12\nSP need 12")
    grid_left:setPosLen(tb_EFF_desc, 1, 6, 4, 1)
    self.PROJ.Style.TB.infoContent(tb_EFF_desc)
    tb_EFF_desc:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.top)
    self.tb_EFF_desc = tb_EFF_desc
    table.insert(self.EFFs, tb_EFF_desc)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_middle(grid_p)
    local grid_middle = grid_p:genSubGrid(nil, 4, 2)
    self:make_grid_table(grid_middle)

    local tb_left_spN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_left_sp")
    tb_left_spN:setText("Left SP")
    grid_middle:setPosLen(tb_left_spN, 1, 1, 4, 1)
    self.PROJ.Style.TB.InfoSuccess(tb_left_spN)

    local tb_left_spC = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_left_spC")
    tb_left_spC:setText("123")
    grid_middle:setPosLen(tb_left_spC, 1, 2, 4, 1)
    self.PROJ.Style.TB.infoContent(tb_left_spC)
    tb_left_spC:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
    self.tb_left_spC = tb_left_spC

    local tb_PRO_N = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_PRO_N")
    tb_PRO_N:setText("Proficiency")
    grid_middle:setPosLen(tb_PRO_N, 1, 4, 4, 1)
    self.PROJ.Style.TB.ListTitle(tb_PRO_N)
    table.insert(self.PROs, tb_PRO_N)
    -- self.tb_EFF_N = tb_EFF_N

    local tb_PRO_Level = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_PRO_Level")
    tb_PRO_Level:setText("14")
    grid_middle:setPosLen(tb_PRO_Level, 1, 5, 1, 1)
    self.PROJ.Style.TB.InfoSuccess(tb_PRO_Level)
    self.tb_PRO_Level = tb_PRO_Level
    table.insert(self.PROs, tb_PRO_Level)

    local bt_PRO_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_PRO_down")
    bt_PRO_down:setText("-")
    grid_middle:setPosLen(bt_PRO_down, 2, 5, 1, 1)
    self.PROJ.Style.BT.keypad(bt_PRO_down)
    self.bt_PRO_down = bt_PRO_down
    table.insert(self.PROs, bt_PRO_down)

    local bt_PRO_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_PRO_up")
    bt_PRO_up:setText("+")
    grid_middle:setPosLen(bt_PRO_up, 4, 5, 1, 1)
    self.PROJ.Style.BT.keypad(bt_PRO_up)
    self.bt_PRO_up = bt_PRO_up
    table.insert(self.PROs, bt_PRO_up)

    local tb_PRO_desc = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_PRO_desc")
    tb_PRO_desc:setText("Increase Proficiency of working.\nGOLD/ACT : 2355.23\nSP need 24")
    grid_middle:setPosLen(tb_PRO_desc, 1, 6, 4, 1)
    self.PROJ.Style.TB.infoContent(tb_PRO_desc)
    tb_PRO_desc:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.top)
    self.tb_PRO_desc = tb_PRO_desc
    table.insert(self.PROs, tb_PRO_desc)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_right(grid_p)
    local grid_right = grid_p:genSubGrid(nil, 6, 2)
    self:make_grid_table(grid_right)

    local tb_total_spN = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_total_sp")
    tb_total_spN:setText("Total SP")
    grid_right:setPosLen(tb_total_spN, 1, 1, 4, 1)
    self.PROJ.Style.TB.InfoSuccess(tb_total_spN)

    local tb_total_spC = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_total_spC")
    tb_total_spC:setText("123")
    grid_right:setPosLen(tb_total_spC, 1, 2, 4, 1)
    self.PROJ.Style.TB.infoContent(tb_total_spC)
    tb_total_spC:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
    self.tb_total_spC = tb_total_spC

    local tb_CON_N = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_CON_N")
    tb_CON_N:setText("Concentration")
    grid_right:setPosLen(tb_CON_N, 1, 4, 4, 1)
    self.PROJ.Style.TB.ListTitle(tb_CON_N)
    table.insert(self.CONs, tb_CON_N)
    -- self.tb_EFF_N = tb_EFF_N

    local tb_CON_Level = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_CON_Level")
    tb_CON_Level:setText("14")
    grid_right:setPosLen(tb_CON_Level, 1, 5, 1, 1)
    self.PROJ.Style.TB.InfoSuccess(tb_CON_Level)
    self.tb_CON_Level = tb_CON_Level
    table.insert(self.CONs, tb_CON_Level)

    local bt_CON_down = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_CON_down")
    bt_CON_down:setText("-")
    grid_right:setPosLen(bt_CON_down, 2, 5, 1, 1)
    self.PROJ.Style.BT.keypad(bt_CON_down)
    self.bt_CON_down = bt_CON_down
    table.insert(self.CONs, bt_CON_down)

    local bt_CON_up = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_CON_up")
    bt_CON_up:setText("+")
    grid_right:setPosLen(bt_CON_up, 4, 5, 1, 1)
    self.PROJ.Style.BT.keypad(bt_CON_up)
    self.bt_CON_up = bt_CON_up
    table.insert(self.CONs, bt_CON_up)

    local tb_CON_desc = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_CON_desc")
    tb_CON_desc:setText("Increase Concentration of working.\nACT/min : 2355\nSP need 24")
    grid_right:setPosLen(tb_CON_desc, 1, 6, 4, 1)
    self.PROJ.Style.TB.infoContent(tb_CON_desc)
    tb_CON_desc:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.top)
    self.tb_CON_desc = tb_CON_desc
    table.insert(self.CONs, tb_CON_desc)
end

---comment
---@param skillState Sallo.Web.Protocol.Struct.skillState_t
---@param rank Sallo.Web.Protocol.Enum.RANK_NAME
function SCENE_L:refresh_display(skillState, rank)
    self.tb_left_spC:setText(tostring(skillState.Left_sp))
    self.tb_used_spC:setText(tostring(skillState.Total_sp - skillState.Left_sp))
    self.tb_total_spC:setText(tostring(skillState.Total_sp))

    local bs = { false, false, false }
    local EFFStat = param.Skill.EFF[skillState.Efficiency_level]
    if param.Skill.EFF[0].unlock_rank_level <= rank then
        local EFFstr = "Increase Efficiency of working.\n"
        EFFstr = EFFstr ..
            "EXP/ACT : " .. self.PROJ.Style.STR.Balance(string.format("%.2f", EFFStat.EXP_per_ACT)) .. "\n"
        EFFstr = EFFstr .. "next SP : " .. tostring(EFFStat.require_sp)
        self.tb_EFF_Level:setText(tostring(EFFStat.Level))
        self.tb_EFF_desc:setText(EFFstr)
        bs[1] = true
    end

    local PROStat = param.Skill.PRO[skillState.Proficiency_level]
    if param.Skill.PRO[0].unlock_rank_level <= rank then
        local PROstr = "Increase Proficiency of working\n"
        PROstr = PROstr ..
            "GOLD/ACT : " .. self.PROJ.Style.STR.Balance(string.format("%.2f", PROStat.GOLD_per_ACT)) .. "\n"
        PROstr = PROstr .. "next SP : " .. tostring(PROStat.require_sp)
        self.tb_PRO_Level:setText(tostring(PROStat.Level))
        self.tb_PRO_desc:setText(PROstr)
        bs[2] = true
    end

    local CONStat = param.Skill.CON[skillState.Concentration_level]
    if param.Skill.CON[0].unlock_rank_level <= rank then
        local CONstr = "Increate Concentration of workin\n"
        CONstr = CONstr ..
            "ACT amp : " .. self.PROJ.Style.STR.Balance(string.format("%.2f", CONStat.ACT_amplifier)) .. "\n"
        CONstr = CONstr .. "next SP : " .. tostring(CONStat.require_sp)
        self.tb_CON_Level:setText(tostring(CONStat.Level))
        self.tb_CON_desc:setText(CONstr)
        bs[3] = true
    end

    for i = 1, 3, 1 do
        for k, v in pairs(self.SkillElems[i]) do
            v.Visible = bs[i]
        end
    end


    local EFFStat_next = param.Skill.EFF[skillState.Efficiency_level + 1]
    local EFF_next_rq_rank = nil
    if EFFStat_next ~= nil then
        EFF_next_rq_rank = EFFStat_next.unlock_rank_level
    end

    local PROStat_next = param.Skill.PRO[skillState.Proficiency_level + 1]
    local PRO_next_rq_rank = nil
    if PROStat_next ~= nil then
        PRO_next_rq_rank = PROStat_next.unlock_rank_level
    end

    local CONStat_next = param.Skill.CON[skillState.Concentration_level + 1]
    local CON_next_rq_rank = nil
    if CONStat_next ~= nil then
        CON_next_rq_rank = CONStat_next.unlock_rank_level
    end

    self:refresh_updown(self.bt_EFF_up, self.bt_EFF_down,
        skillState.Efficiency_level, EFF_next_rq_rank, rank,
        skillState.Left_sp, EFFStat.require_sp)
    self:refresh_updown(self.bt_PRO_up, self.bt_PRO_down,
        skillState.Proficiency_level, PRO_next_rq_rank, rank,
        skillState.Left_sp, PROStat.require_sp)
    self:refresh_updown(self.bt_CON_up, self.bt_CON_down,
        skillState.Concentration_level, CON_next_rq_rank, rank,
        skillState.Left_sp, CONStat.require_sp)
end

---@param up Tabullet.Button
---@param down Tabullet.Button
---@param nowLevel number
---@param nextUnlockRankLevel number|nil
---@param rank number
---@param leftSP number
---@param requireSP number
function SCENE_L:refresh_updown(up, down, nowLevel, nextUnlockRankLevel, rank, leftSP, requireSP)
    if nowLevel <= 0 then
        down.Visible = false
    else
        down.Visible = true
    end

    if nowLevel > 17 or nextUnlockRankLevel > rank then
        up.Visible = false
    else
        up.Visible = true
    end

    if leftSP < requireSP then
        up.Visible = false
    end

end

return SCENE_L
