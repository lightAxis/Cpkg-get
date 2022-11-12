---@class Crotocol.testProto.Enum
local a = {}

---drink ! DF
---@enum Crotocol.testProto.Enum.BEVERAGE 
a.BEVERAGE = {
    ["coffee"] = -2, -- sucks
    ["NONE"] = -1, -- init
    ["pocari"] = 1, -- delicious
    ["orangeJuice"] = 2, -- jeju island!
}

---snack enum!
---@enum Crotocol.testProto.Enum.SNACK 
a.SNACK = {
    ["NONE"] = -1, -- init
    ["icecream"] = 0, -- snack1!
    ["sunchip"] = 1, -- snack2!
    ["pokachip"] = 2, -- snack3!
    ["otherchip"] = 3, -- is this snack?
}


return a
