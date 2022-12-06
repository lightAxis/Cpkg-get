---@class Sallo.Web.Protocol.Struct.main_t
---@field Level number level number of info
---@field Rank Sallo.Web.Protocol.Enum.RANK_NAME rank enum of info
---@field Salary number salary per hour number
---@field Exp_gauge number max guage of current rank info
---@field Exp number current exp filled
---@field Cap_gauge number max cap gauge
---@field Cap_left number cap point left today
---@field new fun():Sallo.Web.Protocol.Struct.main_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.main_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.main_t
    local a = {}

    ---@type number
    a.Level = nil -- level number of info
    
    ---@type Sallo.Web.Protocol.Enum.RANK_NAME
    a.Rank = -1 -- rank enum of info
    
    ---@type number
    a.Salary = nil -- salary per hour number
    
    ---@type number
    a.Exp_gauge = nil -- max guage of current rank info
    
    ---@type number
    a.Exp = nil -- current exp filled
    
    ---@type number
    a.Cap_gauge = nil -- max cap gauge
    
    ---@type number
    a.Cap_left = nil -- cap point left today
    
    return a
end

return struct 
