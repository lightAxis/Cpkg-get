---@class Golkin.Web.Protocol.MsgStruct.REGISTER : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field AccountName string account name to create
---@field UserName string username to register
---@field IDToSendBack number id to send reply back
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
    a.UserName = nil -- username to register
    
    ---@type number
    a.IDToSendBack = -1 -- id to send reply back
    
    return a
end

return struct 
