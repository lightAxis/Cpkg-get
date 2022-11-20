---@class Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Owner string owner of the accounts
---@field new fun():Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS
    local a = {}

    ---@type string
    a.Owner = nil -- owner of the accounts
    
    return a
end

return struct 
