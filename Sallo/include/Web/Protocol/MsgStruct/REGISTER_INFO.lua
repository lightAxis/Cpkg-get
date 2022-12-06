---@class Sallo.Web.Protocol.MsgStruct.REGISTER_INFO : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field ownerName number owner name of this info
---@field passwd string passwd using when edit this info
---@field new fun():Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
    local a = {}

    ---@type number
    a.ownerName = nil -- owner name of this info
    
    ---@type string
    a.passwd = nil -- passwd using when edit this info
    
    return a
end

return struct 
