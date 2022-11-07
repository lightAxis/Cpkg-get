---@class __Cpkg.Web.PkgLink
local protocol = {}

--- include Enums
protocol.Enum = require("__Cpkg.Web.PkgLink.Enums")

--- include HeaderDef
protocol.Header = require("__Cpkg.Web.PkgLink.HeaderDef")

--- include MsgDef 
protocol.Msg = require("__Cpkg.Web.PkgLink.MsgDef")

--- include Structs
---@class __Cpkg.Web.PkgLink.Struct
protocol.Struct = {}
protocol.Struct.PkgInfo_t = require("__Cpkg.Web.PkgLink.Struct.PkgInfo_t")
protocol.Struct.PkgDep_t = require("__Cpkg.Web.PkgLink.Struct.PkgDep_t")

--- include MsgStructs
---@class __Cpkg.Web.PkgLink.MsgStruct
protocol.MsgStruct = {}
protocol.MsgStruct.PKG_CONTENT = require("__Cpkg.Web.PkgLink.MsgStruct.PKG_CONTENT")
protocol.MsgStruct.PKG_INFOS = require("__Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS")
protocol.MsgStruct.PKG_FILE = require("__Cpkg.Web.PkgLink.MsgStruct.PKG_FILE")
protocol.MsgStruct.REQ_PKG_CONTENT = require("__Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT")
protocol.MsgStruct.REQ_PKG_FILE = require("__Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE")
protocol.MsgStruct.REQ_PKG_INFOS = require("__Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_INFOS")

return protocol
