---@class Golkin.Web.Protocol.MsgStruct.SEND : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field From string sending money from Account
---@field FromMsg string display msg as in sender history name
---@field OwnerName string owner of sender account
---@field Password string password of account
---@field To string recieve money from account
---@field ToMsg string display msg as in reciever history name
---@field Balance number balance to send
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
    a.OwnerName = nil -- owner of sender account
    
    ---@type string
    a.Password = nil -- password of account
    
    ---@type string
    a.To = nil -- recieve money from account
    
    ---@type string
    a.ToMsg = nil -- display msg as in reciever history name
    
    ---@type number
    a.Balance = nil -- balance to send
    
    return a
end

return struct 
