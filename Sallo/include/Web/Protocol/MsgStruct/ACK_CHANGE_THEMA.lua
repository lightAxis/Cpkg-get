---@class Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_THEMA : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_CHANGE_THEMA_R State reply
---@field Success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_THEMA
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_THEMA
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_THEMA
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_CHANGE_THEMA_R
    a.State = -1 -- State reply
    
    ---@type boolean
    a.Success = nil -- success or not
    
    return a
end

return struct 
