---@class Sallo.Web.Protocol.Struct.statistics_t
---@field total_workHour number total worked hour
---@field total_mxp number total mxp from start to now
---@field today_workHour number workhour of today
---@field today_leftHour number lefthour of today
---@field today_mxp number mxp get today
---@field new fun():Sallo.Web.Protocol.Struct.statistics_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.statistics_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.statistics_t
    local a = {}

    ---@type number
    a.total_workHour = nil -- total worked hour
    
    ---@type number
    a.total_mxp = nil -- total mxp from start to now
    
    ---@type number
    a.today_workHour = nil -- workhour of today
    
    ---@type number
    a.today_leftHour = nil -- lefthour of today
    
    ---@type number
    a.today_mxp = nil -- mxp get today
    
    return a
end

return struct 
