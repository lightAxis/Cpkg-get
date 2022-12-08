---@class Sallo.Web.Protocol.Struct.stat_t
---@field Exp_per_min number exp per minute
---@field Act_per_minute number act usage per minute
---@field Gold_per_minute number goldary per minute
---@field Exp_per_act number exp accisition per act
---@field Act_amplifier number act amplifer for act gauge
---@field Gold_per_act number salaray per act point
---@field new fun():Sallo.Web.Protocol.Struct.stat_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.stat_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.stat_t
    local a = {}

    ---@type number
    a.Exp_per_min = nil -- exp per minute
    
    ---@type number
    a.Act_per_minute = nil -- act usage per minute
    
    ---@type number
    a.Gold_per_minute = nil -- goldary per minute
    
    ---@type number
    a.Exp_per_act = nil -- exp accisition per act
    
    ---@type number
    a.Act_amplifier = nil -- act amplifer for act gauge
    
    ---@type number
    a.Gold_per_act = nil -- salaray per act point
    
    return a
end

return struct 
