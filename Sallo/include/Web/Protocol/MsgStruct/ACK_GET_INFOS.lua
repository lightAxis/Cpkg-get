---@class Sallo.Web.Protocol.MsgStruct.ACK_GET_INFOS : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_GET_INFOS_R state of reply
---@field Success boolean success or not
---@field Infos table<number, Sallo.Web.Protocol.Struct.info_t> info name list from server
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_GET_INFOS
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_GET_INFOS
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_GET_INFOS
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_GET_INFOS_R
    a.State = -1 -- state of reply
    
    ---@type boolean
    a.Success = nil -- success or not
    
    ---@type table<number, Sallo.Web.Protocol.Struct.info_t>
    a.Infos = {} -- info name list from server
    
    return a
end

return struct 
