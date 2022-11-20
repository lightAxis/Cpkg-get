---@class Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field AccountName string name of the account to get
---@field Password string md5 hashed password for account
---@field new fun():Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
    local a = {}

    ---@type string
    a.AccountName = nil -- name of the account to get
    
    ---@type string
    a.Password = nil -- md5 hashed password for account
    
    return a
end

return struct 
