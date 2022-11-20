---@class Golkin.Web.Protocol.Struct.History_t
---@field Name string name of this banking history
---@field InOut number input and output balance in this banking history
---@field BalanceLeft number balance left after this banking history
---@field Daytime Golkin.Web.Protocol.Struct.Daytime_t daytime when this history occured
---@field new fun():Golkin.Web.Protocol.Struct.History_t
local struct = {}

---constructor
---@return Golkin.Web.Protocol.Struct.History_t
function struct.new()
    ---@type Golkin.Web.Protocol.Struct.History_t
    local a = {}

    ---@type string
    a.Name = nil -- name of this banking history
    
    ---@type number
    a.InOut = nil -- input and output balance in this banking history
    
    ---@type number
    a.BalanceLeft = nil -- balance left after this banking history
    
    ---@type Golkin.Web.Protocol.Struct.Daytime_t
    a.Daytime = nil -- daytime when this history occured
    
    return a
end

return struct 
