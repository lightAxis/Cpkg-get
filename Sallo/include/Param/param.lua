---@class Sallo.param
local param = {
    ["account"] = {
        ["name"] = "Sallo_Corp",
        ["owner"] = "Sallo",
        ["passwd"] = "7654321",
    },

    ["hall_of_fame"] = "_ The Conquerer",

    ["Web"] = {
        ["protocol"] = "Sallo",
        ["serverName"] = "server",
        ["info_dir"] = "/userdata/infos"
    },

    ["PlayerdetectorName"] = "playerDetector",
    ["ChatBoxName"] = "chatBox",

    ["ACT_per_min_default"] = 10
}

param.Level = require("Sallo.include.Param.param_level")
param.Rank = require("Sallo.include.Param.param_rank")
param.Skill = {}
param.Skill.CON = require("Sallo.include.Param.param_skill_CON")
param.Skill.EFF = require("Sallo.include.Param.param_skill_EFF")
param.Skill.PRO = require("Sallo.include.Param.param_skill_PRO")
param.Price = {}
param.Price.Rank = require("Sallo.include.Param.param_rankPrice")
param.Price.Thema = require("Sallo.include.Param.param_rankthemaPrice")

return param
