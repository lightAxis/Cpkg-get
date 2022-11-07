local args = {...}
local __GenVariables = args[1]
local f = args[2]

local Builder = __GenVariables["Builder"]
local Struct = __GenVariables["Struct"]
local MsgStruct = __GenVariables["MsgStruct"]

f.writeLine("".."---@class "..Builder.Name)
f.writeLine("".."local protocol = {}")
f.writeLine("")
f.writeLine("".."--- include Enums")
f.writeLine("".."protocol.Enum = require(\""..Builder.RequirePrefix..".Enums\")")
f.writeLine("")
f.writeLine("".."--- include HeaderDef")
f.writeLine("".."protocol.Header = require(\""..Builder.RequirePrefix..".HeaderDef\")")
f.writeLine("")
f.writeLine("".."--- include MsgDef ")
f.writeLine("".."protocol.Msg = require(\""..Builder.RequirePrefix..".MsgDef\")")
f.writeLine("")
f.writeLine("".."--- include Structs")
f.writeLine("".."---@class "..Builder.Name..".Struct")
f.writeLine("".."protocol.Struct = {}")
for k,Struct in pairs(Builder.Structs) do
f.writeLine("".."protocol.Struct."..Struct.Name.." = require(\""..Builder.RequirePrefix..".Struct."..Struct.Name.."\")")
end
f.writeLine("")
f.writeLine("".."--- include MsgStructs")
f.writeLine("".."---@class "..Builder.Name..".MsgStruct")
f.writeLine("".."protocol.MsgStruct = {}")
for k,MsgStruct in pairs(Builder.Headers) do
f.writeLine("".."protocol.MsgStruct."..MsgStruct.Name.." = require(\""..Builder.RequirePrefix..".MsgStruct."..MsgStruct.Name.."\")")
end
f.writeLine("")
f.writeLine("".."return protocol")
