---@class Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Accounts table<number, Golkin.Web.Protocol.Struct.Account_t> accounts list
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R result enum
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
    local a = {}

    ---@type table<number, Golkin.Web.Protocol.Struct.Account_t>
    a.Accounts = {} -- accounts list
    
    ---@type boolean
    a.Success = false -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R
    a.State = -1 -- result enum
    
    return a
end

return struct 
