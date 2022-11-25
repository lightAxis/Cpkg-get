---@class Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNERS : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field OwnerNames table<number, string> names of owners in server
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_GET_OWNERS_R result state
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNERS
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNERS
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNERS
    local a = {}

    ---@type table<number, string>
    a.OwnerNames = nil -- names of owners in server
    
    ---@type boolean
    a.Success = nil -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_GET_OWNERS_R
    a.State = -1 -- result state
    
    return a
end

return struct 
