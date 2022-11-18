---@class Golkin.Web.Protocol.MsgStruct.ACK_GET_HISTORY : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Histories table<number, Golkin.Web.Protocol.Struct.History_t> history of account
---@field Success boolean success the request or not
---@field State Golkin.Web.Protocol.Enum.ACK_GET_HISTORY_R return state
---@field new fun():Golkin.Web.Protocol.MsgStruct.ACK_GET_HISTORY
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.ACK_GET_HISTORY
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.ACK_GET_HISTORY
    local a = {}

    ---@type table<number, Golkin.Web.Protocol.Struct.History_t>
    a.Histories = {} -- history of account
    
    ---@type boolean
    a.Success = nil -- success the request or not
    
    ---@type Golkin.Web.Protocol.Enum.ACK_GET_HISTORY_R
    a.State = -1 -- return state
    
    return a
end

return struct 
