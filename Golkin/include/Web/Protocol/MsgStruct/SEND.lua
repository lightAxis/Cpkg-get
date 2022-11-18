---@class Golkin.Web.Protocol.MsgStruct.SEND : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field From string sending money from Account
---@field FromMsg string display msg as in sender history name
---@field To string recieve money from account
---@field ToMsg string display msg as in reciever history name
---@field Balance number balance to send
---@field IDToSendBack number ID to send back reply
---@field new fun():Golkin.Web.Protocol.MsgStruct.SEND
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.SEND
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.SEND
    local a = {}

    ---@type string
    a.From = nil -- sending money from Account
    
    ---@type string
    a.FromMsg = nil -- display msg as in sender history name
    
    ---@type string
    a.To = nil -- recieve money from account
    
    ---@type string
    a.ToMsg = nil -- display msg as in reciever history name
    
    ---@type number
    a.Balance = nil -- balance to send
    
    ---@type number
    a.IDToSendBack = nil -- ID to send back reply
    
    return a
end

return struct 
