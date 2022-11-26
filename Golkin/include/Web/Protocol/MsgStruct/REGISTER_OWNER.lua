---@class Golkin.Web.Protocol.MsgStruct.REGISTER_OWNER : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field OwnerName string owner name to create
---@field Password string password for owner
---@field new fun():Golkin.Web.Protocol.MsgStruct.REGISTER_OWNER
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.REGISTER_OWNER
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.REGISTER_OWNER
    local a = {}

    ---@type string
    a.OwnerName = nil -- owner name to create
    
    ---@type string
    a.Password = nil -- password for owner
    
    return a
end

return struct 
