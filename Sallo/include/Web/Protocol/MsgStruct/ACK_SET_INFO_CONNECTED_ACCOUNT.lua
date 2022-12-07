---@class Sallo.Web.Protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_SET_INFO_CONNECTED_ACCOUNT_R state of result
---@field BankErrorMsg string error msg from banking
---@field Success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_SET_INFO_CONNECTED_ACCOUNT_R
    a.State = -1 -- state of result
    
    ---@type string
    a.BankErrorMsg = nil -- error msg from banking
    
    ---@type boolean
    a.Success = nil -- success or not
    
    return a
end

return struct 
