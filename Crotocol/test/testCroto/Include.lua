---@class Crotocol.testProto
local protocol = {}

--- include Enums
protocol.Enum = require("Crotocol.test.testCroto.Enums")

--- include HeaderDef
protocol.Header = require("Crotocol.test.testCroto.HeaderDef")

--- include MsgDef 
protocol.Msg = require("Crotocol.test.testCroto.MsgDef")

--- include Structs
---@class Crotocol.testProto.Struct
protocol.Struct = {}
protocol.Struct.DRINK = require("Crotocol.test.testCroto.Struct.DRINK")
protocol.Struct.EAT = require("Crotocol.test.testCroto.Struct.EAT")

--- include MsgStructs
---@class Crotocol.testProto.MsgStruct
protocol.MsgStruct = {}
protocol.MsgStruct.GETHISTORY = require("Crotocol.test.testCroto.MsgStruct.GETHISTORY")

return protocol
