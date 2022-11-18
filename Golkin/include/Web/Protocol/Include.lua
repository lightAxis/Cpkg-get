---@class Golkin.Web.Protocol
local protocol = {}

--- include Enums
protocol.Enum = require("Golkin.include.Web.Protocol.Enums")

--- include HeaderDef
protocol.Header = require("Golkin.include.Web.Protocol.HeaderDef")

--- include MsgDef 
protocol.Msg = require("Golkin.include.Web.Protocol.MsgDef")

--- include Structs
---@class Golkin.Web.Protocol.Struct
protocol.Struct = {}
protocol.Struct.Account_t = require("Golkin.include.Web.Protocol.Struct.Account_t")
protocol.Struct.Daytime_t = require("Golkin.include.Web.Protocol.Struct.Daytime_t")
protocol.Struct.History_t = require("Golkin.include.Web.Protocol.Struct.History_t")

--- include MsgStructs
---@class Golkin.Web.Protocol.MsgStruct
protocol.MsgStruct = {}
protocol.MsgStruct.ACK_REGISTER = require("Golkin.include.Web.Protocol.MsgStruct.ACK_REGISTER")
protocol.MsgStruct.ACK_GET_HISTORY = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_HISTORY")
protocol.MsgStruct.ACK_SEND = require("Golkin.include.Web.Protocol.MsgStruct.ACK_SEND")
protocol.MsgStruct.GET_ACCOUNT = require("Golkin.include.Web.Protocol.MsgStruct.GET_ACCOUNT")
protocol.MsgStruct.SEND = require("Golkin.include.Web.Protocol.MsgStruct.SEND")
protocol.MsgStruct.ACK_GET_ACCOUNTS = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS")
protocol.MsgStruct.GET_ACCOUNTS = require("Golkin.include.Web.Protocol.MsgStruct.GET_ACCOUNTS")
protocol.MsgStruct.GET_HISTORY = require("Golkin.include.Web.Protocol.MsgStruct.GET_HISTORY")
protocol.MsgStruct.REGISTER = require("Golkin.include.Web.Protocol.MsgStruct.REGISTER")
protocol.MsgStruct.ACK_GET_ACCOUNT = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT")

return protocol
