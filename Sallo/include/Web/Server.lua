--- include
local THIS = PKGS.Sallo
local protocol = THIS.Web.Protocol
local handle = THIS.Web.Handle
local class = require("Class.middleclass")
local param = THIS.Param

local Golkin = DEPS.Sallo.Golkin
local Golkin_handle = Golkin.Web.Handle
local Golkin_protocol = Golkin.Web.Protocol
local Golkin_param = Golkin.ENV.CONST

---@class Sallo.Web.Server
---@field __Sallo_handle Sallo.Web.Protocol.Handle
---@field __Golkin_handle Golkin.Web.Protocol.Handle
---@field __PlayerQuaryTimerID number
---@field __ChatboxQueueTimerID number
---@field __requestTimeoutID number
---@field __TimeoutFun fun()
---@field __PlayerDetector Vef.AP.PlayerDetector
---@field __ChatBox Vef.AP.ChatBox
---@field __ChatBoxQueue table<number, Sallo.Web.Server.ChatBoxContent>
---@field __cachedInfos table<number, Sallo.Web.Protocol.Struct.info_t>
---@field __infoPath string
local Server = class("Sallo.Web.Server")


---@class Sallo.Web.Server.ChatBoxContent
---@field Msg string
---@field Prefix string
---@field Player string


function Server:initialize()
    self.__Sallo_handle = handle:new()
    self.__Golkin_handle = Golkin_handle:new()

    self.__PlayerQuaryTimerID = nil
    self.__ChatboxQueueTimerID = nil
    self.__RequestTimeoutID = nil
    self.__TimeoutFun = nil

    self.__GolkinServerID = nil

    self.__PlayerDetector = nil
    self.__ChatBox = nil
    self.__ChatBoxQueue = nil

    self.__cachedInfos = {}
    self.__infoPath = THIS.ENV.PATH .. param.Web.info_dir
end

---get golkin server id
---@return number|nil
function Server:getGolkinServerID()
    if self.__GolkinServerID == nil then
        local id = rednet.lookup(Golkin_param.protocol, Golkin_param.serverName)
        self.__GolkinServerID = id
        return id
    else
        return self.__GolkinServerID
    end
end

function Server:find_GolkinServerID()
    local id = self:getGolkinServerID()
    if id ~= nil then
        return id
    end

    local timer = os.startTimer(3)
    while true do
        print("there is no golkin server exist. retrying...")
        local a, b, c, d = os.pullEvent("timer")
        if b == timer then
            id = self:getGolkinServerID()
            if (id ~= nil) then
                return id
            end
            timer = os.startTimer(3)
        end
    end
end

function Server:find_peripheral(peripharalName, time)
    local peripharal = peripheral.find(peripharalName)
    if peripharal ~= nil then
        return peripharal
    end

    local timerID = os.startTimer(time)
    while true do
        print("cannot find " .. peripharalName .. ", retry...")
        local a, b, c, d = os.pullEvent()
        if a == "timer" and b == timerID then
            peripharal = peripheral.find(peripharalName)
            if peripharal ~= nil then
                print("found " .. peripharalName)
                os.cancelTimer(timerID)
                return peripharal
            else
                timerID = os.startTimer(time)
            end
        end
    end
end

---get account info from cache
---@param infoName string
---@return Sallo.Web.Protocol.Struct.info_t
function Server:__getInfoCache_byName(infoName)
    return self.__cachedInfos[infoName]
end

---remove account info from cache
---@param infoName string
function Server:__removeInfoCache_byName(infoName)
    self.__cachedInfos[infoName] = nil
end

---save account to cache
---@param info Sallo.Web.Protocol.Struct.info_t
function Server:__saveToInfoCache(info)
    self.__cachedInfos[info.name] = info
end

---get account info
---@param infoName string
---@return Sallo.Web.Protocol.Struct.info_t|nil
function Server:__getInfo(infoName)
    ---@type Sallo.Web.Protocol.Struct.info_t
    local account = self:__getInfoCache_byName(infoName)
    if account == nil then
        local accountPath = self.__infoPath .. "/" .. infoName .. ".sz"
        if (fs.exists(accountPath) == false) then
            return nil
        else
            local f = fs.open(accountPath, "r")
            account = textutils.unserialize(f.readAll())
            f.close()
            return account
        end
    end
    return account
end

