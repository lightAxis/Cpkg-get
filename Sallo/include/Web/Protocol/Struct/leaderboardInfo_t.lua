---@class Sallo.Web.Protocol.Struct.leaderboardInfo_t
---@field Name string name of leaderboard info
---@field Level number Level of info
---@field Rank Sallo.Web.Protocol.Enum.RANK_NAME Rank of info
---@field TotalExp number total exp of info
---@field Thema Sallo.Web.Protocol.Enum.THEMA thema of info
---@field new fun():Sallo.Web.Protocol.Struct.leaderboardInfo_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.leaderboardInfo_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.leaderboardInfo_t
    local a = {}

    ---@type string
    a.Name = nil -- name of leaderboard info
    
    ---@type number
    a.Level = nil -- Level of info
    
    ---@type Sallo.Web.Protocol.Enum.RANK_NAME
    a.Rank = -1 -- Rank of info
    
    ---@type number
    a.TotalExp = nil -- total exp of info
    
    ---@type Sallo.Web.Protocol.Enum.THEMA
    a.Thema = -1 -- thema of info
    
    return a
end

return struct 
