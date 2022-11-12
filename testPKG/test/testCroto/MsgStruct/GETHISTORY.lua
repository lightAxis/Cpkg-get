---@class Crotocol.testProto.MsgStruct.GETHISTORY : Crotocol.testProto.MsgStruct.IMsgStruct
---@field Count number count of history
---@field Owner string owner of this history
---@field Drinks table<number, Crotocol.testProto.Struct.DRINK> history of drinks!
---@field Eats table<number, Crotocol.testProto.Struct.EAT> history of eats!
---@field new fun():Crotocol.testProto.MsgStruct.GETHISTORY
local struct = {}

---constructor
---@return Crotocol.testProto.MsgStruct.GETHISTORY
function struct.new()
    ---@type Crotocol.testProto.MsgStruct.GETHISTORY
    local a = {}

    ---@type number
    a.Count = 0 -- count of history
    
    ---@type string
    a.Owner = "" -- owner of this history
    
    ---@type table<number, Crotocol.testProto.Struct.DRINK>
    a.Drinks = {} -- history of drinks!
    
    ---@type table<number, Crotocol.testProto.Struct.EAT>
    a.Eats = {} -- history of eats!
    
    return a
end

return struct 
