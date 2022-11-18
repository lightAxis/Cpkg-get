---@class Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field IDToSendBack number id to send ack msg back
---@field new fun():Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS
    local a = {}

    ---@type number
    a.IDToSendBack = nil -- id to send ack msg back
    
    return a
end

return struct 
