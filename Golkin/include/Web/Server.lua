--- include
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol
local handle = THIS.Web.Handle
local class = require("Class.middleclass")
local const = THIS.ENV.CONST


--- class definition
---@class Golkin.Web.Server
---@field __handle Golkin.Web.Protocol.Handle

---@class Golkin.Web.Server
local Server = class("Golkin.Web.Server")

function Server:initialize()
    self.__handle = handle:new()

    self.__handle:attachMsgHandle(protocol.Header.ACK_GET_ACCOUNT, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
        self:__handle_GET_ACCOUNT(msg, msgstruct)
    end)

    self.__handle:attachMsgHandle(protocol.Header.GET_ACCOUNTS, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS
        self:__handle_GET_ACCOUNTS(msg, msgstruct)
    end)

    self.__handle:attachMsgHandle(protocol.Header.GET_OWNER_ACCOUNTS, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS
        self:__handle_GET_OWNER_ACCOUNTS(msg, msgstruct)
    end)

    self.__handle:attachMsgHandle(protocol.Header.REGISTER, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.REGISTER
        self:__handle_REGISTER(msg, msgstruct)
    end)

    self.__handle:attachMsgHandle(protocol.Header.SEND, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.SEND
        self:__handle_SEND(msg, msgstruct)
    end)

    self.__bankPath = THIS.ENV.PATH .. const.fileDir

    rednet.host(const.protocol, const.serverName)

    ---@type table<string, Golkin.Web.Protocol.Struct.Account_t>
    self.__cacheAccounts = {}
    local files = fs.list(self.__bankPath)
    for k, v in pairs(files) do
        local f = fs.open(self.__bankPath .. "/" .. v, "r")
        ---@type Golkin.Web.Protocol.Struct.Account_t
        local account = textutils.unserialize(f.readAll())
        f.close()
        self.__cacheAccounts[account.Name] = account
    end

end

---main function for running server
function Server:main()

end

---send msg in protocol
---@param header Golkin.Web.Protocol.Header
---@param msgstruct Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@param idToSend number
function Server:__sendMsgStruct(header, msgstruct, idToSend)
    local msg = protocol.Msg:new()
    msg.Header = header
    msg.MsgStructStr = textutils.serialize(msgstruct)
    msg.SendID = os.getComputerID()
    msg.TargetID = idToSend

    rednet.send(idToSend, textutils.serialize(msg), const.protocol)
end

---get account info from cache
---@param accountName string
function Server:__getCache_byName(accountName)
    return self.__cacheAccounts[accountName]
end

---remove account info from cache
---@param accountName string
function Server:__removeCache_byName(accountName)
    self.__cacheAccounts[accountName] = nil
end

---save account to cache
---@param account Golkin.Web.Protocol.Struct.Account_t
function Server:__saveToCache(account)
    self.__cacheAccounts[account.Name] = account
end

---get account info
---@param accountName string
---@return Golkin.Web.Protocol.Struct.Account_t|nil
function Server:__getAccount(accountName)
    ---@type Golkin.Web.Protocol.Struct.Account_t
    local account = self:__getCache_byName(accountName)
    if account == nil then
        local accountPath = self.__bankPath .. "/" .. accountName .. ".lua"
        if (fs.exists(accountPath) == false) then
            return nil
        else
            local f = fs.open(accountPath, "r")
            account = textutils.unserialize(f.readAll())
            f.close()
            return account
        end
    end
end

---save account to server
---@param account Golkin.Web.Protocol.Struct.Account_t
function Server:__saveAccount(account)
    Server:__saveToCache(account)
    local accountPath = self.__bankPath .. "/" .. account.Name .. ".lua"
    local f = fs.open(accountPath, "w")
    f.write(textutils.serialize(account))
    f.close()
end

---remove account by name
---@param accountName string
function Server:__removeAccount(accountName)
    Server:__removeCache_byName(accountName)
    local accountPath = self.__bankPath .. "/" .. accountName .. ".lua"
    fs.delete(accountPath)
end

---handle get account msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
function Server:__handle_GET_ACCOUNT(msg, msgstruct)
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_ACCOUNT:new()
    local replyHeader = protocol.Header.ACK_GET_ACCOUNT
    local replyEnum = protocol.Enum.ACK_GET_ACCOUNT_R

    --- get account info from cache or file
    local currentAccount = self:__getAccount(msgstruct.AccountName)


    --- check if no account exist
    if currentAccount == nil then
        replyMsgStruct.Account = nil
        replyMsgStruct.State = replyEnum.NO_ACCOUNT_FOR_NAME
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- check password met
    if currentAccount.Password ~= msgstruct.Password then
        replyMsgStruct.Account = nil
        replyMsgStruct.State = replyEnum.PASSWD_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- send back account infos
    replyMsgStruct.Account = currentAccount
    replyMsgStruct.State   = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    return nil

end

