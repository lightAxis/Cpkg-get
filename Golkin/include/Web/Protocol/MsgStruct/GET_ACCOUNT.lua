---@class Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field UserName string name of the account to get
---@field IDToSendBack number id to send back account info
---@field new fun():Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
    local a = {}

    ---@type string
    a.UserName = nil -- name of the account to get
    
    ---@type number
    a.IDToSendBack = nil -- id to send back account info
    
    return a
end

return struct 
