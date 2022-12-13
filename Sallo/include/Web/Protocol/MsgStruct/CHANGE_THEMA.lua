---@class Sallo.Web.Protocol.MsgStruct.CHANGE_THEMA : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field InfoName string info name to change
---@field InfoPasswd string info passwd to authenticate
---@field Thema Sallo.Web.Protocol.Enum.THEMA thema to change
---@field new fun():Sallo.Web.Protocol.MsgStruct.CHANGE_THEMA
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.CHANGE_THEMA
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.CHANGE_THEMA
    local a = {}

    ---@type string
    a.InfoName = nil -- info name to change
    
    ---@type string
    a.InfoPasswd = nil -- info passwd to authenticate
    
    ---@type Sallo.Web.Protocol.Enum.THEMA
    a.Thema = -1 -- thema to change
    
    return a
end

return struct 
