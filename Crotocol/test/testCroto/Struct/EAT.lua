---@class Crotocol.testProto.Struct.EAT
---@field Eater string person who eat food
---@field Snack Crotocol.testProto.Enum.SNACK eated food
---@field Count number eat time
---@field new fun():Crotocol.testProto.Struct.EAT
local struct = {}

---constructor
---@return Crotocol.testProto.Struct.EAT
function struct.new()
    ---@type Crotocol.testProto.Struct.EAT
    local a = {}

    ---@type string
    a.Eater = "" -- person who eat food
    
    ---@type Crotocol.testProto.Enum.SNACK
    a.Snack = -1 -- eated food
    
    ---@type number
    a.Count = 0 -- eat time
    
    return a
end

return struct 
