---@class Sallo.Web.Protocol.MsgStruct.GET_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field Name string name of sallo info to request
---@field new fun():Sallo.Web.Protocol.MsgStruct.GET_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.GET_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.GET_INFO
    local a = {}

    ---@type string
    a.Name = nil -- name of sallo info to request
    
    return a
end

return struct 
