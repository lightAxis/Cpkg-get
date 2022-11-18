---@class Golkin.Web.Protocol.MsgStruct.GET_HISTORY : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field UserName string username to search history
---@field Count number count to read at server
---@field IDToSendBack number id to send back ack on this
---@field new fun():Golkin.Web.Protocol.MsgStruct.GET_HISTORY
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.GET_HISTORY
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.GET_HISTORY
    local a = {}

    ---@type string
    a.UserName = nil -- username to search history
    
    ---@type number
    a.Count = -1 -- count to read at server
    
    ---@type number
    a.IDToSendBack = nil -- id to send back ack on this
    
    return a
end

return struct 
