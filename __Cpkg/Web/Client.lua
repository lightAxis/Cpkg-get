---@class Cpkg.Web.Client
local client = {}

local protocol = require("__Cpkg.Web.PkgLink.Include")

local const = require("__Cpkg.Consts")
local tool = require("__Cpkg.Tool")

---request msg with timeout
---@param targetHeader __Cpkg.Web.PkgLink.Header target recieveing header
---@param duration number sec
---@param func fun()
---@return __Cpkg.Web.PkgLink.Msg|nil
function client.Req_with_timeout(targetHeader, duration, func)
    local timer_dur = os.startTimer(duration)
    local timer_tout = os.startTimer(const.WebConst.MaxTimeout)
    local serverID = tool.getServerID()
    func()

    while true do
        --- rednet_message, senderID, msg, protocol
        --- timer, timerID
        local a, b, c, d = os.pullEvent()

        if (a == "rednet_message" and
            d == const.WebConst.Protocol and
            b == serverID) then
            ---@type __Cpkg.Web.PkgLink.Msg
            local msg = textutils.unserialize(c)
            if (msg.Header == targetHeader) then
                return msg
            end
        elseif (a == "timer") then
            if (b == timer_dur) then
                timer_dur = os.startTimer(duration)
                func()
            elseif (b == timer_tout) then
                return nil
            end
        end
    end


end

---request pkg content
---@param pkgName string
function client.Req_pkgContent(pkgName)
    --- init msg
    local msg = protocol.Msg.new()
    msg.Header = protocol.Header.REQ_PKG_CONTENT
    msg.SendID = os.getComputerID()

    --- rednet look up cpkg server
    msg.TargetID = tool.getServerID()

    local msgStruct = protocol.MsgStruct.REQ_PKG_CONTENT.new()
    msgStruct.Name = pkgName

    msg.MsgStructStr = textutils.serialize(msgStruct)

    --- send msg to server
    rednet.send(msg.TargetID, textutils.serialize(msg), const.WebConst.Protocol)
end

---request file content to server
---@param absFilePath string abs file path. first get from server bt REQ_PKG_CONTENT msg
function client.Req_pkgFile(absFilePath)
    --- init msg
    local msg = protocol.Msg.new()
    msg.Header = protocol.Header.REQ_PKG_FILE
    msg.SendID = os.getComputerID()

    --- rednet lookup cpkg server
    msg.TargetID = tool.getServerID()

    local msgStruct = protocol.MsgStruct.REQ_PKG_FILE.new()
    msgStruct.reqFilePath = absFilePath

    msg.MsgStructStr = textutils.serialize(msgStruct)

    --- send msg to server
    rednet.send(msg.TargetID, textutils.serialize(msg), const.WebConst.Protocol)
end

function client.Req_pkgInfos()
    --- init msg
    local msg = protocol.Msg.new()
    msg.Header = protocol.Header.REQ_PKG_INFOS
    msg.SendID = os.getComputerID()

    --- rednet lookup cpkg server
    msg.TargetID = tool.getServerID()

    local msgStruct = protocol.MsgStruct.REQ_PKG_INFOS.new()

    msg.MsgStructStr = textutils.serialize(msgStruct)

    --- send msg to server
    rednet.send(msg.TargetID, textutils.serialize(msg), const.WebConst.Protocol)
end

return client
