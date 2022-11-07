---@class __Cpkg.Web.PkgLink.Msg
---@field Header __Cpkg.Web.PkgLink.Header header enum of msg
---@field SendID number sender ID
---@field TargetID number target ID to recieve msg
---@field MsgStructStr string all IMsgStruct serialized by textutils.serialize
---@field new fun():__Cpkg.Web.PkgLink.Msg
local msg = {}

---constructor
function msg.new()
    ---@type __Cpkg.Web.PkgLink.Msg
    local a = {}

    ---@type __Cpkg.Web.PkgLink.Header
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
