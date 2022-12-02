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
    a.key = '"' .. rankNames[i] .. '"'
    a.content = {}
    a.content.rank_name = '"' .. rankNames[i] .. '"'
    a.content.rank_level = tostring(i)
    a.content.level_min = i * 10 - 10
    a.content.level_max = i * 10 - 1
    -- a.mxp_gauge = tostring(mxp_rank[i])
    -- a.mxp_total = tostring(mxp_stack[i])
    -- a.skill_pt = tostring(skill_pt)
    table.insert(glob.ranks, a)
end

cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_rank.lua")


--------------------level gen----------------
---comment
---@param total_num number
---@param total_mxp number
---@param a number
---@return table<number, number> tb_seg
---@return table<number, number> tb_total
local function gen_txp(total_num, total_mxp, a)
    local seg = 1 / total_num
    local tb_total = {}
    table.insert(tb_total, 0)
    for i = 1, total_num, 1 do
        local mxp = 0
        -- print(math.pow(seg * i, 2))
        mxp = ((seg * i) ^ a) * total_mxp
        mxp = math.floor(mxp + 0.5)
        table.insert(tb_total, mxp)
    end

    local tb_seg = {}

    for i = 1, total_num, 1 do
        table.insert(tb_seg, tb_total[i + 1] - tb_total[i])
    end
    table.remove(tb_total, 1)
    return tb_seg, tb_total
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
        table.insert(tb, math.floor((i + 0.01) / 30))
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

local mxp_rank, mxp_stack = gen_txp(total_level, basic_max_hour * xmp_per_minute * 60 * max_day, 2.2)
local skill_pt, skill_pt_stack = gen_sk_pt(total_level)

glob = {}
glob.className = "Sallo.Param.Level"
glob.ranks = {}
for i = 1, total_level, 1 do
    local a = {}
    a.key = i
    a.content = {}
    a.content.mxp_gauge = mxp_rank[i]
    a.content.mxp_stack = mxp_stack[i]
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
local EFF_max = 80
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
    a.key = i + 1
    a.content = {}
    a.content.Level = i
    a.content.TXP_per_ACT = tb_EFF_stat[i + 1]
    a.content.require_sp = i + 1
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_skill_EFF.lua")


glob = {}
glob.className = "Sallo.Param.Skill.Concentration"
glob.ranks = {}
for i = 0, #rankNames, 1 do
    local a = {}
    a.key = i + 1
    a.content = {}
    a.content.Level = i
    a.content.ACT_amplifier = tb_CON_stat[i + 1]
    a.content.require_sp = i + 1
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_skill_CON.lua")

glob = {}
glob.className = "Sallo.Param.Skill.Proficiency"
glob.ranks = {}
for i = 0, #rankNames, 1 do
    local a = {}
    a.key = i + 1
    a.content = {}
    a.content.Level = i
    a.content.SAL_per_ACT = tb_PRO_stat[i + 1]
    a.content.require_sp = i + 1
    table.insert(glob.ranks, a)
end
cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/param_template.em",
    PKGS.Sallo.ENV.PATH .. "/include/Param/param_skill_SAL.lua")
