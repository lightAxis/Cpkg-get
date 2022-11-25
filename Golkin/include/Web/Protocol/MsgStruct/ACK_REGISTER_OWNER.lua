---@class Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_REGISTER_OWNER_R return state
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
    local a = {}

    ---@type boolean
    a.Success = nil -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_REGISTER_OWNER_R
    a.State = -1 -- return state
    
    return a
end

return struct 
