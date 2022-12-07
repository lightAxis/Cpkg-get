--- include
local THIS = PKGS.Sallo
local protocol = THIS.Web.Protocol
local handle = THIS.Web.Handle:new()
local class = require("Class.middleclass")
local param = THIS.Param

local Golkin = DEPS.Sallo.Golkin
local Golkin_handle = Golkin.Web.Handle:new()
local Golkin_client = Golkin.Web.Client:new()
local Golkin_protocol = Golkin.Web.Protocol
local Golkin_param = Golkin.ENV.CONST

---@class Sallo.Web.Server
---@field __Sallo_handle Sallo.Web.Protocol.Handle
---@field __Golkin_handle Golkin.Web.Protocol.Handle
---@field __PlayerQuaryTimerID number
---@field __ChatboxQueueTimerID number
---@field __RequestTimeoutID number
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

---@class Sallo.Web.Server.Event_t
---@field a string
---@field b string
---@field c string
---@field d string


function Server:initialize()
    self.__Sallo_handle = handle:new()
    self.__Golkin_handle = Golkin_handle:new()

    ---@type table<number, Sallo.Web.Server.Event_t>
    self.__EventQueue = {}

    self.__PlayerQuaryTimerID = nil
    self.__ChatboxQueueTimerID = nil

    self.__GolkinServerID = nil

    self.__PlayerDetector = nil
    self.__ChatBox = nil
    self.__ChatBoxQueue = nil

    self.__cachedInfos = {}
    self.__infoPath = THIS.ENV.PATH .. param.Web.info_dir

    --- attach handler of sallo
    self.__Sallo_handle:attachMsgHandle(protocol.Header.CHANGE_SKILL_STAT, function(msg, msgstruct)

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
        if a == "rednet_message" then
            if SenderID ~= nil and b == SenderID then
                if protocolName ~= nil and protocolHandle ~= nil and d == protocolName then
                    local msg, msgstruct = protocolHandle:parse(c)
                    if targetHeader ~= nil and msg.Header == targetHeader then
                        if timeoutID ~= nil then
                            os.cancelTimer(timeoutID)
                        end
                        return a, b, c, d
                    end
                end
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
    main_t.Cap_gauge = 480
    main_t.Cap_left = 480
    main_t.Exp = 0
    main_t.Exp_gauge = param.Level[1].mxp_gauge
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
    stat_t.Cap_amplifier = param.Skill.CON[0].ACT_amplifier
    stat_t.Cap_per_minute = param.CAP_per_min_default * stat_t.Cap_amplifier
    stat_t.Exp_per_cap = param.Skill.EFF[0].TXP_per_ACT
    stat_t.Exp_per_min = stat_t.Exp_per_cap * stat_t.Cap_per_minute
    stat_t.Gold_per_cap = param.Skill.PRO[0].SAL_per_ACT
    stat_t.Gold_per_minute = stat_t.Gold_per_cap * stat_t.Cap_per_minute
    new_info.Stat = stat_t

    local statistics_t = protocol.Struct.statistics_t:new()
    statistics_t.Today_cap = 0
    statistics_t.Today_exp = 0
    statistics_t.Today_gold = 0
    statistics_t.Total_cap = 0
    statistics_t.Total_exp = 0
    statistics_t.Total_gold = 0
    new_info.Statistics = statistics_t

    local thema_t = protocol.Struct.thema_t:new()
    thema_t.Enum = protocol.Enum.THEMA.BACK_TO_NORMAL
    thema_t.Name = "BACK_TO_NORMAL"
    thema_t.isAquired = true
    thema_t.isVisible = true
    new_info.Thema = thema_t

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
        end
        if a == "timer" and b == self.__ChatboxQueueTimerID then
            self:__ChatboxQueueCheck()
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
    local replyEnum_INV = protocol.Enum_INV.ACK_GET_INFOS_R_INV
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
    replyMsgStruct.Info = textutils.serialize(info)
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
    local replyMsgStruct = protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT:new()
    local replyEnum = protocol.Enum.ACK_SET_INFO_CONNECTED_ACCOUNT_R
    local replyHeader = protocol.Header.ACK_SET_INFO_CONNECTED_ACCOUNT
    local replyEnum_INV = protocol.Enum_INV.ACK_SET_INFO_CONNECTED_ACCOUNT_R_INV

    -- try parse info from cache
    local prev_info = self:__getInfo(msgStruct.InfoName)
    if prev_info == nil then
        replyMsgStruct.State = replyEnum.ACCOUNT_NOT_EXIST
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

function Server:__quaryPlayerData()

end

function Server:__ChatboxQueueCheck()

end
