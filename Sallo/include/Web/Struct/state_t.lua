---@class Sallo.Web.Protocol.Struct.state_t
---@field level number level number of info
---@field rank Sallo.Web.Protocol.Enum.RANK_NAME rank enum of info
---@field salary number salary per hour number
---@field mxp_gauge number max guage of current rank info
---@field mxp number current mxp filled
---@field new fun():Sallo.Web.Protocol.Struct.state_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.state_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.state_t
    local a = {}

    ---@type number
    a.level = nil -- level number of info
    
    ---@type Sallo.Web.Protocol.Enum.RANK_NAME
    a.rank = -1 -- rank enum of info
    
    ---@type number
    a.salary = nil -- salary per hour number
    
    ---@type number
    a.mxp_gauge = nil -- max guage of current rank info
    
    ---@type number
    a.mxp = nil -- current mxp filled
    
    return a
end

return struct 
