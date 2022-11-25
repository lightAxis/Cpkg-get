--- include
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol
local handle = THIS.Web.Handle
local class = require("Class.middleclass")
local const = THIS.ENV.CONST


--- class definition
---@class Golkin.Web.Server
---@field __handle Golkin.Web.Protocol.Handle
---@field __accountPath string
---@field __ownerPath string
---@field __cacheAccounts table<string, Golkin.Web.Protocol.Struct.Account_t>
---@field new fun(self:Golkin.Web.Server):Golkin.Web.Server

---@class Golkin.Web.Server
local Server = class("Golkin.Web.Server")

function Server:initialize()
    self.__handle = handle:new()

    self.__handle:attachMsgHandle(protocol.Header.OWNER_LOGIN, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.OWNER_LOGIN
        self:__handle_OWNER_LOGIN(msg, msgstruct)
    end)

    self.__handle:attachMsgHandle(protocol.Header.GET_OWNERS, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.GET_OWNERS
        self:__handle_GET_OWNERS(msg, msgstruct)
    end)

    self.__handle:attachMsgHandle(protocol.Header.GET_ACCOUNT, function(msg, msgstruct)
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

    self.__accountPath = THIS.ENV.PATH .. const.accountDir
    if fs.exists(self.__accountPath) == false then
        fs.makeDir(self.__accountPath)
    end
    self.__ownerPath = THIS.ENV.PATH .. const.ownerDir
    if fs.exists(self.__ownerPath) == false then
        fs.makeDir(self.__ownerPath)
    end

    rednet.host(const.protocol, const.serverName)

    ---@type table<string, Golkin.Web.Protocol.Struct.Account_t>
    self.__cacheAccounts = {}
    local files = fs.list(self.__accountPath)
    for k, v in pairs(files) do
        local f = fs.open(self.__accountPath .. "/" .. v, "r")
        ---@type Golkin.Web.Protocol.Struct.Account_t
        local account = textutils.unserialize(f.readAll())
        f.close()
        self.__cacheAccounts[account.Name] = account
    end

    ---@type table<number, Golkin.Web.Protocol.Struct.Owner_t>
    self.__cacheOwners = {}
    files = fs.list(self.__ownerPath)
    for k, v in pairs(files) do
        local f = fs.open(self.__ownerPath .. "/" .. v, "r")
        ---@type Golkin.Web.Protocol.Struct.Owner_t
        local owner = textutils.unserialize(f.readAll())
        f.close()
        self.__cacheOwners[owner.Name] = owner
    end

end

---main function for running server
function Server:main()
    print("start hosting in protocol : " .. const.protocol .. " in node :" .. const.serverName)

    while true do
        -- rednet_message, fromID, msg, protocol
        local a, b, c, d = os.pullEvent("rednet_message")
        if (d == const.protocol) then
            print("---------------")
            print("get msg from id : " .. b)
            self.__handle:parse(c)
        end
    end
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
---@return Golkin.Web.Protocol.Struct.Account_t
function Server:__getAccountCache_byName(accountName)
    return self.__cacheAccounts[accountName]
end

---get account info from cache
---@param ownerName string
---@return Golkin.Web.Protocol.Struct.Owner_t
function Server:__getOwnerCache_byName(ownerName)
    return self.__cacheOwners[ownerName]
end

---remove account info from cache
---@param accountName string
function Server:__removeAccountCache_byName(accountName)
    self.__cacheAccounts[accountName] = nil
end

---remove owner info from cache
---@param ownerName string
function Server:__removeOwnerCache_byName(ownerName)
    self.__cacheOwners[ownerName] = nil
end

---save account to cache
---@param account Golkin.Web.Protocol.Struct.Account_t
function Server:__saveToAccountCache(account)
    self.__cacheAccounts[account.Name] = account
end

---save owner to cache
---@param owner Golkin.Web.Protocol.Struct.Owner_t
function Server:__saveToOwnerCache(owner)
    self.__cacheOwners[owner.Name] = owner
end

---get account info
---@param accountName string
---@return Golkin.Web.Protocol.Struct.Account_t|nil
function Server:__getAccount(accountName)
    ---@type Golkin.Web.Protocol.Struct.Account_t
    local account = self:__getAccountCache_byName(accountName)
    if account == nil then
        local accountPath = self.__accountPath .. "/" .. accountName .. ".sz"
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

---get owner info
---@param ownerName string
---@return Golkin.Web.Protocol.Struct.Owner_t|nil
function Server:__getOwner(ownerName)
    ---@type Golkin.Web.Protocol.Struct.Owner_t
    local owner = self:__getOwnerCache_byName(ownerName)
    if owner == nil then
        local ownerPath = self.__ownerPath .. "/" .. ownerName .. ".sz"
        if (fs.exists(ownerPath) == false) then
            return nil
        else
            local f = fs.open(ownerPath, "r")
            owner = textutils.unserialize(f.readAll())
            f.close()
            return owner
        end
    end
end

---save account to server
---@param account Golkin.Web.Protocol.Struct.Account_t
function Server:__saveAccount(account)
    self:__saveToAccountCache(account)
    local accountPath = self.__accountPath .. "/" .. account.Name .. ".sz"
    local f = fs.open(accountPath, "w")
    f.write(textutils.serialize(account))
    f.close()
end

---remove account by name
---@param accountName string
function Server:__removeAccount(accountName)
    self:__removeAccountCache_byName(accountName)
    local accountPath = self.__accountPath .. "/" .. accountName .. ".sz"
    fs.delete(accountPath)
end

---handle owner login msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.OWNER_LOGIN
function Server:__handle_OWNER_LOGIN(msg, msgstruct)
    print("handle OWNER_LOGIN")
    local replyMsgStruct = protocol.MsgStruct.ACK_OWNER_LOGIN:new()
    local replyHeader = protocol.Header.ACK_OWNER_LOGIN
    local replyEnum = protocol.Enum.ACK_OWNER_LOGIN_R

    --- get owner
    local owner = self:__getOwner(msgstruct.Name)

    -- if owner not exists
    if (owner == nil) then
        replyMsgStruct.State = replyEnum.NO_OWNER_EXIST
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- if password unmet
    if (owner.Password ~= msgstruct.Password) then
        replyMsgStruct.State = replyEnum.PASSWORD_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    -- send owner info back
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    print("error:" .. tostring(replyMsgStruct.State))
    print("PASSWD_UNMET")
    return nil
end

---handle get owners msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_OWNERS
function Server:__handle_GET_OWNERS(msg, msgstruct)
    print("handle GET_OWNERS msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_GET_OWNERS:new()
    local replyHeader = protocol.Header.ACK_GET_OWNERS
    local replyEnum = protocol.Enum.ACK_GET_OWNERS_R

    -- collect all owner names
    local owners = {}
    for k, v in pairs(self.__cacheOwners) do
        table.insert(owners, k)
    end

    replyMsgStruct.OwnerNames = owners
    if #owners >= 1 then
        replyMsgStruct.State = replyEnum.SUCCESS
        print("good:" .. tostring(replyMsgStruct.State))
        print("SUCCESS")
    else
        replyMsgStruct.State = replyEnum.NO_OWNERS
        print("error:" .. tostring(replyMsgStruct.State))
        print("NO_OWNERS")
    end
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)

    return nil
end

---handle get account msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_ACCOUNT
function Server:__handle_GET_ACCOUNT(msg, msgstruct)
    print("handle GET_ACCOUNT msg")
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
        print("error:" .. tostring(replyMsgStruct.State))
        print("NO_ACCOUNT_FOR_NAME")
        return nil
    end

    --- check password met
    if currentAccount.Password ~= msgstruct.Password then
        replyMsgStruct.Account = nil
        replyMsgStruct.State = replyEnum.PASSWD_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("PASSWD_UNMET")
        return nil
    end

    --- send back account infos
    replyMsgStruct.Account = currentAccount
    replyMsgStruct.State   = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    print("good:" .. tostring(replyMsgStruct.State))
    print("SUCCESS")
    return nil

end

---handle get accounts msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_ACCOUNTS
function Server:__handle_GET_ACCOUNTS(msg, msgstruct)
    print("handle GET_ACCOUNTS msg")
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
        print("error:" .. tostring(replyMsgStruct.State))
        print("NO_BANK_FILE")
    else
        replyMsgStruct.State = replyEnum.SUCCESS
        print("good:" .. tostring(replyMsgStruct.State))
        print("SUCCESS")
    end
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)

    return nil
