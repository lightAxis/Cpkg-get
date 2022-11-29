---@class Sallo.Web.Protocol.Struct.info_t
---@field name string owner name of sallo info
---@field thema Sallo.Web.Protocol.Struct.thema_t thema struct field
---@field state Sallo.Web.Protocol.Struct.state_t state field of info
---@field statistics Sallo.Web.Protocol.Struct.statistics_t statistics fiedl of info
---@field skillState Sallo.Web.Protocol.Struct.skillState_t skill state of info
---@field histories table<number, Sallo.Web.Protocol.Struct.history_t> history field of info. go
---@field reserved_skillpt_reset Sallo.Web.Protocol.Struct.skillState_t reserved skillpoint reset setting from owner
---@field new fun():Sallo.Web.Protocol.Struct.info_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.info_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.info_t
    local a = {}

    ---@type string
    a.name = nil -- owner name of sallo info
    
    ---@type Sallo.Web.Protocol.Struct.thema_t
    a.thema = nil -- thema struct field
    
    ---@type Sallo.Web.Protocol.Struct.state_t
    a.state = {} -- state field of info
    
    ---@type Sallo.Web.Protocol.Struct.statistics_t
    a.statistics = {} -- statistics fiedl of info
    
    ---@type Sallo.Web.Protocol.Struct.skillState_t
    a.skillState = {} -- skill state of info
    
    ---@type table<number, Sallo.Web.Protocol.Struct.history_t>
    a.histories = {} -- history field of info. go
    
    ---@type Sallo.Web.Protocol.Struct.skillState_t
    a.reserved_skillpt_reset = nil -- reserved skillpoint reset setting from owner
    
    return a
end

return struct 
