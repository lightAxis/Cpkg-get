---@class Golkin.Web.Protocol.MsgStruct.ACK_REGISTER : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_REGISTER_R state of request
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
    local a = {}

    ---@type boolean
    a.Success = nil -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_REGISTER_R
    a.State = -1 -- state of request
    
    return a
end

return struct 
