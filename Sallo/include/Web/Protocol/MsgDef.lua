---@class Sallo.Web.Protocol.Msg
---@field Header Sallo.Web.Protocol.Header header enum of msg
---@field SendID number sender ID
---@field TargetID number target ID to recieve msg
---@field MsgStructStr string all IMsgStruct serialized by textutils.serialize
---@field new fun():Sallo.Web.Protocol.Msg
local msg = {}

---constructor
function msg.new()
    ---@type Sallo.Web.Protocol.Msg
    local a = {}

    ---@type Sallo.Web.Protocol.Header
    a.Header = -1

    ---@type number
    a.SendID = -1

    ---@type number
    a.TargetID = -1

    ---@type string
    a.MsgStructStr = ""
    
    return a
end

return msg
