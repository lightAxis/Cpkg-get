
---@class EmLua.CodeGenTestClass
---@field param1 string
---@field param2 number
---@field param3 table<number, string>
local codegentestclass_table = {}

--- constructor
function codegentestclass_table:initialize()
    ---@type string
    self.param1 = "init1"
    ---@type number
    self.param2 = 2903
    ---@type table<number, string>
    self.param3 = {[1] = "2", [2] = "33"}
end

return codegentestclass_table
