---@class Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R result state enum
---@field BankinState number bankin return state
---@field Success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R
    a.State = -1 -- result state enum
    
    ---@type number
    a.BankinState = nil -- bankin return state
    
    ---@type boolean
    a.Success = nil -- success or not
    
    return a
end

return struct 
