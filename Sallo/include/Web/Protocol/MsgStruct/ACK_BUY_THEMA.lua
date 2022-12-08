---@class Sallo.Web.Protocol.MsgStruct.ACK_BUY_THEMA : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field state Sallo.Web.Protocol.Enum.ACK_BUY_THEMA_R result state enum
---@field banking_state number banking state from golkin
---@field success boolean success or not
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_BUY_THEMA
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_BUY_THEMA
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_BUY_THEMA
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_BUY_THEMA_R
    a.state = -1 -- result state enum
    
    ---@type number
    a.banking_state = -1 -- banking state from golkin
    
    ---@type boolean
    a.success = nil -- success or not
    
    return a
end

return struct 
