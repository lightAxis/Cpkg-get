---@class Sallo.Web.Protocol.Struct.skillState_t
---@field total_sp number total skill point get until now
---@field left_sp number skill point left
---@field reputation_level number reputation skill level
---@field efficiency_level number efficiency skill level
---@field proficiency_level number proficiency skill level
---@field new fun():Sallo.Web.Protocol.Struct.skillState_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.skillState_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.skillState_t
    local a = {}

    ---@type number
    a.total_sp = nil -- total skill point get until now
    
    ---@type number
    a.left_sp = nil -- skill point left
    
    ---@type number
    a.reputation_level = nil -- reputation skill level
    
    ---@type number
    a.efficiency_level = nil -- efficiency skill level
    
    ---@type number
    a.proficiency_level = nil -- proficiency skill level
    
    return a
end

return struct 
