---@class Sallo.Web.Protocol.Struct.thema_t
---@field Enum Sallo.Web.Protocol.Enum.THEMA enum of thema
---@field Name string name of thema
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
    a.Enum = -1 -- enum of thema
    
    ---@type string
    a.Name = nil -- name of thema
    
    ---@type boolean
    a.isAquired = nil -- boolean is get?
    
    ---@type boolean
    a.isVisible = nil -- is visible in the rank?
    
    return a
end

return struct 
