---@class Sallo.Web.Protocol.MsgStruct.ACK_RESERVE_SKILLPT_RESET : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field state Sallo.Web.Protocol.Enum.ACK_RESERVE_SKILLPT_RESET_R return state
---@field success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_RESERVE_SKILLPT_RESET
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_RESERVE_SKILLPT_RESET
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_RESERVE_SKILLPT_RESET
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_RESERVE_SKILLPT_RESET_R
    a.state = -1 -- return state
    
    ---@type boolean
    a.success = nil -- success or not
    
    return a
end

return struct 
