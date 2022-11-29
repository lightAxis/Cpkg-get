---@class Sallo.Web.Protocol
local protocol = {}

--- include Enums
protocol.Enum = require("Sallo.include.Web.Protocol.Enums")

--- include HeaderDef
protocol.Header = require("Sallo.include.Web.Protocol.HeaderDef")

--- include MsgDef 
protocol.Msg = require("Sallo.include.Web.Protocol.MsgDef")

--- include Structs
---@class Sallo.Web.Protocol.Struct
protocol.Struct = {}
protocol.Struct.state_t = require("Sallo.include.Web.Protocol.Struct.state_t")
protocol.Struct.statistics_t = require("Sallo.include.Web.Protocol.Struct.statistics_t")
protocol.Struct.thema_t = require("Sallo.include.Web.Protocol.Struct.thema_t")
protocol.Struct.skillState_t = require("Sallo.include.Web.Protocol.Struct.skillState_t")
protocol.Struct.history_t = require("Sallo.include.Web.Protocol.Struct.history_t")
protocol.Struct.info_t = require("Sallo.include.Web.Protocol.Struct.info_t")

--- include MsgStructs
---@class Sallo.Web.Protocol.MsgStruct
protocol.MsgStruct = {}
protocol.MsgStruct.ACK_GET_INFO = require("Sallo.include.Web.Protocol.MsgStruct.ACK_GET_INFO")
protocol.MsgStruct.ACK_RESERVE_SKILLPT_RESET = require("Sallo.include.Web.Protocol.MsgStruct.ACK_RESERVE_SKILLPT_RESET")
protocol.MsgStruct.RESERVE_SKILLPT_RESET = require("Sallo.include.Web.Protocol.MsgStruct.RESERVE_SKILLPT_RESET")
protocol.MsgStruct.GET_INFO = require("Sallo.include.Web.Protocol.MsgStruct.GET_INFO")

return protocol
