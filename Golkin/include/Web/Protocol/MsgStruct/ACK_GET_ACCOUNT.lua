---@class Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Account Golkin.Web.Protocol.Struct.Account_t account table field
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNT_R result enum
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT
    local a = {}

    ---@type Golkin.Web.Protocol.Struct.Account_t
    a.Account = {} -- account table field
    
    ---@type boolean
    a.Success = false -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNT_R
    a.State = -1 -- result enum
    
    return a
end

return struct 
