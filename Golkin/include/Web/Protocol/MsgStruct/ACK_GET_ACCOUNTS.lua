---@class Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field AccountsList table<number, string> list of account in server
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNTS_R return state of msg
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS
    local a = {}

    ---@type table<number, string>
    a.AccountsList = {} -- list of account in server
    
    ---@type boolean
    a.Success = false -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNTS_R
    a.State = {} -- return state of msg
    
    return a
end

return struct 
