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
protocol.Struct.Owner_t = require("Golkin.include.Web.Protocol.Struct.Owner_t")
protocol.Struct.Account_t = require("Golkin.include.Web.Protocol.Struct.Account_t")
protocol.Struct.Daytime_t = require("Golkin.include.Web.Protocol.Struct.Daytime_t")
protocol.Struct.History_t = require("Golkin.include.Web.Protocol.Struct.History_t")

--- include MsgStructs
---@class Golkin.Web.Protocol.MsgStruct
protocol.MsgStruct = {}
protocol.MsgStruct.OWNER_LOGIN = require("Golkin.include.Web.Protocol.MsgStruct.OWNER_LOGIN")
protocol.MsgStruct.ACK_REGISTER = require("Golkin.include.Web.Protocol.MsgStruct.ACK_REGISTER")
protocol.MsgStruct.REMOVE_ACCOUNT = require("Golkin.include.Web.Protocol.MsgStruct.REMOVE_ACCOUNT")
protocol.MsgStruct.ACK_SEND = require("Golkin.include.Web.Protocol.MsgStruct.ACK_SEND")
protocol.MsgStruct.SEND = require("Golkin.include.Web.Protocol.MsgStruct.SEND")
protocol.MsgStruct.ACK_GET_ACCOUNTS = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS")
protocol.MsgStruct.REGISTER = require("Golkin.include.Web.Protocol.MsgStruct.REGISTER")
protocol.MsgStruct.GET_OWNERS = require("Golkin.include.Web.Protocol.MsgStruct.GET_OWNERS")
protocol.MsgStruct.REGISTER_OWNER = require("Golkin.include.Web.Protocol.MsgStruct.REGISTER_OWNER")
protocol.MsgStruct.GET_OWNER_ACCOUNTS = require("Golkin.include.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS")
protocol.MsgStruct.ACK_OWNER_LOGIN = require("Golkin.include.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN")
protocol.MsgStruct.ACK_GET_ACCOUNT = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT")
protocol.MsgStruct.ACK_REMOVE_ACCOUNT = require("Golkin.include.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT")
protocol.MsgStruct.GET_ACCOUNT = require("Golkin.include.Web.Protocol.MsgStruct.GET_ACCOUNT")
protocol.MsgStruct.GET_ACCOUNTS = require("Golkin.include.Web.Protocol.MsgStruct.GET_ACCOUNTS")
protocol.MsgStruct.ACK_REGISTER_OWNER = require("Golkin.include.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER")
protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS")
protocol.MsgStruct.ACK_GET_OWNERS = require("Golkin.include.Web.Protocol.MsgStruct.ACK_GET_OWNERS")

return protocol
