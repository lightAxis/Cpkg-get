---@class Sallo.Web.Protocol.Struct.main_t
---@field Level number level number of info
---@field Rank Sallo.Web.Protocol.Enum.RANK_NAME rank enum of info
---@field Exp_gauge number max guage of current rank info
---@field Exp number current exp filled
---@field Act_gauge number max act gauge
---@field Act_left number act point left today
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
    a.Exp_gauge = nil -- max guage of current rank info
    
    ---@type number
    a.Exp = nil -- current exp filled
    
    ---@type number
    a.Act_gauge = nil -- max act gauge
    
    ---@type number
    a.Act_left = nil -- act point left today
    
    return a
end

return struct 
