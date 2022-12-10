local THIS = PKGS.Sallo
local protocol = THIS.Web.Protocol

local param = THIS.Param

local class = require("Class.middleclass")

---@class Sallo.Web.Client
---@field __SalloServerID number
---@field new fun(self:Sallo.Web.Client):Sallo.Web.Client
local Client = class("Sallo.Web.Client")

function Client:initialize()

    print("open rednet on side " .. CPKG.rednetSide)
    rednet.open(CPKG.rednetSide)

    print("find sallo server ID")
    self.__SalloServerID = self:findServerID()

end

function Client:getServerID()
    if self.__SalloServerID == nil then
        local id = rednet.lookup(param.Web.protocol, param.Web.serverName)
        self.__SalloServerID = id
        return id
    else
        return self.__SalloServerID
    end
end

function Client:findServerID()
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

function Client:__send_Msg(header, msgStruct)
    local msg = protocol.Msg:new()
    msg.Header = header
    msg.MsgStructStr = textutils.serialize(msgStruct)
    msg.SendID = os.getComputerID()
    msg.TargetID = self:getServerID()
    rednet.send(msg.TargetID, textutils.serialize(msg), param.Web.protocol)
end

---send BUY_RANK msg to sallo server
---@param infoName string
---@param infoPasswd string
---@param accountPasswd string
---@param rank Sallo.Web.Protocol.Enum.RANK_NAME
function Client:send_BUY_RANK(infoName, infoPasswd, accountPasswd, rank)
    local msgStruct = protocol.MsgStruct.BUY_RANK:new()
    msgStruct.OwnerName = infoName
    msgStruct.InfoPasswd = infoPasswd
    msgStruct.AccountPasswd = accountPasswd
    msgStruct.Rank = rank
    self:__send_Msg(protocol.Header.BUY_RANK, msgStruct)
end

---send BUY_THEMA msg to sallo server
---@param infoName string
---@param infoPasswd string
---@param accountPasswd string
---@param thema Sallo.Web.Protocol.Enum.THEMA
function Client:send_BUY_THEMA(infoName, infoPasswd, accountPasswd, thema)
    local msgStruct = protocol.MsgStruct.BUY_THEMA:new()
    msgStruct.OwnerName = infoName
    msgStruct.InfoPasswd = infoPasswd
    msgStruct.AccountPasswd = accountPasswd
    msgStruct.Thema = thema
    self:__send_Msg(protocol.Header.BUY_THEMA, msgStruct)
end

---send CHANGE_SKILL_STAT to sallo server
---@param infoName string
---@param skillState Sallo.Web.Protocol.Struct.skillState_t
function Client:send_CHANGE_SKILL_STAT(infoName, skillState)
    local msgStruct = protocol.MsgStruct.CHANGE_SKILL_STAT:new()
    msgStruct.OwnerName = infoName
    msgStruct.SkillState = skillState
    self:__send_Msg(protocol.Header.CHANGE_SKILL_STAT, msgStruct)
end

---send GET_INFO msg to sallo server
---@param infoName string
function Client:send_GET_INFO(infoName)
    local msgStruct = protocol.MsgStruct.GET_INFO:new()
    msgStruct.Name = infoName
    self:__send_Msg(protocol.Header.GET_INFO, msgStruct)
end

---send GET_INFOS msg to sallo server
function Client:send_GET_INFOS()
    local msgStruct = protocol.MsgStruct.GET_INFOS:new()
    self:__send_Msg(protocol.Header.GET_INFOS, msgStruct)
end

---send REGISTER_INFO msg to sallo server
---@param infoName string
---@param infoPasswd string
function Client:send_REGISTER_INFO(infoName, infoPasswd)
    local msgStruct = protocol.MsgStruct.REGISTER_INFO:new()
    msgStruct.OwnerName = infoName
    msgStruct.Passwd = infoPasswd
    self:__send_Msg(protocol.Header.REGISTER_INFO, msgStruct)
end

---send SET_INFO_CONNECTED_ACCOUNT msg to sallo server
---@param infoName string
---@param infoPasswd string
---@param accountName string
---@param accountOwner string
---@param accountPasswd string
function Client:send_SET_INFO_CONNECTED_ACCOUNT(infoName, infoPasswd, accountName, accountOwner, accountPasswd)
    local msgStruct = protocol.MsgStruct.SET_INFO_CONNECTED_ACCOUNT:new()
    msgStruct.InfoName = infoName
    msgStruct.InfoPasswd = infoPasswd
    msgStruct.AccountName = accountName
    msgStruct.AccountOwner = accountOwner
    msgStruct.AccountPasswd = accountPasswd
    self:__send_Msg(protocol.Header.SET_INFO_CONNECTED_ACCOUNT, msgStruct)
end

return Client
