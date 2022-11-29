---@class Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field state Sallo.Web.Protocol.Enum.ACK_GET_INFO_R state enum of reply
---@field success boolean success or not 
---@field state_t Sallo.Web.Protocol.Struct.info_t serialized info str
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_GET_INFO_R
    a.state = -1 -- state enum of reply
    
    ---@type boolean
    a.success = nil -- success or not 
    
    ---@type Sallo.Web.Protocol.Struct.info_t
    a.state_t = {} -- serialized info str
    
    return a
end

return struct 
