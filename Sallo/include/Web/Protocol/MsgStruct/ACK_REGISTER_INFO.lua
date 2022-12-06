---@class Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field state Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R result state enum
---@field success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_REGISTER_INFO
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R
    a.state = -1 -- result state enum
    
    ---@type boolean
    a.success = nil -- success or not
    
    return a
end

return struct 
