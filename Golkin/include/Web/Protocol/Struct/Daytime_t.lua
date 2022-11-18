---@class Golkin.Web.Protocol.Struct.Daytime_t
---@field Realtime string time string from server
---@field new fun():Golkin.Web.Protocol.Struct.Daytime_t
local struct = {}

---constructor
---@return Golkin.Web.Protocol.Struct.Daytime_t
function struct.new()
    ---@type Golkin.Web.Protocol.Struct.Daytime_t
    local a = {}

    ---@type string
    a.Realtime = nil -- time string from server
    
    return a
end

return struct 
