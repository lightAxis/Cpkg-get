---@class Crotocol.testProto.Struct.DRINK
---@field Drinker string person who drink the beverage
---@field Bevarage Crotocol.testProto.Enum.BEVERAGE drinked bevarage
---@field new fun():Crotocol.testProto.Struct.DRINK
local struct = {}

---constructor
---@return Crotocol.testProto.Struct.DRINK
function struct.new()
    ---@type Crotocol.testProto.Struct.DRINK
    local a = {}

    ---@type string
    a.Drinker = "" -- person who drink the beverage
    
    ---@type Crotocol.testProto.Enum.BEVERAGE
    a.Bevarage = -1 -- drinked bevarage
    
    return a
end

return struct 
