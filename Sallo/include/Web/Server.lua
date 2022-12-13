--- include
local THIS = PKGS.Sallo
local protocol = THIS.Web.Protocol
local handle = THIS.Web.Handle
local class = require("Class.middleclass")
local param = THIS.Param
local PlayerLeveler = THIS.PlayerLeveler

local Golkin = DEPS.Sallo.Golkin
local Golkin_handle = Golkin.Web.Handle
local Golkin_client = nil --Golkin.Web.Client:new()
local Golkin_protocol = Golkin.Web.Protocol
local Golkin_param = Golkin.ENV.CONST

---@class Sallo.Web.Server
---@field __Sallo_handle Sallo.Web.Protocol.Handle
---@field __Golkin_handle Golkin.Web.Protocol.Handle
---@field __PlayerQuaryTimerID number
---@field __lastPlayerQuaryMinuteStr string
---@field __lastPlayerQuaryDayStr string
---@field __ChatboxQueueTimerID number
---@field __RequestTimeoutID number
---@field __TimeoutFun fun()
---@field __PlayerDetector Vef.AP.PlayerDetector
---@field __ChatBox Vef.AP.ChatBox
---@field __ChatBoxQueue table<number, Sallo.Web.Server.ChatBoxContent>
---@field __cachedInfos table<string, Sallo.Web.Protocol.Struct.info_t>
---@field __infoPath string
---@field new fun(self:Sallo.Web.Server):Sallo.Web.Server
local Server = class("Sallo.Web.Server")


---@class Sallo.Web.Server.ChatBoxContent
---@field Msg string
---@field IsServerMsg boolean
---@field Prefix string
---@field Player string

---@class Sallo.Web.Server.Event_t
---@field a string
---@field b string
---@field c string
---@field d string


