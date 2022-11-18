---@class Golkin.Web.Protocol.MsgStruct.ACK_SEND : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Success boolean success the send action or not
---@field State Golkin.Web.Protocol.Enum.ACK_SEND_R result state to reply
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_SEND
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_SEND
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_SEND
    local a = {}

    ---@type boolean
    a.Success = nil -- success the send action or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_SEND_R
    a.State = -1 -- result state to reply
    
    return a
end

return struct 
