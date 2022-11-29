require("Sallo.pkg_init")
local cg = DEPS.Sallo.EmLua.CodeGenerator:new()


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

local rankLevels = {}
local level = 1
for k, v in pairs(rankNames) do
    rankLevels[v] = level
    level = level + 1
end

---comment
---@param total_num number
---@param total_mxp number
---@param a number
---@return table<number, number> tb_seg
---@return table<number, number> tb_total
local function gen_hxp(total_num, total_mxp, a)
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

local function gen_sk(total_num)
    local tb = {}
    for i = 1, total_num, 1 do
        table.insert(tb, (i - 1) % 3)
    end
end

local basic_max_hour = 8
local xmp_per_minute = 27
local max_day = 30

local mxp_rank, mxp_stack = gen_hxp(#rankNames, basic_max_hour * xmp_per_minute * 60 * max_day, 2.2)
local skill_pt, skill_pt_stack = gen_sk(#rankNames)
local salary_rank, salary_stack

local glob = {}
glob.ranks = {}
for i = 1, #rankNames, 1 do
    local a = {}
    a.rank_name = '"' .. rankNames[i] .. '"'
    a.rank_level = tostring(i)
    a.mxp_gauge = tostring(mxp_rank[i])
    a.mxp_total = tostring(mxp_stack[i])
    a.skill_pt = tostring(skill_pt)
    table.insert(glob.ranks, a)
end

cg:GenCode(glob, PKGS.Sallo.ENV.PATH .. "/include/rank_template.em", PKGS.Sallo.ENV.PATH .. "/include/param_rank.lua")