function Server:initialize()
    -- for test
    self.__tempCount = 0

    Golkin_client = Golkin.Web.Client:new()

    self.__Sallo_handle = handle:new()
    self.__Golkin_handle = Golkin_handle:new()

    ---@type table<number, Sallo.Web.Server.Event_t>
    self.__EventQueue = {}

    self.__PlayerQuaryTimerID = nil
    self.__PlayerQuaryDuration = 10
    self.__lastPlayerQuaryMinuteStr = nil
    self.__lastPlayerQuaryDayStr = nil

    self.__ChatboxQueueTimerID = nil
    self.__ChatboxQueueDuration = 30

    self.__GolkinServerID = nil

    self.__PlayerDetector = nil
    self.__ChatBox = nil
    self.__ChatBoxQueue = {}

    self.__cachedInfos = {}
    self.__infoPath = THIS.ENV.PATH .. param.Web.info_dir
    if (fs.exists(self.__infoPath) == false) then
        fs.makeDir(self.__infoPath)
    end
    local files = fs.list(self.__infoPath)
    for k, v in pairs(files) do
        local f = fs.open(self.__infoPath .. "/" .. v, "r")
        ---@type Sallo.Web.Protocol.Struct.info_t
        local info = textutils.unserialize(f.readAll())
        f.close()
        self.__cachedInfos[info.Name] = info
    end

    --- attach handler of sallo
    self.__Sallo_handle:attachMsgHandle(protocol.Header.CHANGE_SKILL_STAT, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT
        self:__handle_CHANGE_SKILL_STAT(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.GET_INFO, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.GET_INFO
        self:__handle_GET_INFO(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.GET_INFOS, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.GET_INFOS
        self:__handle_GET_INFOS(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.REGISTER_INFO, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
        self:__handle_REGISTER_INFO(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.SET_INFO_CONNECTED_ACCOUNT, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
        self:__handle_SET_INFO_CONNECTED_ACCOUNT(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.BUY_RANK, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.BUY_RANK
        self:__handle_BUY_RANK(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.BUY_THEMA, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.BUY_THEMA
        self:__handle_BUY_THEMA(msg, msgstruct)
    end)
    self.__Sallo_handle:attachMsgHandle(protocol.Header.CHANGE_THEMA, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.CHANGE_THEMA
        self:__handle_CHANGE_THEMA(msg, msgstruct)
    end)

    -- --- attach handler of golkin
    -- self.__Golkin_handle:attachMsgHandle(Golkin_protocol.Header.GET_ACCOUNT, function(msg, msgstruct)

    -- end)
    -- self.__Golkin_handle:attachMsgHandle(Golkin_protocol.Header.ACK_SEND, function(msg, msgstruct)

    -- end)
end

---await until new event recieved at queue or pullEvent
---@return string eventName
---@return string param1
---@return string param2
---@return string param3
function Server:__await_pullEvent()
    while true do
        ---@type Sallo.Web.Server.Event_t|nil
        local first = table.remove(self.__EventQueue, 1)
        if (first ~= nil) then
            return first.a, first.b, first.c, first.d
        end
        return os.pullEvent()
    end
end

---await until new target event recieved. stack other to event queue
---@return string eventName
---@return string param1
---@return string param2
---@return string param3
function Server:__await_pullEvent_protocol_header(SenderID, protocolName, protocolHandle, targetHeader, timeout)
    local timeoutID = nil

    if (timeout ~= nil) then
        if (timeout < 0) then
            error("timer value cannot under 0! : " .. tostring(timeout))
        end
        timeoutID = os.startTimer(timeout)
    end

    while true do
        local a, b, c, d = os.pullEvent()

        --- check message to come
        if a == "rednet_message" and
            SenderID ~= nil and
            b == SenderID and
            protocolName ~= nil and
            d == protocolName and
            protocolHandle ~= nil then
            local msg, msgstruct = protocolHandle:parse(c)
            if targetHeader ~= nil and msg.Header == targetHeader then
                if timeoutID ~= nil then
                    os.cancelTimer(timeoutID)
                end
                return a, b, c, d
            end
        end

        --- check if timeout occured
        if timeoutID ~= nil and a == "timer" and b == timeoutID then
            return a, b, c, d
        end

        --- all condition unmet, add to event queue
        table.insert(self.__EventQueue, { ["a"] = a, ["b"] = b, ["c"] = c, ["d"] = d })

    end
end

---wait until golkin msg come
---@param golkin_header Golkin.Web.Protocol.Header
---@param timeout number >0
---@return Golkin.Web.Protocol.Msg|nil msg nill when timeout
---@return Golkin.Web.Protocol.MsgStruct.IMsgStruct|nil msgStruct nill when timeout
function Server:__await_pullEvent_Golkin(golkin_header, timeout)
    local a, b, c, d = self:__await_pullEvent_protocol_header(self.__GolkinServerID, Golkin_param.protocol,
        self.__Golkin_handle,
        golkin_header, timeout)

    -- check is timeout
    if a ~= "rednet_message" then
        return nil, nil
    end

    ---@type Golkin.Web.Protocol.Msg
    local msg = textutils.unserialize(c)
    ---@type Golkin.Web.Protocol.MsgStruct.IMsgStruct
    local msgstruct = textutils.unserialize(msg.MsgStructStr)
    return msg, msgstruct
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
    print("cannot find " .. peripharalName .. ", retry after " .. tostring(time) .. " sec...")
    while true do
        local a, b, c, d = os.pullEvent()
        if a == "timer" and b == timerID then
            peripharal = peripheral.find(peripharalName)
            if peripharal ~= nil then
                print("found " .. peripharalName)
                os.cancelTimer(timerID)
                return peripharal
            else
                print("cannot find " .. peripharalName .. ", retry after " .. tostring(time) .. " sec...")
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
    self.__cachedInfos[info.Name] = info
end

---save account to server
---@param info Sallo.Web.Protocol.Struct.info_t
function Server:__saveInfo(info)
    self:__saveToInfoCache(info)
    local accountPath = self.__infoPath .. "/" .. info.Name .. ".sz"
    local f = fs.open(accountPath, "w")
    f.write(textutils.serialize(info))
    f.close()
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

function Server:make_new_info()
    --- make new info and send
    local new_info = protocol.Struct.info_t:new()
    new_info.Histories = {}

    local main_t = protocol.Struct.main_t:new()
    main_t.Act_gauge = param.ACT_TOTAL
    main_t.Act_left = param.ACT_TOTAL
    main_t.Exp = 0
    main_t.Exp_gauge = param.Level[1].exp_gauge
    main_t.Level = 1
    main_t.Rank = protocol.Enum.RANK_NAME.UNRANKED
    new_info.Main = main_t

    -- new_info.Name = msgstruct.OwnerName
    -- new_info.Password = msgstruct.Passwd

    local skillState_t = protocol.Struct.skillState_t:new()
    skillState_t.Concentration_level = 0
    skillState_t.Efficiency_level = 0
    skillState_t.Proficiency_level = 0
    skillState_t.Left_sp = 0
    skillState_t.Total_sp = 0
    new_info.SkillState = skillState_t

    local stat_t = protocol.Struct.stat_t:new()
    stat_t.Act_amplifier = param.Skill.CON[0].ACT_amplifier
    stat_t.Act_per_minute = param.ACT_per_min_default * stat_t.Act_amplifier
    stat_t.Exp_per_act = param.Skill.EFF[0].EXP_per_ACT
    stat_t.Exp_per_min = stat_t.Exp_per_act * stat_t.Act_per_minute
    stat_t.Gold_per_act = param.Skill.PRO[0].GOLD_per_ACT
    stat_t.Gold_per_minute = stat_t.Gold_per_act * stat_t.Act_per_minute
    new_info.Stat = stat_t

    local statistics_t = protocol.Struct.statistics_t:new()
    statistics_t.Today_act = 0
    statistics_t.Today_exp = 0
    statistics_t.Today_gold = 0
    statistics_t.Total_act = 0
    statistics_t.Total_exp = 0
    statistics_t.Total_gold = 0
    new_info.Statistics = statistics_t

    new_info.Thema = protocol.Enum.THEMA.NONE

    new_info.SalaryLeft = 0

    return new_info
end

function Server:__display_result_msg(isSuccess, stateNum, inv)
    if isSuccess == true then
        print("good:" .. tostring(stateNum))
    else
        print("error:" .. tostring(stateNum))
    end
    print(inv[stateNum])
end

function Server:start()
    print("open rednet in side : " .. CPKG.rednetSide)
    rednet.open(CPKG.rednetSide)

    print("start hosting in protocol : " .. param.Web.protocol .. " in node :" .. param.Web.serverName)
    rednet.host(param.Web.protocol, param.Web.serverName)

    print("find golkin server")
    self:find_GolkinServerID();

    print("find player detector")
    self.__PlayerDetector = self:find_peripheral(param.PlayerdetectorName, 3)

    print("find chatbox")
    self.__ChatBox = self:find_peripheral(param.ChatBoxName, 3)

    -- for test
    -- self.__PlayerDetector = {}
    -- self.__PlayerDetector.getOnlinePlayers = function()
    --     return { "test1", "test2", "test11" }
    -- end
    -- self.__ChatBox = {}
    -- self.__ChatBox.sendMessage = function(message, prefix)
    --     print("chatbox message : " .. message .. "/" .. prefix)
    -- end
    -- self.__ChatBox.sendMessageToPlayer = function(message, user, prefix)
    --     print("chatbox message : " .. message .. "/" .. prefix .. "/" .. user)
    -- end

    print("start ChatBox thread, 30 sec")
    self.__ChatboxQueueTimerID = os.startTimer(self.__ChatboxQueueDuration)

    print("start player detector thread, 10 sec")
    self.__PlayerQuaryTimerID = os.startTimer(self.__PlayerQuaryDuration)

    self.__lastPlayerQuaryDayStr = os.date('%d')
    self.__lastPlayerQuaryMinuteStr = os.date('%M')

    print("starting server main thread...")
    while true do
        -- rednet_message, fromID, msg, protocol
        local a, b, c, d = self:__await_pullEvent()
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
            self.__PlayerQuaryTimerID = os.startTimer(self.__PlayerQuaryDuration)
            print("player quary finished!")
        end
        if a == "timer" and b == self.__ChatboxQueueTimerID then
            print("----------------")
            print("start chatbox queue thread..")
            self:__ChatboxQueueCheck()
            self.__ChatboxQueueTimerID = os.startTimer(self.__ChatboxQueueDuration)
            print("chatbox finished!")
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
    local replyEnum_INV = protocol.Enum_INV.ACK_GET_INFO_R_INV
    local replyHeader = protocol.Header.ACK_GET_INFO

    --- try query info table
    local info = self:__getInfo(msgstruct.Name)
    if info == nil then
        replyMsgStruct.State = replyEnum.INFO_NOT_EXIST
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end
    local passwd = info.Password
    info.Password = nil
    local tempInfo = textutils.serialize(info)
    replyMsgStruct.Info = textutils.unserialize(tempInfo)
    info.Password = passwd
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

---handle GET_INFOS msg
---@param msg Sallo.Web.Protocol.Msg
---@param msgstruct Sallo.Web.Protocol.MsgStruct.GET_INFOS
function Server:__handle_GET_INFOS(msg, msgstruct)
    print("handle GET_INFOS msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_INFOS:new()
    local replyEnum = protocol.Enum.ACK_GET_INFOS_R
    local replyEnum_INV = protocol.Enum_INV.ACK_GET_INFOS_R_INV
    local replyHeader = protocol.Header.ACK_GET_INFOS

    local infoNames = {}
    for k, v in pairs(self.__cachedInfos) do
        table.insert(infoNames, k)
    end

    -- chck cached info count
    if #(infoNames) == 0 then
        replyMsgStruct.State = replyEnum.NO_INFO_EXIST
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- gen msgstruct
    replyMsgStruct.Infos = infoNames
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

---handle REGISTER_INFO msg
---@param msg Sallo.Web.Protocol.Msg
---@param msgstruct Sallo.Web.Protocol.MsgStruct.REGISTER_INFO
function Server:__handle_REGISTER_INFO(msg, msgstruct)
    print("handle REGISTER_INFO msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_REGISTER_INFO:new()
    local replyEnum = protocol.Enum.ACK_REGISTER_INFO_R
    local replyEnum_INV = protocol.Enum_INV.ACK_REGISTER_INFO_R_INV
    local replyHeader = protocol.Header.ACK_REGISTER_INFO

    --- check if prev info exist
    local prev_info = self:__getInfo(msgstruct.OwnerName)
    if (prev_info ~= nil) then
        replyMsgStruct.State = replyEnum.INFO_ALREADY_EXISTS
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check with golkin bank to see typed right
    -- print(msgstruct.OwnerName, msgstruct.Passwd)
    -- Golkin_client:send_get(msgstruct.OwnerName, msgstruct.Passwd)
    Golkin_client:send_OWNER_LOGIN(msgstruct.OwnerName, msgstruct.Passwd)

    local golkinMsg, golkinMsgStruct = self:__await_pullEvent_Golkin(
        Golkin_protocol.Header.ACK_OWNER_LOGIN, 1)
    ---@cast golkinMsgStruct Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN

    -- if timeout
    if golkinMsg == nil then
        replyMsgStruct.State = replyEnum.BANKING_REQUEST_TIMEOUT
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if result is not good
    if golkinMsgStruct.Success == false then
        local golkinReplyEnum_INV = Golkin_protocol.Enum_INV.ACK_OWNER_LOGIN_R_INV
        replyMsgStruct.State = replyEnum.BANKING_ERROR
        replyMsgStruct.Success = false
        replyMsgStruct.BankinState = golkinMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        self:__display_result_msg(false, golkinMsgStruct.State, golkinReplyEnum_INV)
        return nil
    end

    -- make new info
    local new_info = self:make_new_info()
    new_info.Name = msgstruct.OwnerName
    new_info.Password = msgstruct.Passwd

    -- save to file
    self:__saveInfo(new_info)

    -- send back reply
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = true
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

--- handle SET_INFO_ACCOUNT
---@param msg Sallo.Web.Protocol.Msg
---@param msgStruct Sallo.Web.Protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT
function Server:__handle_SET_INFO_CONNECTED_ACCOUNT(msg, msgStruct)
    print("handle SET_INFO_CONNECTED_ACCOUNT msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT:new()
    local replyEnum = protocol.Enum.ACK_SET_INFO_CONNECTED_ACCOUNT_R
    local replyHeader = protocol.Header.ACK_SET_INFO_CONNECTED_ACCOUNT
    local replyEnum_INV = protocol.Enum_INV.ACK_SET_INFO_CONNECTED_ACCOUNT_R_INV

    -- try parse info from cache
    local prev_info = self:__getInfo(msgStruct.InfoName)
    if prev_info == nil then
        replyMsgStruct.State = replyEnum.INFO_NOT_EXIST
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    --- check passwd unmet
    if prev_info.Password ~= msgStruct.InfoPasswd then
        replyMsgStruct.State = replyEnum.INFO_PASSWD_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- send golkin server to get account info
    Golkin_client:send_GET_ACCOUNT(msgStruct.AccountName, msgStruct.AccountPasswd)

    --- wait until golkin send and recieve golkin ack msgs, timeout 1 sec
    local golkinMsg, golkinMsgStruct = self:__await_pullEvent_Golkin(Golkin_protocol.Header.ACK_GET_ACCOUNT, 1)
    local golkin_replyEnum = Golkin_protocol.Enum.ACK_GET_ACCOUNT_R
    local golkin_replyEnum_INV = Golkin_protocol.Enum_INV.ACK_GET_ACCOUNT_R_INV
    ---@cast golkinMsgStruct Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT

    -- if bank request timeout
    if golkinMsg == nil then
        replyMsgStruct.State = replyEnum.BANKING_REQUEST_TIMEOUT
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if banking failed with no account error
    if golkinMsgStruct.State == golkin_replyEnum.NO_ACCOUNT_FOR_NAME then
        replyMsgStruct.State = replyEnum.ACCOUNT_NOT_EXIST
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check banking failed with password unmet
    if golkinMsgStruct.State == golkin_replyEnum.PASSWD_UNMET then
        replyMsgStruct.State = replyEnum.ACCOUNT_PASSWD_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check bank owner unmet
    if golkinMsgStruct.Account.Owner ~= msgStruct.AccountOwner then
        replyMsgStruct.State = replyEnum.ACCOUNT_OWNER_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check other bank error occured
    if golkinMsgStruct.Success == false then
        replyMsgStruct.State = replyEnum.BANKING_ERROR
        replyMsgStruct.BankErrorMsg = golkin_replyEnum_INV[golkinMsgStruct.State]
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        self:__display_result_msg(false, golkinMsgStruct.State, golkin_replyEnum_INV)
        return nil
    end

    -- fix account connected to new one
    prev_info.AccountName = msgStruct.AccountName
    -- save revised info
    self:__saveInfo(prev_info)

    -- return success msg
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = true
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

---handle CHANGE_SKILL_STAT
---@param msg Sallo.Web.Protocol.Msg
---@param msgStruct Sallo.Web.Protocol.MsgStruct.CHANGE_SKILL_STAT
function Server:__handle_CHANGE_SKILL_STAT(msg, msgStruct)
    print("handle CHANGE_SKILL_STAT msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_CHANGE_SKILL_STAT:new()
    local replyEnum = protocol.Enum.ACK_CHANGE_SKILL_STAT_R
    local replyEnum_INV = protocol.Enum_INV.ACK_CHANGE_SKILL_STAT_R_INV
    local replyHeader = protocol.Header.ACK_CHANGE_SKILL_STAT

    -- try parse info
    local prev_info = self:__getInfo(msgStruct.OwnerName)
    if prev_info == nil then
        replyMsgStruct.State = replyEnum.NO_OWNER_EXIST
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check skill state validity
    local valid = self:__checkSkillStateValid(msgStruct.SkillState, prev_info)
    if valid == false then
        replyMsgStruct.State = replyEnum.SKILL_UNLOCK_CONDITION_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- change skillstate to new one
    prev_info.SkillState = msgStruct.SkillState
    local playerLeveler = PlayerLeveler:new(prev_info)
    playerLeveler:refresh_stat()
    prev_info = playerLeveler:getPlayerInfo()
    self:__saveInfo(prev_info)

    -- return success
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = true
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

---check skill state validity
---@param skillState Sallo.Web.Protocol.Struct.skillState_t
---@param curr_info Sallo.Web.Protocol.Struct.info_t
---@return boolean result
function Server:__checkSkillStateValid(skillState, curr_info)
    -- check is skill make sense

    -- check skill level strange
    if skillState.Efficiency_level > 16 or skillState.Concentration_level > 16 or
        skillState.Proficiency_level > 16 or
        skillState.Efficiency_level < 0 or skillState.Concentration_level < 0 or
        skillState.Proficiency_level < 0 then
        print("skill level is starange, deny skill stat")
        return false
    end

    -- check skillstate total sp plus left sp to check with param
    local total_sp_basic = skillState.Total_sp
    if total_sp_basic ~= param.Level[curr_info.Main.Level].skill_pt_stack then
        print("total skill point is starange, deny skill stat")
        return false
    end

    -- impossible skill level for current rank check
    local curr_rank_level = param.Rank[curr_info.Main.Rank].rank_level
    if (skillState.Efficiency_level >= 1 and
        param.Skill.EFF[skillState.Efficiency_level].unlock_rank_level > curr_rank_level) or
        (skillState.Concentration_level >= 1 and
            param.Skill.CON[skillState.Concentration_level].unlock_rank_level > curr_rank_level) or
        (skillState.Proficiency_level >= 1 and
            param.Skill.PRO[skillState.Proficiency_level].unlock_rank_level > curr_rank_level) then
        print("skill unlock condition is strange, deny skill stat")
        return false
    end

    -- get total sp of all skills
    local used_sp = 0
    for i = 0, skillState.Efficiency_level, 1 do
        used_sp = used_sp + param.Skill.EFF[i].require_sp
    end
    for i = 0, skillState.Concentration_level, 1 do
        used_sp = used_sp + param.Skill.CON[i].require_sp
    end
    for i = 0, skillState.Proficiency_level, 1 do
        used_sp = used_sp + param.Skill.PRO[i].require_sp
    end
    used_sp = used_sp - param.Skill.EFF[skillState.Efficiency_level].require_sp
    used_sp = used_sp - param.Skill.CON[skillState.Concentration_level].require_sp
    used_sp = used_sp - param.Skill.PRO[skillState.Proficiency_level].require_sp

    -- check total used sp with skillstate used sp
    if (skillState.Total_sp - skillState.Left_sp) ~= used_sp then
        print("used skill point is strange. deny skill stat")
        return false
    end

    -- return true
    return true
end

---handle BUY_RANK msg
---@param msg Sallo.Web.Protocol.Msg
---@param msgStruct Sallo.Web.Protocol.MsgStruct.BUY_RANK
function Server:__handle_BUY_RANK(msg, msgStruct)
    print("handle BUY_RANK msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_BUY_RANK:new()
    local replyEnum = protocol.Enum.ACK_BUY_RANK_R
    local replyEnum_INV = protocol.Enum_INV.ACK_BUY_RANK_R_INV
    local replyHeader = protocol.Header.ACK_BUY_RANK

    -- try get current info
    local curr_info = self:__getInfo(msgStruct.OwnerName)
    if curr_info == nil then
        replyMsgStruct.State = replyEnum.NO_INFO
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if info passwd unmet
    if curr_info.Password ~= msgStruct.InfoPasswd then
        replyMsgStruct.State = replyEnum.SALLO_PASSWORD_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if reply msgstruct already achieved
    if curr_info.Main.Rank >= msgStruct.Rank then
        replyMsgStruct.State = replyEnum.RANK_ALREADY_EXIST
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check rank validity condition
    if param.Rank[msgStruct.Rank].level_min > curr_info.Main.Level or
        param.Rank[msgStruct.Rank].rank_rqr > curr_info.Main.Rank then
        replyMsgStruct.State = replyEnum.RANK_UNLOCK_CONDITION_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if there is no account linked
    if curr_info.AccountName == nil then
        replyMsgStruct.State = replyEnum.NO_CONNECTED_ACCOUNT
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- prepare send struct
    local send_t = Golkin_client:getSend_t()
    send_t.owner = curr_info.Name
    send_t.password = msgStruct.AccountPasswd
    send_t.from = curr_info.AccountName
    send_t.fromMsg = "buyRank"
    send_t.to = param.account.name
    send_t.toMsg = "buyRank"
    send_t.balance = param.Price.Rank[msgStruct.Rank].rankPrice

    -- send request to golkin server
    Golkin_client:send_SEND(send_t)

    -- await to get recieve, or timeout
    local golkin_msg, golkin_msgStruct = self:__await_pullEvent_Golkin(Golkin_protocol.Header.ACK_SEND, 1)
    ---@cast golkin_msgStruct Golkin.Web.Protocol.MsgStruct.ACK_SEND
    ---@cast golkin_msg Golkin.Web.Protocol.Msg
    local golkin_enum = Golkin_protocol.Enum.ACK_SEND_R
    local golkin_enum_INV = Golkin_protocol.Enum_INV.ACK_SEND_R_INV

    -- if timeout
    if golkin_msg == nil then
        replyMsgStruct.State = replyEnum.BANKING_REQUEST_TIMEOUT
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if banking has error
    if golkin_msgStruct.Success == false then
        replyMsgStruct.State = replyEnum.BANKING_ERROR
        replyMsgStruct.Success = false
        replyMsgStruct.banking_state = golkin_msgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        self:__display_result_msg(false, golkin_msgStruct.State, golkin_enum_INV)
        return nil
    end

    -- set account buy rank
    curr_info.Main.Rank = msgStruct.Rank
    self:__saveInfo(curr_info)

    -- send success
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = true
    replyMsgStruct.banking_state = golkin_msgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

---handle msg BUT_THEMA
---@param msg Sallo.Web.Protocol.Msg
---@param msgStruct Sallo.Web.Protocol.MsgStruct.BUY_THEMA
function Server:__handle_BUY_THEMA(msg, msgStruct)
    print("handle BUY_THEMA msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_BUY_THEMA:new()
    local replyEnum = protocol.Enum.ACK_BUY_THEMA_R
    local replyEnum_INV = protocol.Enum_INV.ACK_BUY_THEMA_R_INV
    local replyHeader = protocol.Header.ACK_BUY_THEMA

    -- try get current info
    local curr_info = self:__getInfo(msgStruct.OwnerName)
    if curr_info == nil then
        replyMsgStruct.State = replyEnum.NO_INFO
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if info passwd unmet
    if curr_info.Password ~= msgStruct.InfoPasswd then
        replyMsgStruct.State = replyEnum.SALLO_PASSWORD_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check item already exist
    local thema_already_exist = false
    for k, v in pairs(curr_info.Items) do
        if v.ItemType == protocol.Enum.ITEM_TYPE.THEMA and
            v.ItemIndex == msgStruct.Thema then
            thema_already_exist = true
        end
    end
    if thema_already_exist == true then
        replyMsgStruct.State = replyEnum.THEMA_ALREADY_EXIST
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- check rank validity condition
    local required_thema_exist = false
    if param.Price.Thema[msgStruct.Thema] ~= nil then
        local required_thema = param.Price.Thema[msgStruct.Thema].unlocked_thema_level
        for k, v in pairs(curr_info.Items) do
            if v.ItemType == protocol.Enum.ITEM_TYPE.THEMA and
                v.ItemIndex == required_thema then
                print(v.ItemType, v.ItemIndex)
                required_thema_exist = true
                break
            end
        end
        if msgStruct.Thema == protocol.Enum.THEMA.LESS_THAN_WORM then
            required_thema_exist = true
        end
    end
    print(param.Price.Thema[msgStruct.Thema].unlocked_rank_level)
    print(curr_info.Main.Rank)
    print(required_thema_exist)
    if param.Price.Thema[msgStruct.Thema] == nil or
        param.Price.Thema[msgStruct.Thema].unlocked_rank_level > curr_info.Main.Rank or
        required_thema_exist == false then

        replyMsgStruct.State = replyEnum.THEMA_UNLOCK_CONDITION_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if there is no linked account to pay
    if curr_info.AccountName == nil then
        replyMsgStruct.State = replyEnum.NO_CONNECTED_ACCOUNT
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
    end

    -- prepare send struct
    local send_t = Golkin_client:getSend_t()
    send_t.owner = curr_info.Name
    send_t.password = msgStruct.AccountPasswd
    send_t.from = curr_info.AccountName
    send_t.fromMsg = "buyThema"
    send_t.to = param.account.name
    send_t.toMsg = "buyThema"
    send_t.balance = param.Price.Thema[msgStruct.Thema].rankPrice

    -- send request to golkin server
    Golkin_client:send_SEND(send_t)

    -- await to get recieve, or timeout
    local golkin_msg, golkin_msgStruct = self:__await_pullEvent_Golkin(Golkin_protocol.Header.ACK_SEND, 1)
    ---@cast golkin_msgStruct Golkin.Web.Protocol.MsgStruct.ACK_SEND
    ---@cast golkin_msg Golkin.Web.Protocol.Msg
    local golkin_enum = Golkin_protocol.Enum.ACK_SEND_R
    local golkin_enum_INV = Golkin_protocol.Enum_INV.ACK_SEND_R_INV

    -- if timeout
    if golkin_msg == nil then
        replyMsgStruct.State = replyEnum.BANKING_REQUEST_TIMEOUT
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if banking has error
    if golkin_msgStruct.Success == false then
        replyMsgStruct.State = replyEnum.BANKING_ERROR
        replyMsgStruct.Success = false
        replyMsgStruct.banking_state = golkin_msgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        self:__display_result_msg(false, golkin_msgStruct.State, golkin_enum_INV)
        return nil
    end

    -- set info to get thema
    local new_thema_item = protocol.Struct.item_t:new()
    new_thema_item.ItemType = protocol.Enum.ITEM_TYPE.THEMA
    new_thema_item.ItemIndex = msgStruct.Thema
    table.insert(curr_info.Items, new_thema_item)
    self:__saveInfo(curr_info)

    -- return success msg
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = true
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

---handle msg CHANGE_THEMA
---@param msg Sallo.Web.Protocol.Msg
---@param msgStruct Sallo.Web.Protocol.MsgStruct.CHANGE_THEMA
function Server:__handle_CHANGE_THEMA(msg, msgStruct)
    print("handle CHANGE_THEMA msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_CHANGE_THEMA:new()
    local replyEnum = protocol.Enum.ACK_CHANGE_THEMA_R
    local replyEnum_INV = protocol.Enum_INV.ACK_CHANGE_THEMA_R_INV
    local replyHeader = protocol.Header.ACK_CHANGE_THEMA

    --- try to parse info
    local currInfo = self:__getInfo(msgStruct.InfoName)
    if currInfo == nil then
        replyMsgStruct.State = replyEnum.NO_INFO
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if passwd unmet
    if currInfo.Password ~= msgStruct.InfoPasswd then
        replyMsgStruct.State = replyEnum.INFO_PASSWD_UNMET
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- if no current them item owned
    local isItemExist = false
    for k, v in pairs(currInfo.Items) do
        if v.ItemType == protocol.Enum.ITEM_TYPE.THEMA and
            v.ItemIndex == msgStruct.Thema then
            isItemExist = true
            break
        end
    end
    if isItemExist == false then
        replyMsgStruct.State = replyEnum.THEMA_NEEDED_TO_BUY
        replyMsgStruct.Success = false
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        self:__display_result_msg(false, replyMsgStruct.State, replyEnum_INV)
        return nil
    end

    -- apply to info and save
    currInfo.Thema = msgStruct.Thema
    self:__saveInfo(currInfo)

    -- give success msg
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = true
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    self:__display_result_msg(true, replyMsgStruct.State, replyEnum_INV)
end

--- quary player online data, do player info refresh
function Server:__quaryPlayerData()
    local currDay = os.date('%d')
    local currMin = os.date('%M')
    local infos = self.__cachedInfos
    local currentPlayers = self.__PlayerDetector.getOnlinePlayers()

    local changeMin = false
    local changeDay = false

    -- min changed
    if currMin ~= self.__lastPlayerQuaryMinuteStr then
        changeMin = true
    end

    -- day changed
    if currDay ~= self.__lastPlayerQuaryDayStr then
        changeDay = true
    end

    self.__lastPlayerQuaryDayStr = currDay
    self.__lastPlayerQuaryMinuteStr = currMin

    -- for test
    -- self.__tempCount = self.__tempCount + 1
    -- print(self.__tempCount)
    -- changeMin = true
    -- if (self.__tempCount % 480 == 0) then
    --     changeDay = true
    -- end

    -- cached & exist now
    for k, v in pairs(infos) do
        for kk, vv in pairs(currentPlayers) do
            if v.Name == vv then
                if changeMin then self:__changeMin(v) end
            end
        end
    end

    for k, v in pairs(infos) do
        if changeDay then self:__changeDay(v) end
    end

    -- save all infos
    for k, v in pairs(infos) do
        self:__saveInfo(v)
    end
end

---extract msgs from playerleveler and add to chatbox queue in server
---@param pl Sallo.PlayerLeveler
function Server:__extractMsgsFromPlayerLeveler(pl)
    local playerMsgs = pl:getPlayerMsg()
    local serverMsgs = pl:getServerMsg()
    for k, v in pairs(playerMsgs) do
        ---@type Sallo.Web.Server.ChatBoxContent
        local a = {}
        a.IsServerMsg = false
        a.Player = pl:getPlayerInfo().Name
        a.Prefix = "Sallo"
        a.Msg = v
        table.insert(self.__ChatBoxQueue, a)
    end
    for k, v in pairs(serverMsgs) do
        ---@type Sallo.Web.Server.ChatBoxContent
        local a = {}
        a.IsServerMsg = true
        a.Player = nil
        a.Prefix = "Sallo"
        a.Msg = v
        table.insert(self.__ChatBoxQueue, a)
    end
    pl:flushMsgs()
end

---change min of info
---@param info Sallo.Web.Protocol.Struct.info_t
function Server:__changeMin(info)
    local pl = PlayerLeveler:new(info)
    pl:addMin()
    self:__extractMsgsFromPlayerLeveler(pl)
end

--- change day of info
---@param info Sallo.Web.Protocol.Struct.info_t
function Server:__changeDay(info)
    local pl = PlayerLeveler:new(info)
    local todayGold = pl:addDay()

    -- if not work, no send money
    if todayGold == nil then
        pl:flushMsgs()
        return nil
    end

    -- add msgs
    self:__extractMsgsFromPlayerLeveler(pl)

    -- if no account linked, skip
    if info.AccountName == nil then
        info.SalaryLeft = info.SalaryLeft + todayGold
        pl:flushMsgs()
        return nil
    end

    -- make send request to golkin
    local send_t = Golkin_client:getSend_t()
    send_t.owner = param.account.owner
    send_t.password = param.account.passwd
    send_t.from = param.account.name
    send_t.fromMsg = info.Name .. " : " .. string.format("%.2f", todayGold)
    send_t.to = info.AccountName
    send_t.toMsg = "Salary"
    send_t.balance = todayGold

    -- if salaryLeft is left, send with it
    if info.SalaryLeft > 0.001 then
        send_t.balance = send_t.balance + info.SalaryLeft
        info.SalaryLeft = 0
        send_t.toMsg = send_t.toMsg .. "+Old"
        send_t.fromMsg = info.Name .. " : " .. string.format("%.2f", send_t.balance)
    end

    Golkin_client:send_SEND(send_t)

    -- await for golkin response
    local replyMsg, replyMsgStruct = self:__await_pullEvent_Golkin(Golkin_protocol.Header.ACK_SEND, 1)
    ---@cast replyMsg Golkin.Web.Protocol.Msg
    ---@cast replyMsgStruct Golkin.Web.Protocol.MsgStruct.ACK_SEND

    --- timeout
    if replyMsg == nil then
        info.SalaryLeft = info.SalaryLeft + todayGold
        print("salary send timeout!")
        print("player name : " .. info.Name, " / salary : " .. string.format("%.2f", send_t.balance))
        return nil
    end

    --reply is not good
    if replyMsgStruct.Success == false then
        info.SalaryLeft = info.SalaryLeft + todayGold
        print("salary send failed!")
        print("player name : " .. info.Name, " / salary : " .. string.format("%.2f", send_t.balance))
        self:__display_result_msg(false, replyMsgStruct.State, Golkin_protocol.Enum_INV.ACK_SEND_R_INV)
        return nil
    end

    -- success
    print("salary sended!")
    print("player name : " .. info.Name, " / salary : " .. string.format("%.2f", send_t.balance))

end

--- chatbox has cooldown timeout. look throught the chatbox queue, if player online than show msg
function Server:__ChatboxQueueCheck()

    local currentPlayer = self.__PlayerDetector.getOnlinePlayers()

    for i = 1, #(self.__ChatBoxQueue), 1 do
        for kk, vv in pairs(currentPlayer) do
            if (self.__ChatBoxQueue[i].Player == vv) then
                self.__ChatBox.sendMessage(self.__ChatBoxQueue[i].Msg, self.__ChatBoxQueue[i].Prefix)
                table.remove(self.__ChatBoxQueue, i)
                return nil
            end
        end
    end

end

return Server
