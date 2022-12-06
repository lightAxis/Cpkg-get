---@class Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_GET_INFO_R state enum of reply
---@field Success boolean success or not 
---@field Info Sallo.Web.Protocol.Struct.info_t serialized info str
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_GET_INFO_R
    a.State = -1 -- state enum of reply
    
    ---@type boolean
    a.Success = nil -- success or not 
    
    ---@type Sallo.Web.Protocol.Struct.info_t
    a.Info = {} -- serialized info str
    
    return a
end

return struct 
