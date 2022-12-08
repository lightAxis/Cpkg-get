---@class Sallo.Web.Protocol.Struct.statistics_t
---@field Today_exp number exp get today
---@field Today_act number act get today
---@field Today_gold number goldary get today
---@field Total_exp number exp get total
---@field Total_act number act get total
---@field Total_gold number goldary get total
---@field new fun():Sallo.Web.Protocol.Struct.statistics_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.statistics_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.statistics_t
    local a = {}

    ---@type number
    a.Today_exp = nil -- exp get today
    
    ---@type number
    a.Today_act = nil -- act get today
    
    ---@type number
    a.Today_gold = nil -- goldary get today
    
    ---@type number
    a.Total_exp = nil -- exp get total
    
    ---@type number
    a.Total_act = nil -- act get total
    
    ---@type number
    a.Total_gold = nil -- goldary get total
    
    return a
end

return struct 
