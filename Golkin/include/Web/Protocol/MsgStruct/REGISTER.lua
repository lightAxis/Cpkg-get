---@class Golkin.Web.Protocol.MsgStruct.REGISTER : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field AccountName string account name to create
---@field OwnerName string owner name to register
---@field Password string password for account
---@field new fun():Golkin.Web.Protocol.MsgStruct.REGISTER
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.REGISTER
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.REGISTER
    local a = {}

    ---@type string
    a.AccountName = nil -- account name to create
    
    ---@type string
    a.OwnerName = nil -- owner name to register
    
    ---@type string
    a.Password = nil -- password for account
    
    return a
end

return struct 
