---@class Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_OWNER_LOGIN_R result enum
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
    local a = {}

    ---@type boolean
    a.Success = nil -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_OWNER_LOGIN_R
    a.State = -1 -- result enum
    
    return a
end

return struct 
