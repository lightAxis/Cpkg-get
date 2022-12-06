---@class Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_SKILL_STAT : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_CHANGE_SKILL_STAT_R return state
---@field Success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_SKILL_STAT
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_SKILL_STAT
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_SKILL_STAT
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_CHANGE_SKILL_STAT_R
    a.State = -1 -- return state
    
    ---@type boolean
    a.Success = nil -- success or not
    
    return a
end

return struct 
