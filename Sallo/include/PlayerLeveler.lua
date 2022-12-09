local THIS = PKGS.Sallo
local param = PKGS.Sallo.Param

local class = require("Class.middleclass")

---@class Sallo.PlayerLeveler
---@field __info Sallo.Web.Protocol.Struct.info_t
---@field __ServerMsgs table<number, string>
---@field __PlayerMsgs table<number, string>
---@field new fun(self:Sallo.PlayerLeveler, info_t:Sallo.Web.Protocol.Struct.info_t):Sallo.PlayerLeveler
local playerLeveler = class("Sallo.PlayerLeveler")

---constructor
---@param info_t Sallo.Web.Protocol.Struct.info_t
function playerLeveler:initialize(info_t)
    self.__info = info_t
    self.__PlayerMsgs = {}
    self.__ServerMsgs = {}
end

---get player info inside
---@return Sallo.Web.Protocol.Struct.info_t
function playerLeveler:getPlayerInfo()
    return self.__info
end

---add chatbox event for player string
---@param string string
function playerLeveler:addPlayerMsg(string)
    table.insert(self.__PlayerMsgs, string)
end

---get playermsgs in playerleveler
---@return table<number, string> PlyerMsgs
---@return string InfoName
function playerLeveler:getPlayerMsg()
    return self.__PlayerMsgs, self.__info.Name
end

---get server msgs in playerleveler
---@return table<number, string> serverMsgs
function playerLeveler:getServerMsg()
    return self.__ServerMsgs
end

function playerLeveler:flushMsgs()
    self.__PlayerMsgs = {}
    self.__ServerMsgs = {}
end

--- add chatbox event for server string
---@param string string
function playerLeveler:addServerMsg(string)
    table.insert(self.__ServerMsgs, string)
end

--- refresh current stat state based on skillstate
function playerLeveler:refresh_stat()
    local info = self.__info

    -- act
    info.Stat.Act_amplifier = param.Skill.CON[info.SkillState.Concentration_level].ACT_amplifier
    info.Stat.Act_per_minute = param.ACT_per_min_default * info.Stat.Act_amplifier
    -- exp
    info.Stat.Exp_per_act = param.Skill.EFF[info.SkillState.Efficiency_level].EXP_per_ACT
    info.Stat.Exp_per_min = info.Stat.Exp_per_act * info.Stat.Act_per_minute
    -- gold
    info.Stat.Gold_per_act = param.Skill.PRO[info.SkillState.Proficiency_level].GOLD_per_ACT
    info.Stat.Gold_per_minute = info.Stat.Gold_per_act * info.Stat.Act_per_minute

    self.__info = info
end

function playerLeveler:addMin()
    local info = self.__info

    -- calc act
    local used_act = info.Stat.Act_per_minute
    info.Main.Act_left = info.Main.Act_left - info.Stat.Act_per_minute
    if info.Main.Act_left < 0 then
        used_act = used_act + info.Main.Act_left
        info.Main.Act_left = 0
    end
    info.Statistics.Today_act = info.Statistics.Today_act + used_act
    info.Statistics.Total_act = info.Statistics.Total_act + used_act


    -- calc exp
    local exp_get = info.Stat.Exp_per_act * used_act
    info.Statistics.Today_exp = info.Statistics.Today_exp + exp_get
    info.Statistics.Total_exp = info.Statistics.Total_exp + exp_get

    info.Main.Exp = info.Main.Exp + exp_get
    if info.Main.Exp_gauge < info.Main.Exp then
        local newLevel = self:levelUP()
        local msg = "Level UP! - " .. tostring(newLevel)
        if (newLevel == 40) then
            msg = msg .. " / Skill System Unlocked! / New Skill Unlocked! [Efficiency]"
        elseif newLevel == 80 then
            msg = msg .. " / New Skill Unlocked! [Proficiency]"
        elseif newLevel == 120 then
            msg = msg .. " / New Skill Unlocked! [Concentration]"
        end
        self:addPlayerMsg(msg)

        if newLevel % 10 == 0 then
            msg = info.Name .. " " .. msg
            self:addServerMsg(msg)
        end
    end

    -- calc gold
    local gold_get = info.Stat.Gold_per_act * used_act
    info.Statistics.Today_gold = info.Statistics.Today_gold + gold_get
    info.Statistics.Total_gold = info.Statistics.Total_gold + gold_get
end

---level up
---@return number newLevel
function playerLeveler:levelUP()
    local info = self.__info

    local next_level = info.Main.Level + 1
    info.Main.Level = next_level

    local left_exp = info.Main.Exp - info.Main.Exp_gauge
    info.Main.Exp_gauge = param.Level[next_level].exp_gauge
    info.Main.Exp = left_exp

    self.__info = info

    return next_level
end

--- add day to this account. nil if no gold get
---@return number|nil gold_today
function playerLeveler:addDay()
    -- reset act
    local info = self.__info
    info.Main.Act_gauge = param.ACT_TOTAL
    info.Main.Act_left = param.ACT_TOTAL

    -- get today gold
    local today_gold = nil
    if info.Statistics.Today_gold > 0.001 then
        today_gold = info.Statistics.Today_gold
    end

    if today_gold ~= nil then
        local msg = "Get Gold! : " .. string.format("%.2f", today_gold)
        self:addPlayerMsg(msg)
    end

    -- reset today statistics
    info.Statistics.Today_act = 0
    info.Statistics.Today_exp = 0
    info.Statistics.Today_gold = 0

    return today_gold
end

return playerLeveler
