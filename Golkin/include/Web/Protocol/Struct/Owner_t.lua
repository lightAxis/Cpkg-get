---@class Golkin.Web.Protocol.Struct.Owner_t
---@field Name string name of this owner
---@field Password string password of owner for login, MD5 hashed
---@field new fun():Golkin.Web.Protocol.Struct.Owner_t
local struct = {}

---constructor
---@return Golkin.Web.Protocol.Struct.Owner_t
function struct.new()
    ---@type Golkin.Web.Protocol.Struct.Owner_t
    local a = {}

    ---@type string
    a.Name = nil -- name of this owner
    
    ---@type string
    a.Password = nil -- password of owner for login, MD5 hashed
    
    return a
end

return struct 
