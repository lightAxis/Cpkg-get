---@class Sallo.Web.Protocol.Struct.info_t
---@field Name string owner name of sallo info
---@field Password string password when used to revise the info content
---@field AccountName string account connected to this info
---@field Thema Sallo.Web.Protocol.Enum.THEMA thema enum
---@field Main Sallo.Web.Protocol.Struct.main_t main field of info
---@field Stat Sallo.Web.Protocol.Struct.stat_t stat field of info
---@field Statistics Sallo.Web.Protocol.Struct.statistics_t statistics fiedl of info
---@field SkillState Sallo.Web.Protocol.Struct.skillState_t skill state of info
---@field Histories table<number, Sallo.Web.Protocol.Struct.history_t> history field of info. go
---@field Items table<number, Sallo.Web.Protocol.Struct.item_t> owned items list for info
---@field SalaryLeft number salary left to send to player
---@field new fun():Sallo.Web.Protocol.Struct.info_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.info_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.info_t
    local a = {}

    ---@type string
    a.Name = nil -- owner name of sallo info
    
    ---@type string
    a.Password = nil -- password when used to revise the info content
    
    ---@type string
    a.AccountName = nil -- account connected to this info
    
    ---@type Sallo.Web.Protocol.Enum.THEMA
    a.Thema = -1 -- thema enum
    
    ---@type Sallo.Web.Protocol.Struct.main_t
    a.Main = {} -- main field of info
    
    ---@type Sallo.Web.Protocol.Struct.stat_t
    a.Stat = {} -- stat field of info
    
    ---@type Sallo.Web.Protocol.Struct.statistics_t
    a.Statistics = {} -- statistics fiedl of info
    
    ---@type Sallo.Web.Protocol.Struct.skillState_t
    a.SkillState = {} -- skill state of info
    
    ---@type table<number, Sallo.Web.Protocol.Struct.history_t>
    a.Histories = {} -- history field of info. go
    
    ---@type table<number, Sallo.Web.Protocol.Struct.item_t>
    a.Items = {} -- owned items list for info
    
    ---@type number
    a.SalaryLeft = nil -- salary left to send to player
    
    return a
end

return struct 
