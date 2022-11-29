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
    }
}

param.rank = require("Sallo.include.Param.param_rank")
param.skill = require("Sallo.include.Param.param_skill")

return param
