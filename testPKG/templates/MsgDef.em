---@class &{Builder.Name}&.Msg
---@field Header &{Builder.Name}&.Header header enum of msg
---@field SendID number sender ID
---@field TargetID number target ID to recieve msg
---@field MsgStructStr string all IMsgStruct serialized by textutils.serialize
---@field new fun():&{Builder.Name}&.Msg
local msg = {}

---constructor
function msg.new()
    ---@type &{Builder.Name}&.Msg
    local a = {}

    ---@type &{Builder.Name}&.Header
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