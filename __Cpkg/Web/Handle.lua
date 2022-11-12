---@class __Cpkg.Web.PkgLink.Handle
---@field new fun(self:__Cpkg.Web.PkgLink.Handle):__Cpkg.Web.PkgLink.Handle
local handle = require("middleClass.include.middleClass")("__Cpkg.Web.PkgLink.Handle")

---constructor
function handle:initialize()
    ---@type table<__Cpkg.Web.PkgLink.Enum, fun(msg:__Cpkg.Web.PkgLink.Msg, msgstruct:__Cpkg.Web.PkgLink.MsgStruct.IMsgStruct)>
    self.__MsgStructMap = {}
end

---trigger handler from msg
---@param msgStr string
function handle:parse(msgStr)
    ---@type __Cpkg.Web.PkgLink.Msg
    local msg = textutils.unserialize(msgStr)
    local func = self.__MsgStructMap[msg.Header]
    if func == nil then return nil end

    func(msg, textutils.unserialize(msg.MsgStructStr))
end

---attach message handle to header
---@param msgType __Cpkg.Web.PkgLink.Header
---@param func fun(msg:__Cpkg.Web.PkgLink.Msg, msgstruct:__Cpkg.Web.PkgLink.MsgStruct.IMsgStruct)
function handle:attachMsgHandle(msgType, func)
    self.__MsgStructMap[msgType] = func
end

---detach message handle to header
---@param msgType __Cpkg.Web.PkgLink.Header
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
