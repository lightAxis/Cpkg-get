local args = {...}
local __GenVariables = args[1]
local f = args[2]

local classDef = __GenVariables["classDef"]

f.writeLine("")
f.writeLine("".."---@class "..classDef.Name)
for k,v in pairs(classDef.Fields) do
f.writeLine("".."---@field "..v.param.." "..v.type)
end
f.writeLine("".."local "..classDef.tableName.." = {}")
f.writeLine("")
f.writeLine("".."--- constructor")
f.writeLine("".."function "..classDef.tableName..":initialize()")
for k,v in pairs(classDef.Fields) do
f.writeLine("".."    ---@type "..v.type)
f.writeLine("".."    self."..v.param.." = "..v.initValue)
end
f.writeLine("".."end")
f.writeLine("")
f.writeLine("".."return "..classDef.tableName)
