---@class Sallo.Web.Protocol.MsgStruct.ACK_GET_LEADERBOARD_INFOS : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field State Sallo.Web.Protocol.Enum.ACK_GET_LEADERBOARD_INFOS_R reply state
---@field Success boolean success or not
---@field LeaderboardInfos table<number, Sallo.Web.Protocol.Struct.leaderboardInfo_t> leaderboard infos parsed
---@field new fun():Sallo.Web.Protocol.MsgStruct.ACK_GET_LEADERBOARD_INFOS
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.ACK_GET_LEADERBOARD_INFOS
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.ACK_GET_LEADERBOARD_INFOS
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ACK_GET_LEADERBOARD_INFOS_R
    a.State = -1 -- reply state
    
    ---@type boolean
    a.Success = nil -- success or not
    
    ---@type table<number, Sallo.Web.Protocol.Struct.leaderboardInfo_t>
    a.LeaderboardInfos = {} -- leaderboard infos parsed
    
    return a
end

return struct 
