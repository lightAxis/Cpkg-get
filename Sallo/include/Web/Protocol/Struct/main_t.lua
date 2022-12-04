---@class Sallo.Web.Protocol.Struct.main_t
---@field level number level number of info
---@field rank Sallo.Web.Protocol.Enum.RANK_NAME rank enum of info
---@field salary number salary per hour number
---@field exp_gauge number max guage of current rank info
---@field exp number current exp filled
---@field cap_gauge number max cap gauge
---@field cap_left number cap point left today
---@field new fun():Sallo.Web.Protocol.Struct.main_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.main_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.main_t
    local a = {}

    ---@type number
    a.level = nil -- level number of info
    
    ---@type Sallo.Web.Protocol.Enum.RANK_NAME
    a.rank = -1 -- rank enum of info
    
    ---@type number
    a.salary = nil -- salary per hour number
    
    ---@type number
    a.exp_gauge = nil -- max guage of current rank info
    
    ---@type number
    a.exp = nil -- current exp filled
    
    ---@type number
    a.cap_gauge = nil -- max cap gauge
    
    ---@type number
    a.cap_left = nil -- cap point left today
    
    return a
end

return struct 
