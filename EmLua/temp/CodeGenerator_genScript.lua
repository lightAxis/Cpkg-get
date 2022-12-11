local args = {...}
local __GenVariables = args[1]
local f = args[2]

local ranks = __GenVariables["ranks"]
local className = __GenVariables["className"]

f.writeLine("".."---@class "..className)
f.writeLine("".."local a = {")
for k,rank in pairs(ranks) do
f.writeLine("".."    ["..rank.key.."] = {")
for k,v in pairs(rank.content) do
f.writeLine("".."        [\""..k.."\"] = "..v..",")
end
f.writeLine("".."    },")
end
f.writeLine("".."}")
f.writeLine("".."return a")
