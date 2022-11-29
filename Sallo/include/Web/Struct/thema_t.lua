---@class Sallo.Web.Protocol.Struct.thema_t
---@field enum Sallo.Web.Protocol.Enum.THEMA enum of thema
---@field name string name of thema
---@field isAquired boolean boolean is get?
---@field isVisible boolean is visible in the rank?
---@field new fun():Sallo.Web.Protocol.Struct.thema_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.thema_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.thema_t
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.THEMA
    a.enum = -1 -- enum of thema
    
    ---@type string
    a.name = nil -- name of thema
    
    ---@type boolean
    a.isAquired = nil -- boolean is get?
    
    ---@type boolean
    a.isVisible = nil -- is visible in the rank?
    
    return a
end

return struct 
