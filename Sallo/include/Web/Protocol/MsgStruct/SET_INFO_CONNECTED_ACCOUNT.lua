---@class Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field InfoName string name of info to connect
---@field InfoPasswd string password of info
---@field AccountName string name of account to connect
---@field AccountPasswd string passwd of account to connect
---@field AccountOwner string owner of account to connect
---@field new fun():Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
    local a = {}

    ---@type string
    a.InfoName = nil -- name of info to connect
    
    ---@type string
    a.InfoPasswd = nil -- password of info
    
    ---@type string
    a.AccountName = nil -- name of account to connect
    
    ---@type string
    a.AccountPasswd = nil -- passwd of account to connect
    
    ---@type string
    a.AccountOwner = nil -- owner of account to connect
    
    return a
end

return struct 
