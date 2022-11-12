---@class &{Builder.Name}&
local protocol = {}

--- include Enums
protocol.Enum = require("&{Builder.RequirePrefix}&.Enums")

--- include HeaderDef
protocol.Header = require("&{Builder.RequirePrefix}&.HeaderDef")

--- include MsgDef 
protocol.Msg = require("&{Builder.RequirePrefix}&.MsgDef")

--- include Structs
---@class &{Builder.Name}&.Struct
protocol.Struct = {}
&[for k,Struct in pairs(Builder.Structs) do]&
protocol.Struct.&{Struct.Name}& = require("&{Builder.RequirePrefix}&.Struct.&{Struct.Name}&")
&[end]&

--- include MsgStructs
---@class &{Builder.Name}&.MsgStruct
protocol.MsgStruct = {}
&[for k,MsgStruct in pairs(Builder.Headers) do]&
protocol.MsgStruct.&{MsgStruct.Name}& = require("&{Builder.RequirePrefix}&.MsgStruct.&{MsgStruct.Name}&")
&[end]&

return protocol