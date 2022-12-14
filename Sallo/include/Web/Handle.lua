---@class Sallo.Web.Protocol.Handle
---@field new fun(self:Sallo.Web.Protocol.Handle):Sallo.Web.Protocol.Handle
local handle = require("Class.middleclass")("Sallo.Web.Protocol.Handle")

---constructor
function handle:initialize()
    ---@type table<Sallo.Web.Protocol.Enum, fun(msg:Sallo.Web.Protocol.Msg, msgstruct:Sallo.Web.Protocol.MsgStruct.IMsgStruct)>
    self.__MsgStructMap = {}
end

---trigger handler from msg
---@param msgStr string
---@return Sallo.Web.Protocol.Msg msg
---@return Sallo.Web.Protocol.MsgStruct.IMsgStruct msgStruct
function handle:parse(msgStr)
    ---@type Sallo.Web.Protocol.Msg
    local msg = textutils.unserialize(msgStr)
    local msgStruct = textutils.unserialize(msg.MsgStructStr)
    local func = self.__MsgStructMap[msg.Header]
    if func ~= nil then
        func(msg, msgStruct)
    end
    return msg, msgStruct
end

---attach message handle to header
---@param msgType Sallo.Web.Protocol.Header
---@param func fun(msg:Sallo.Web.Protocol.Msg, msgstruct:Sallo.Web.Protocol.MsgStruct.IMsgStruct)
function handle:attachMsgHandle(msgType, func)
    self.__MsgStructMap[msgType] = func
end

---detach message handle to header
---@param msgType Sallo.Web.Protocol.Header
function handle:detachMsgHandle(msgType)
    self.__MsgStructMap[msgType] = nil
end

---clear all message handle
function handle:clearAllMsgHandle()
    for k,v in pairs(self.__MsgStructMap) do
        self.__MsgStructMap[k] = nil
    end
end

return handle
