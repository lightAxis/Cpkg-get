local THIS = PKGS.Golkin
local class = require("Class.middleclass")

local protocol = THIS.Web.Protocol

local const = THIS.ENV.CONST

---@class Golkin.Web.Client.SEND_t
---@field balance number
---@field owner string
---@field password string
---@field from string
---@field fromMsg string
---@field to string
---@field toMsg string

--- class definitions
---@class Golkin.Web.Client
---@field __serverID number|nil
---@field new fun(self:Golkin.Web.Client):Golkin.Web.Client


---@class Golkin.Web.Client
local client = class("Golkin.Web.Client")

function client:initialize()

    print("open rednet on side" .. CPKG.rednetSide)
    rednet.open(CPKG.rednetSide)

    print("find Golkin server..")
    self.__serverID = self:findServerID()
end

---get golkin server id
---@return number
function client:getServerID()
    if self.__serverID == nil then
        local id = rednet.lookup(const.protocol, const.serverName)
        self.__serverID = id
        return id
    else
        return self.__serverID
    end
end

function client:findServerID()
    local id = self:getServerID()
    if id ~= nil then
        return id
    end

    local timer = os.startTimer(3)
    while true do
        print("there is no golkin server exist. retrying...")
        local a, b, c, d = os.pullEvent()
        if a == "timer" and b == timer then
            id = self:getServerID()
            if id ~= nil then
                return id
            end
            timer = os.startTimer(3)
        end

    end
end

---send msg to server
---@param header Golkin.Web.Protocol.Header
---@param msgstruct Golkin.Web.Protocol.MsgStruct.IMsgStruct
function client:__sendMsg(header, msgstruct)
    local msg = protocol.Msg:new()
    msg.Header = header
    msg.SendID = os.getComputerID()
    msg.TargetID = self:getServerID()
    msg.MsgStructStr = textutils.serialize(msgstruct)
    rednet.send(msg.TargetID, textutils.serialize(msg), const.protocol)
end

--- send msg GET_OWNERS to server
function client:send_GET_OWNERS()
    local msgStruct = protocol.MsgStruct.GET_OWNERS:new()
    client:__sendMsg(protocol.Header.GET_OWNERS, msgStruct)
end

---send msg OWNER_LOGIN to server
---@param name string
---@param password string
function client:send_OWNER_LOGIN(name, password)
    local msgStruct = protocol.MsgStruct.OWNER_LOGIN:new()
    msgStruct.Name = name
    msgStruct.Password = password
    self:__sendMsg(protocol.Header.OWNER_LOGIN, msgStruct)
end

---send msg GET_ACCOUNT to server
---@param accountName string name of account
---@param password string md5 hashed hex string
function client:send_GET_ACCOUNT(accountName, password)
    local msgStruct = protocol.MsgStruct.GET_ACCOUNT:new()
    msgStruct.AccountName = accountName
    msgStruct.Password = password
    client:__sendMsg(protocol.Header.GET_ACCOUNT, msgStruct)
end

function client:send_GET_ACCOUNTS()
    local msgStruct = protocol.MsgStruct.GET_ACCOUNTS:new()
    client:__sendMsg(protocol.Header.GET_ACCOUNTS, msgStruct)
end

---send request to server to query all account in owner
---@param owner string
function client:send_GET_OWNER_ACCOUNT(owner)
    local msgStruct = protocol.MsgStruct.GET_OWNER_ACCOUNTS:new()
    msgStruct.Owner = owner
    client:__sendMsg(protocol.Header.GET_OWNER_ACCOUNTS, msgStruct)
end

---send request to server to register new account
---@param accountName string name of new account
---@param ownerName string name of account's owner
---@param password string md5 hashed hex string
function client:send_REGISTER(accountName, ownerName, password)
    local msgStruct = protocol.MsgStruct.REGISTER:new()
    msgStruct.AccountName = accountName
    msgStruct.OwnerName = ownerName
    msgStruct.Password = password
    client:__sendMsg(protocol.Header.REGISTER, msgStruct)
end

---send request to server to register new owner
---@param ownerName string
---@param password string
function client:send_REGISTER_OWNER(ownerName, password)
    local msgStruct = protocol.MsgStruct.REGISTER_OWNER:new()
    msgStruct.OwnerName = ownerName
    msgStruct.Password = password
    self:__sendMsg(protocol.Header.REGISTER_OWNER, msgStruct)
end

---send request to server to remove account
---@param accountName string
---@param ownerPasswd string
---@param ownerName string
function client:send_REMOVE_ACCOUNT(accountName, ownerPasswd, ownerName)
    local msgStruct = protocol.MsgStruct.REMOVE_ACCOUNT:new()
    msgStruct.AccountName = accountName
    msgStruct.OwnerPassword = ownerPasswd
    msgStruct.OwnerName = ownerName
    self:__sendMsg(protocol.Header.REMOVE_ACCOUNT, msgStruct)
end

---comment
---@return Golkin.Web.Client.SEND_t
function client:getSend_t()
    ---@alias a Golkin.Web.Protocol.MsgStruct.SEND Golkin.Web.Client.SEND_t
    local a = protocol.MsgStruct.SEND:new()
    return a --[[@as Golkin.Web.Client.SEND_t]]
end

---send SEND msg to server
---@param send_t Golkin.Web.Client.SEND_t
function client:send_SEND(send_t)
    local msgStruct = protocol.MsgStruct.SEND:new()
    msgStruct.Balance = send_t.balance
    msgStruct.From = send_t.from
    msgStruct.FromMsg = send_t.fromMsg
    msgStruct.OwnerName = send_t.owner
    msgStruct.Password = send_t.password
    msgStruct.To = send_t.to
    msgStruct.ToMsg = send_t.toMsg
    client:__sendMsg(protocol.Header.SEND, msgStruct)
end

return client