end

---handle get owner accounts msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.GET_OWNER_ACCOUNTS
function Server:__handle_GET_OWNER_ACCOUNTS(msg, msgstruct)
    print("handle GET_OWNER_ACCOUNTS msg")
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
        print("good:" .. tostring(replyMsgStruct.State))
        print("SUCCESS")
    else
        replyMsgStruct.State = replyEnum.NO_ACCOUNTS
        print("error:" .. tostring(replyMsgStruct.State))
        print("NO_ACCOUNTS")
    end
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    return nil
end

---handle register msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.REGISTER
function Server:__handle_REGISTER(msg, msgstruct)
    print("handle REGISTER msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_REGISTER:new()
    local replyHeader = protocol.Header.ACK_REGISTER
    local replyEnum = protocol.Enum.ACK_REGISTER_R

    --- read account
    ---@type Golkin.Web.Protocol.Struct.Account_t|nil
    local currentAccount = self:__getAccount(msgstruct.AccountName)

    --- check is account already exists
    if currentAccount ~= nil then
        --- check owner is met
        if (currentAccount.Owner ~= msgstruct.OwnerName) then
            replyMsgStruct.State = replyEnum.ACCOUNT_OWNER_UNMET
            print("error:" .. tostring(replyMsgStruct.State))
            print("ACCOUNT_OWNER_UNMET")
        else
            replyMsgStruct.State = replyEnum.ACCOUNT_ALREADY_EXISTS
            print("error:" .. tostring(replyMsgStruct.State))
            print("ACCOUNT_ALREADY_EXISTS")
        end
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        return nil
    end

    --- make new account and save to server
    local newAccount = protocol.Struct.Account_t:new()
    newAccount.Name = msgstruct.AccountName
    newAccount.Owner = msgstruct.OwnerName
    newAccount.Password = msgstruct.Password
    newAccount.Histories = {}
    newAccount.Balance = 0
    self:__saveAccount(newAccount)

    --- send SUCCESS
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    print("good:" .. tostring(replyMsgStruct.State))
    print("SUCCESS")
    return nil
end

---handle send msg
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.SEND
function Server:__handle_SEND(msg, msgstruct)
    print("handle SEND msg")
    local replyMsgStruct = protocol.MsgStruct.ACK_SEND:new()
    local replyHeader = protocol.Header.ACK_SEND
    local replyEnum = protocol.Enum.ACK_SEND_R

    --- check if sending balance is less than 0
    if msgstruct.Balance < 0 then
        replyMsgStruct.State = replyEnum.BALANCE_CANNOT_BE_NEGATIVE
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("BALANCE_CANNOT_BE_NEGATIVE")
        return nil
    end

    --- check if sender account exist
    local senderAccount = self:__getAccount(msgstruct.From)
    if (senderAccount == nil) then
        replyMsgStruct.State = replyEnum.NO_ACCOUNT_TO_SEND
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("NO_ACCOUNT_TO_SEND")
        return nil
    end

    --- check if owner met
    if senderAccount.Owner ~= msgstruct.OwnerName then
        replyMsgStruct.State = replyEnum.OWNER_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("OWNER_UNMET")
        return nil
    end

    --- check if balance is enough
    if senderAccount.Balance < msgstruct.Balance then
        replyMsgStruct.State = replyEnum.NOT_ENOUGHT_BALLANCE_TO_SEND
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("NOT_ENOUGHT_BALLANCE_TO_SEND")
        return nil
    end

    --- check if password met
    if senderAccount.Password ~= msgstruct.Password then
        replyMsgStruct.State = replyEnum.PASSWORD_UNMET
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("PASSWORD_UNMET")
        return nil
    end

    --- check if reciever account exist
    local recieverAccount = self:__getAccount(msgstruct.To)
    if (recieverAccount == nil) then
        replyMsgStruct.State = replyEnum.NO_ACCOUNT_TO_RECIEVE
        replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
        self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
        print("error:" .. tostring(replyMsgStruct.State))
        print("NO_ACCOUNT_TO_RECIEVE")
        return nil
    end

    --- adjust account balance
    senderAccount.Balance = senderAccount.Balance - msgstruct.Balance
    recieverAccount.Balance = recieverAccount.Balance + msgstruct.Balance

    --- make new histories
    local nowTime = protocol.Struct.Daytime_t:new()
    nowTime.Realtime = os.date('%y/%m/%d %H:%M %a')
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
    self:__saveAccount(senderAccount)
    self:__saveAccount(recieverAccount)

    -- send back success
    replyMsgStruct.State = replyEnum.SUCCESS
    replyMsgStruct.Success = replyEnum.NORMAL < replyMsgStruct.State
    self:__sendMsgStruct(replyHeader, replyMsgStruct, msg.SendID)
    print("good:" .. tostring(replyMsgStruct.State))
    print("SUCCESS")
    return nil
end

return Server
