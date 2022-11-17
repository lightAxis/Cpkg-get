---@class Crotocol.testProto.Handle
---@field new fun(self:Crotocol.testProto.Handle):Crotocol.testProto.Handle
local handle = require("Class.middleclass")("Crotocol.testProto.Handle")

---constructor
function handle:initialize()
    ---@type table<Crotocol.testProto.Enum, fun(msg:Crotocol.testProto.Msg, msgstruct:Crotocol.testProto.MsgStruct.IMsgStruct)>
    self.__MsgStructMap = {}
end

---trigger handler from msg
---@param msgStr string
function handle:parse(msgStr)
    ---@type Crotocol.testProto.Msg
    local msg = textutils.unserialize(msgStr)
    local func = self.__MsgStructMap[msg.Header]
    if func == nil then return nil end

    func(msg, textutils.unserialize(msg.MsgStructStr))
end

---attach message handle to header
---@param msgType Crotocol.testProto.Header
---@param func fun(msg:Crotocol.testProto.Msg, msgstruct:Crotocol.testProto.MsgStruct.IMsgStruct)
function handle:attachMsgHandle(msgType, func)
    self.__MsgStructMap[msgType] = func
end

---detach message handle to header
---@param msgType Crotocol.testProto.Header
function handle:detachMsgHandle(msgType)
    self.__MsgStructMap[msgType] = nil
end

---clear all message handle
function handle:clearAllMsgHandle()
    for k, v in self.__MsgStructMap do
        self.__MsgStructMap[k] = nil
    end
end

return handle