function Server:start()
    print("open rednet in side : " .. CPKG.rednetSide)
    rednet.open(CPKG.rednetSide)

    print("start hosting in protocol : " .. param.Web.protocol .. " in node :" .. param.Web.serverName)
    rednet.host(param.Web.protocol, param.Web.serverName)

    print("find golkin server")
    self:find_GolkinServerID();

    print("find player detector")
    self.__PlayerDetector = self:find_peripheral(param.PlayerdetectorName)

    print("find chatbox")
    self.__ChatBox = self:find_peripheral(param.ChatBoxName)

    -- for test
    self.__PlayerDetector.getOnlinePlayers = function()
        return { "test1", "test2" }
    end
    self.__ChatBox.sendMessage = function(message, prefix)
        local a = peripheral.wrap("top")
        a.print("chatbox message : " .. message .. "/" .. prefix)
    end
    self.__ChatBox.sendMessageToPlayer = function(message, user, prefix)
        local a = peripheral.wrap("top")
        a.print("chatbox message : " .. message .. "/" .. prefix .. "/" .. user)
    end

    print("starting server main thread...")
    while true do
        -- rednet_message, fromID, msg, protocol
        local a, b, c, d = os.pullEvent()
        if a == "rednet_message" and d == param.Web.protocol then
            print("---------------")
            print("get Sallo msg from id : " .. b)
            self.__Sallo_handle:parse(c)
        end
        if a == "rednet_message" and d == Golkin_param.protocol then
            print("---------------")
            print("get Golkin msg from id : " .. b)
            self.__Golkin_handle:parse(c)
        end
        if a == "timer" and b == self.__PlayerQuaryTimerID then
            print("----------------")
            print("start quarying player datas..")
            self:__quaryPlayerData()
        end
        if a == "timer" and b == self.__ChatboxQueueTimerID then
            self:__ChatboxQueueCheck()
        end
        if a == "timer" and b == self.__requestTimeoutID then
            if (self.__TimeoutFun ~= nil) then
                self.__TimeoutFun()
            end
        end

    end
end

---send msg in protocol
---@param header Sallo.Web.Protocol.Header
---@param msgstruct Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@param idToSend number
function Server:__sendMsgStruct(header, msgstruct, idToSend)
    local msg = protocol.Msg:new()
    msg.Header = header
    msg.MsgStructStr = textutils.serialize(msgstruct)
    msg.SendID = os.getComputerID()
    msg.TargetID = idToSend
    rednet.send(idToSend, textutils.serialize(msg), param.Web.protocol)
end

---handle GET_INFO
---@param msg Sallo.Web.Protocol.Msg
---@param msgstruct Sallo.Web.Protocol.MsgStruct.GET_INFO
function Server:__handle_GET_INFO(msg, msgstruct)
    print("handle GET_INFO msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_INFO:new()
    local replyEnum = protocol.Enum.ACK_GET_INFO_R
    local replyHeader = protocol.Header.ACK_GET_INFO

    --- try query info table
    local info = self:__getInfo(msgstruct.name)
    if info == nil then
        replyMsgStruct.State = replyEnum.INFO_NOT_EXIST
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("INFO_NOT_EXIST")
        return nil
    end
    local passwd = info.Password
    info.Password = nil
    replyMsgStruct.Info = textutils.serialize(info)
    info.Password = passwd
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    print("good:" .. tostring(replyMsgStruct.State))
    print("SUCCESS")
end

---handle GET_INFOS msg
---@param msg Sallo.Web.Protocol.Msg
---@param msgstruct Sallo.Web.Protocol.MsgStruct.GET_INFOS
function Server:__handle_GET_INFOS(msg, msgstruct)
    print("handle GET_INFOS msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_INFOS:new()
    local replyEnum = protocol.Enum.ACK_GET_INFOS_R
    local replyHeader = protocol.Header.ACK_GET_INFOS

    -- chck cached info count
    if #(self.__cachedInfos) == 0 then
        replyMsgStruct.state = replyEnum.INFO_NOT_EXIST
        replyMsgStruct.success = replyEnum.NORMAL < replyMsgStruct.state
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    -- gen msgstruct
    local names = {}
    for k, v in pairs(self.__cachedInfos) do
        table.insert(names, v.Name)
    end
    replyMsgStruct.infos = names
    replyMsgStruct.state = replyEnum.SUCCESS
    replyMsgStruct.success = replyEnum.NORMAL < replyMsgStruct.state
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
end

function Server:__quaryPlayerData()

end

function Server:__ChatboxQueueCheck()

end
