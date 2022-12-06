---@class Sallo.Web.Protocol.MsgStruct.REGISTER_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field OwnerName string owner name of this info
---@field Passwd string passwd using when edit this info
---@field new fun():Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
    local a = {}

    ---@type string
    a.OwnerName = nil -- owner name of this info
    
    ---@type string
    a.Passwd = nil -- passwd using when edit this info
    
    return a
end

return struct 
