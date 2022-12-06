---@class Sallo.Web.Protocol.Struct.stat_t
---@field Exp_per_min number exp per minute
---@field Cap_per_minute number cap usage per minute
---@field Gold_per_minute number goldary per minute
---@field Exp_per_cap number exp accisition per cap
---@field Cap_amplifier number cap amplifer for cap gauge
---@field Gold_per_cap number salaray per cap point
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
    a.Cap_per_minute = nil -- cap usage per minute
    
    ---@type number
    a.Gold_per_minute = nil -- goldary per minute
    
    ---@type number
    a.Exp_per_cap = nil -- exp accisition per cap
    
    ---@type number
    a.Cap_amplifier = nil -- cap amplifer for cap gauge
    
    ---@type number
    a.Gold_per_cap = nil -- salaray per cap point
    
    return a
end

return struct 
