require("Sallo.pkg_init")
local cg = DEPS.Sallo.EmLua.CodeGenerator:new()

--------------------rank gen----------------
--- rank
local rankNames = {
    "Bronze",
    "Silver",
    "Gold",
    "Platinum",
    "Diamond",
    "Master",
    "GrandMaster",
    "Challenger",
    "MasterChallenger",
    "Selendis",
    "Honor",
    "Rage",
    "Bahar",
    "Arcane",
    "BlueHole",
    "Skull",
}

local glob = {}
glob.ranks = {}
glob.className = "Sallo.Param.Rank"
for i = 1, #rankNames, 1 do
    local a = {}
    a.key = i
    a.content = {}
    a.content.rank_name = '"' .. rankNames[i] .. '"'
    a.content.rank_level = tostring(i)
    a.content.level_min = 10 * (i - 1)
    -- a.mxp_gauge = tostring(mxp_rank[i])
    -- a.mxp_total = tostring(mxp_stack[i])
    -- a.skill_pt = tostring(skill_pt)
    glob.ranks[i] = a
end
local a = {}
a.key = 0
a.content = {}
a.content.rank_name = '"Unranked"'
a.content.rank_level = "0"
a.content.level_min = 0
glob.ranks[0] = a

cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_rank.lua")


--------------------level gen----------------
---comment
---@return table<number, number> tb_seg
---@return table<number, number> tb_total
local function gen_txp()

    local total_num = 159
    local tb = {}
    table.insert(tb, 0)
    tb[1] = 100
    for i = 2, total_num, 1 do
        local d = 0
        if (i <= 39) then d = 1.214575
        elseif i <= 79 then d = 17.27767
        elseif i <= 119 then d = 26.0394
        elseif i <= 159 then d = 79.32645
        end
        tb[i] = tb[i - 1] + d
    end
    tb[total_num + 1] = -1

    local tb_total = {}
    tb_total[0] = 0
    for i = 1, total_num, 1 do
        tb_total[i] = tb_total[i - 1] + tb[i]
    end
    tb_total[0] = nil
    tb_total[total_num + 1] = tb_total[total_num]

    return tb, tb_total
end

---comment
---@param total_num number
---@param total_xmp number
---@param a number
local function gen_txp_2(total_num, total_xmp, a)
    local aa = (total_xmp / 10) ^ (1 / (total_num - 1))
    local tb = {}
    tb[1] = 10
    for i = 2, total_num, 1 do
        tb[i] = tb[i - 1] * aa
    end

    local tbtb = {}
    tbtb[0] = 0
    for i = 1, total_num, 1 do
        tbtb[i] = tbtb[i - 1] + tb[i]
    end

    return tb, tbtb
end

local function gen_sk_pt(total_num)
    local tb = {}
    for i = 1, total_num, 1 do
        local plus = 0
        if (i <= 39) then plus = 0
        elseif (i <= 79) then plus = 5
        elseif (i <= 119) then plus = 7
        elseif (i < 159) then plus = 9
        elseif (i >= 160) then plus = 160
        end
        tb[i] = plus
    end

    local tb_stack = {}
    tb_stack[0] = 0
    for i = 1, total_num, 1 do
        tb_stack[i] = tb_stack[i - 1] + tb[i]
    end

    return tb, tb_stack
end

local basic_max_hour = 8
local xmp_per_minute = 50
local max_day = 30
local total_level = 159

local mxp_rank, mxp_stack = gen_txp()
local skill_pt, skill_pt_stack = gen_sk_pt(total_level)

glob = {}
glob.className = "Sallo.Param.Level"
glob.ranks = {}
for i = 1, total_level, 1 do
    local a = {}
    a.key = i
    a.content = {}
    a.content.exp_gauge = mxp_rank[i]
    a.content.exp_stack = mxp_stack[i]
    a.content.skill_pt = skill_pt[i]
    a.content.skill_pt_stack = skill_pt_stack[i]
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_level.lua")


--------------------skill gen----------------
local function gen_sk(total_num, min, max)
    -- local amp = max - min
    -- local tb = {}
    -- local seg = 1 / total_num

    -- for i = 0, total_num, 1 do
    --     table.insert(tb, ((seg * i) ^ gain))
    -- end

    -- for i = 1, #tb, 1 do
    --     tb[i] = (tb[i] * amp) + min
    -- end
    local tb = {}
    for i = 0, total_num, 1 do
        table.insert(tb, (max - min) / (total_num) * (i) + min)
    end

    return tb
end

local skill_max_level = #rankNames
local skill_stat_amp = 2.0

local EFF_min = 10
local EFF_max = 100
local tb_EFF_stat = gen_sk(skill_max_level, EFF_min, EFF_max)

local CON_min = 1
local CON_max = 8
local tb_CON_stat = gen_sk(skill_max_level, CON_min, CON_max)
for i = 1, #tb_CON_stat, 1 do
    tb_CON_stat[i] = 8 / tb_CON_stat[i]
end
local temp = {}
for i = 1, #tb_CON_stat, 1 do
    table.insert(temp, tb_CON_stat[#tb_CON_stat - i + 1])
end
for i = 1, #temp, 1 do
    tb_CON_stat[i] = temp[i]
end

local PRO_min = 9160
local PRO_max = 37302
local tb_PRO_stat = gen_sk(skill_max_level, PRO_min, PRO_max)

glob = {}
glob.className = "Sallo.Param.Skill.Efficiency"
glob.ranks = {}
for i = 0, #rankNames, 1 do
    local a = {}
    a.key = i
    a.content = {}
    a.content.Level = i
    a.content.EXP_per_ACT = tb_EFF_stat[i + 1]
    local requiresp = 0
    if (i <= 3) then requiresp = 12
    elseif (i <= 7) then requiresp = 24
    elseif (i <= 11) then requiresp = 36
    elseif (i <= 15) then requiresp = 48
    else requiresp = -1
    end
    a.content.require_sp = requiresp
    local unlock_rank_level = i + 1
    if i < 4 then unlock_rank_level = 5 end
    a.content.unlock_rank_level = unlock_rank_level
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_skill_EFF.lua")


glob = {}
glob.className = "Sallo.Param.Skill.Concentration"
glob.ranks = {}
for i = 0, #rankNames, 1 do
    local a = {}
    a.key = i
    a.content = {}
    a.content.Level = i
    a.content.ACT_amplifier = tb_CON_stat[i + 1]
    local requiresp = 0
    if (i <= 3) then requiresp = 12
    elseif (i <= 7) then requiresp = 24
    elseif (i <= 11) then requiresp = 36
    elseif (i <= 15) then requiresp = 48
    else requiresp = -1
    end
    a.content.require_sp = requiresp
    local unlock_rank_level = i + 1
    if i < 8 then unlock_rank_level = 9 end
    a.content.unlock_rank_level = unlock_rank_level
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_skill_CON.lua")

glob = {}
glob.className = "Sallo.Param.Skill.Proficiency"
glob.ranks = {}
for i = 0, #rankNames, 1 do
    local a = {}
    a.key = i
    a.content = {}
    a.content.Level = i
    a.content.GOLD_per_ACT = tb_PRO_stat[i + 1]
    local requiresp = 0
    if (i <= 3) then requiresp = 12
    elseif (i <= 7) then requiresp = 24
    elseif (i <= 11) then requiresp = 36
    elseif (i <= 15) then requiresp = 48
    else requiresp = -1
    end
    a.content.require_sp = requiresp
    local unlock_rank_level = i + 1
    if i < 12 then unlock_rank_level = 13 end
    a.content.unlock_rank_level = unlock_rank_level
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_skill_PRO.lua")
