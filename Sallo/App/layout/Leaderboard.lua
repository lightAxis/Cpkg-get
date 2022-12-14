local class = require("Class.middleclass")
local THIS = PKGS.Sallo
local param = THIS.Param

local TBL = DEPS.Golkin.Tabullet

---@class Sallo.App.Layout.Leaderboard : Tabullet.UILayout
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Sallo.App):Sallo.App.Layout.Leaderboard
local SCENE_L = class("Sallo.App.Layout.Leaderboard", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Sallo.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    self.__NameLen = -1
    self.__LeveLen = -1
    self.__RankLen = -1
    self.__TotalExpLen = -1

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
    title_textblock:setText("Leaderboard")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Who is the 1st?")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    local bt_refresh = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_link")
    bt_refresh:setText("Refresh")
    grid:setPosLen(bt_refresh, 5, 4)
    self.PROJ.Style.BT.Good(bt_refresh)
    self.bt_refresh = bt_refresh

    self:make_grid_main(grid)
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_main(grid_p)
    local grid_main = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_main:setHorizontalSetting({ "*", "14*", "5*", "16*", "12*", "*" })
    grid_main:setVerticalSetting({ "1", "1", "*", "1" })
    grid_main:updatePosLen()

    local tb_lbtitle_Name = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_lbtitle_Name")
    tb_lbtitle_Name:setText("Name")
    grid_main:setPosLen(tb_lbtitle_Name, 2, 2)
    self.PROJ.Style.TB.ListTitle(tb_lbtitle_Name)
    self.__NameLen = tb_lbtitle_Name.Len.x

    local tb_lbtitle_Level = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_lbtitle_Level")
    tb_lbtitle_Level:setText("Level")
    grid_main:setPosLen(tb_lbtitle_Level, 3, 2)
    self.PROJ.Style.TB.ListTitle(tb_lbtitle_Level)
    self.__LeveLen = tb_lbtitle_Level.Len.x

    local tb_lbtitle_Rank = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_lbtitle_Rank")
    tb_lbtitle_Rank:setText("Rank")
    grid_main:setPosLen(tb_lbtitle_Rank, 4, 1)
    self.PROJ.Style.TB.ListTitle(tb_lbtitle_Rank)
    self.__RankLen = tb_lbtitle_Rank.Len.x

    local tb_lbtitle_TotalExp = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb_lbtitle_TotalExp")
    tb_lbtitle_TotalExp:setText("TotalExp")
    grid_main:setPosLen(tb_lbtitle_TotalExp, 5, 1)
    self.PROJ.Style.TB.ListTitle(tb_lbtitle_TotalExp)
    self.__TotalExpLen = tb_lbtitle_TotalExp.Len.x

    local lb_leaderboard = TBL.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "lb_leaderboard")
    grid_main:setPosLen(lb_leaderboard, 2, 3, 4, 1)
    lb_leaderboard:setItemTemplate(function(obj)
        ---@cast obj Sallo.Web.Protocol.Struct.leaderboardInfo_t
        local NameStr = obj.Name
        local LevelStr = string.format("%.0f", obj.Level)
        local RankStr = param.Rank[obj.Rank].rank_name
        local TotalExpStr = string.format("%.2f", obj.TotalExp)

        local dispStr = ""
        dispStr = dispStr .. self:get_middle_str(NameStr, self.__NameLen)
        dispStr = dispStr .. self:get_middle_str(LevelStr, self.__LeveLen)
        dispStr = dispStr .. self:get_middle_str(RankStr, self.__RankLen)
        dispStr = dispStr .. self:get_middle_str(TotalExpStr, self.__TotalExpLen)
        local BG = TBL.Enums.Color[param.Thema[obj.Thema].BG]
        local FG = TBL.Enums.Color[param.Thema[obj.Thema].FG]

        return dispStr, BG, FG
    end)
    self.lb_leaderboard = lb_leaderboard

end

function SCENE_L:get_middle_str(str, len)
    local startPos = TBL.UITools.calcHorizontalAlignPos(1, #str, len, TBL.Enums.HorizontalAlignmentMode.center)

    local forwardLen = startPos - 1
    local backLen = len - forwardLen - #str

    return TBL.UITools.getEmptyString(forwardLen) .. str .. TBL.UITools.getEmptyString(backLen)
end

return SCENE_L
