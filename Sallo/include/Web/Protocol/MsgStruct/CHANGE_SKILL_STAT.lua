---@class Sallo.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field ownerName string owner name of info
---@field skillState Sallo.Web.Protocol.Struct.skillState_t skill state to reserve reset
---@field new fun():Sallo.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT
    local a = {}

    ---@type string
    a.ownerName = nil -- owner name of info
    
    ---@type Sallo.Web.Protocol.Struct.skillState_t
    a.skillState = nil -- skill state to reserve reset
    
    return a
end

return struct 
