---@class &{Builder.Name}&.Handle
---@field new fun(self:&{Builder.Name}&.Handle):&{Builder.Name}&.Handle
local handle = &{classIncludeStr}&("&{Builder.Name}&.Handle")

---constructor
function handle:initialize()
    ---@type table<&{Builder.Name}&.Enum, fun(msg:&{Builder.Name}&.Msg, msgstruct:&{Builder:__makeHeaderClassName("IMsgStruct")}&)>
    self.__MsgStructMap = {}
end

---trigger handler from msg
---@param msgStr string
function handle:parse(msgStr)
    ---@type &{Builder.Name}&.Msg
    local msg = textutils.unserialize(msgStr)
    local func = self.__MsgStructMap[msg.Header]
    if func == nil then return nil end

    func(msg, textutils.unserialize(msg.MsgStructStr))
end

---attach message handle to header
---@param msgType &{Builder.Name}&.Header
---@param func fun(msg:&{Builder.Name}&.Msg, msgstruct:&{Builder:__makeHeaderClassName("IMsgStruct")}&)
function handle:attachMsgHandle(msgType, func)
    self.__MsgStructMap[msgType] = func
end

---detach message handle to header
---@param msgType &{Builder.Name}&.Header
function handle:detachMsgHandle(msgType)
    self.__MsgStructMap[msgType] = nil
end

---clear all message handle
function handle:clearAllMsgHandle()
    for k,v in self.__MsgStructMap do
        self.__MsgStructMap[k] = nil
    end
end

return handle