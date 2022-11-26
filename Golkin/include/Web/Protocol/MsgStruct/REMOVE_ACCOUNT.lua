---@class Golkin.Web.Protocol.MsgStruct.REMOVE_ACCOUNT : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field AccountName string name of account to remove
---@field OwnerName string name of owner of account to remove
---@field OwnerPassword string account of password to remove
---@field new fun():Golkin.Web.Protocol.MsgStruct.REMOVE_ACCOUNT
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.REMOVE_ACCOUNT
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.REMOVE_ACCOUNT
    local a = {}

    ---@type string
    a.AccountName = nil -- name of account to remove
    
    ---@type string
    a.OwnerName = nil -- name of owner of account to remove
    
    ---@type string
    a.OwnerPassword = nil -- account of password to remove
    
    return a
end

return struct 
