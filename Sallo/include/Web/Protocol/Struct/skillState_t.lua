---@class Sallo.Web.Protocol.Struct.skillState_t
---@field Total_sp number total skill point get until now
---@field Left_sp number skill point left
---@field Concentration_level number concentration skill level
---@field Efficiency_level number efficiency skill level
---@field Proficiency_level number proficiency skill level
---@field new fun():Sallo.Web.Protocol.Struct.skillState_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.skillState_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.skillState_t
    local a = {}

    ---@type number
    a.Total_sp = nil -- total skill point get until now
    
    ---@type number
    a.Left_sp = nil -- skill point left
    
    ---@type number
    a.Concentration_level = nil -- concentration skill level
    
    ---@type number
    a.Efficiency_level = nil -- efficiency skill level
    
    ---@type number
    a.Proficiency_level = nil -- proficiency skill level
    
    return a
end

return struct 
