---@class Sallo.Web.Protocol.Struct.statistics_t
---@field today_exp number exp get today
---@field today_cap number cap get today
---@field today_gold number goldary get today
---@field total_exp number exp get total
---@field total_cap number cap get total
---@field total_gold number goldary get total
---@field new fun():Sallo.Web.Protocol.Struct.statistics_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.statistics_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.statistics_t
    local a = {}

    ---@type number
    a.today_exp = nil -- exp get today
    
    ---@type number
    a.today_cap = nil -- cap get today
    
    ---@type number
    a.today_gold = nil -- goldary get today
    
    ---@type number
    a.total_exp = nil -- exp get total
    
    ---@type number
    a.total_cap = nil -- cap get total
    
    ---@type number
    a.total_gold = nil -- goldary get total
    
    return a
end

return struct 
