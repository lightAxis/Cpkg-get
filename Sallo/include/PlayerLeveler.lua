local THIS = PKGS.Sallo
local param = PKGS.Sallo.Param

local class = require("Class.middleclass")

---@class Sallo.PlayerLeveler
---@field __info Sallo.Web.Protocol.Struct.info_t
local playerLeveler = class("Sallo.PlayerLeveler")

---constructor
---@param info_t Sallo.Web.Protocol.Struct.info_t
function playerLeveler:initialize(info_t)
    self.__info = info_t
end

---get player info inside
---@return Sallo.Web.Protocol.Struct.info_t
function playerLeveler:getPlayerInfo()
    return self.__info
end

function playerLeveler:refresh_stat()
    local info = self.__info
    info.Stat.Cap_amplifier = param.Skill.CON[info.SkillState.Concentration_level].ACT_amplifier
end

return playerLeveler