---handle get accounts msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS
function Server:__handle_GET_ACCOUNTS(msg, msgstruct)
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_ACCOUNTS:new()
    local replyHeader = protocol.Header.ACK_GET_ACCOUNTS
    local replyEnum = protocol.Enum.ACK_GET_ACCOUNTS_R

    --- collect all account infos from cache
    local accountNames = {}
    for k, v in pairs(self.__cacheAccounts) do
        table.insert(accountNames, k)
    end

    replyMsgStruct.AccountsList = accountNames
    if (#accountNames <= 0) then
        replyMsgStruct.State = replyEnum.NO_BANK_FILE
    else
        replyMsgStruct.State = replyEnum.SUCCESS
    end
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    return nil
end

---handle get owner accounts msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS
function Server:__handle_GET_OWNER_ACCOUNTS(msg, msgstruct)
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS:new()
    local replyHeader = protocol.Header.ACK_GET_OWNER_ACCOUNTS
    local replyEnum = protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R

    --collect all account infos of owner
    local accountNames = {}
    for k, v in pairs(self.__cacheAccounts) do
        if v.Owner == msgstruct.Owner then
            table.insert(accountNames, k)
        end
    end

    replyMsgStruct.Accounts = accountNames
    if #accountNames >= 1 then
        replyMsgStruct.State = replyEnum.SUCCESS
    else
        replyMsgStruct.State = replyEnum.NO_ACCOUNTS
    end
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    return nil
end

---handle register msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.REGISTER
function Server:__handle_REGISTER(msg, msgstruct)
    local replyMsgStruct = protocol.MsgStruct.ACK_REGISTER:new()
    local replyHeader = protocol.Header.ACK_REGISTER
    local replyEnum = protocol.Enum.ACK_REGISTER_R

    --- read account
    ---@type Golkin.Web.Protocol.Struct.Account_t|nil
    local currentAccount = Server:__getAccount(msgstruct.AccountName)

    --- check is account already exists
    if currentAccount ~= nil then
        --- check owner is met
        if (currentAccount.Owner == msgstruct.OwnerName) then
            replyMsgStruct.State = replyEnum.ACCOUNT_OWNER_UNMET
        else
            replyMsgStruct.State = replyEnum.ACCOUNT_ALREADY_EXISTS
        end
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- make new account and save to server
    local newAccount = protocol.Struct.Account_t:new()
    newAccount.Name = msgstruct.AccountName
    newAccount.Owner = msgstruct.OwnerName
    newAccount.Password = msgstruct.Password
    newAccount.Histories = {}
    newAccount.Balance = 0
    Server:__saveAccount(newAccount)

    --- send SUCCESS
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    return nil
end

---handle send msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.SEND
function Server:__handle_SEND(msg, msgstruct)
    local replyMsgStruct = protocol.MsgStruct.ACK_SEND:new()
    local replyHeader = protocol.Header.ACK_SEND
    local replyEnum = protocol.Enum.ACK_SEND_R

    --- check if sending balance is less than 0
    if msgstruct.Balance < 0 then
        replyMsgStruct.State = replyEnum.BALANCE_CANNOT_BE_NEGATIVE
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- check if sender account exist
    local senderAccount = Server:__getAccount(msgstruct.From)
    if (senderAccount == nil) then
        replyMsgStruct.State = replyEnum.NO_ACCOUNT_TO_SEND
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- check if owner met
    if senderAccount.Owner ~= msgstruct.OwnerName then
        replyMsgStruct.State = replyEnum.OWNER_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- check if balance is enough
    if senderAccount.Balance < msgstruct.Balance then
        replyMsgStruct.State = replyEnum.NOT_ENOUGHT_BALLANCE_TO_SEND
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- check if password met
    if senderAccount.Password ~= msgstruct.Password then
        replyMsgStruct.State = replyEnum.PASSWORD_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- check if reciever account exist
    local recieverAccount = Server:__getAccount(msgstruct.To)
    if (recieverAccount == nil) then
        replyMsgStruct.State = replyEnum.NO_ACCOUNT_TO_RECIEVE
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- adjust account balance
    senderAccount.Balance = senderAccount.Balance - msgstruct.Balance
    recieverAccount.Balance = recieverAccount.Balance + msgstruct.Balance

    --- make new histories
    local nowTime = protocol.Struct.Daytime_t:new()
    nowTime.Realtime = os.date()
    local senderHistory = protocol.Struct.History_t:new()
    local recieverHistory = protocol.Struct.History_t:new()

    senderHistory.BalanceLeft = senderAccount.Balance
    senderHistory.Daytime = nowTime
    senderHistory.InOut = -msgstruct.Balance
    senderHistory.Name = msgstruct.FromMsg

    recieverHistory.BalanceLeft = recieverAccount.Balance
    recieverHistory.Daytime = nowTime
    recieverHistory.InOut = msgstruct.Balance
    recieverHistory.Name = msgstruct.ToMsg

    --- register to account
    table.insert(senderAccount.Histories, 1, senderHistory)
    table.insert(recieverAccount.Histories, 1, recieverHistory)

    if #senderAccount.Histories > const.maximumHistoryCount then
        table.remove(senderAccount.Histories, #(senderAccount.Histories))
    end

    if #recieverAccount.Histories > const.maximumHistoryCount then
        table.remove(recieverAccount.Histories, #(recieverAccount.Histories))
    end

    -- save both account to server
    Server:__saveAccount(senderAccount)
    Server:__saveAccount(recieverAccount)

    -- send back success
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    Server:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    return nil
end
