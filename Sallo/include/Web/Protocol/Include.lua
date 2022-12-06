---@class Sallo.Web.Protocol
local protocol = {}

--- include Enums
protocol.Enum = require("Sallo.include.Web.Protocol.Enums")

--- include Enums_INV
protocol.Enum_INV = require("Sallo.include.Web.Protocol.Enums_INV")

--- include HeaderDef
protocol.Header = require("Sallo.include.Web.Protocol.HeaderDef")

--- include MsgDef 
protocol.Msg = require("Sallo.include.Web.Protocol.MsgDef")

--- include Structs
---@class Sallo.Web.Protocol.Struct
protocol.Struct = {}
protocol.Struct.main_t = require("Sallo.include.Web.Protocol.Struct.main_t")
protocol.Struct.statistics_t = require("Sallo.include.Web.Protocol.Struct.statistics_t")
protocol.Struct.thema_t = require("Sallo.include.Web.Protocol.Struct.thema_t")
protocol.Struct.history_t = require("Sallo.include.Web.Protocol.Struct.history_t")
protocol.Struct.skillState_t = require("Sallo.include.Web.Protocol.Struct.skillState_t")
protocol.Struct.stat_t = require("Sallo.include.Web.Protocol.Struct.stat_t")
protocol.Struct.info_t = require("Sallo.include.Web.Protocol.Struct.info_t")

--- include MsgStructs
---@class Sallo.Web.Protocol.MsgStruct
protocol.MsgStruct = {}
protocol.MsgStruct.ACK_REGISTER_INFO = require("Sallo.include.Web.Protocol.MsgStruct.ACK_REGISTER_INFO")
protocol.MsgStruct.ACK_GET_INFO = require("Sallo.include.Web.Protocol.MsgStruct.ACK_GET_INFO")
protocol.MsgStruct.GET_INFO = require("Sallo.include.Web.Protocol.MsgStruct.GET_INFO")
protocol.MsgStruct.GET_INFOS = require("Sallo.include.Web.Protocol.MsgStruct.GET_INFOS")
protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT = require("Sallo.include.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT")
protocol.MsgStruct.REGISTER_INFO = require("Sallo.include.Web.Protocol.MsgStruct.REGISTER_INFO")
protocol.MsgStruct.CHANGE_SKILL_STAT = require("Sallo.include.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT")
protocol.MsgStruct.ACK_CHANGE_SKILL_STAT = require("Sallo.include.Web.Protocol.MsgStruct.ACK_CHANGE_SKILL_STAT")
protocol.MsgStruct.ACK_GET_INFOS = require("Sallo.include.Web.Protocol.MsgStruct.ACK_GET_INFOS")
protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT = require("Sallo.include.Web.Protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT")

return protocol
