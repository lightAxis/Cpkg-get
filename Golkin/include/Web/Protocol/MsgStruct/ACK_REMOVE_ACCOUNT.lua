---@class Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_REMOVE_ACCOUNT_R result state to reply
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT
    local a = {}

    ---@type boolean
    a.Success = nil -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_REMOVE_ACCOUNT_R
    a.State = -1 -- result state to reply
    
    return a
end

return struct 
