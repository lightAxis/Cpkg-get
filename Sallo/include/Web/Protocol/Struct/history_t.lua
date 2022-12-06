---@class Sallo.Web.Protocol.Struct.history_t
---@field DateTime string time when this history made
---@field Data string content of history by raw string
---@field new fun():Sallo.Web.Protocol.Struct.history_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.history_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.history_t
    local a = {}

    ---@type string
    a.DateTime = nil -- time when this history made
    
    ---@type string
    a.Data = nil -- content of history by raw string
    
    return a
end

return struct 
