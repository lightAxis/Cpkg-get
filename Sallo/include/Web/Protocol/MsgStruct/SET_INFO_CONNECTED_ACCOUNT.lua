---@class Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field infoName string name of info to connect
---@field infoPasswd string password of info
---@field accountName string name of account to connect
---@field accountPasswd string passwd of account to connect
---@field accountOwner string owner of account to connect
---@field new fun():Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
    local a = {}

    ---@type string
    a.infoName = nil -- name of info to connect
    
    ---@type string
    a.infoPasswd = nil -- password of info
    
    ---@type string
    a.accountName = nil -- name of account to connect
    
    ---@type string
    a.accountPasswd = nil -- passwd of account to connect
    
    ---@type string
    a.accountOwner = nil -- owner of account to connect
    
    return a
end

return struct 
