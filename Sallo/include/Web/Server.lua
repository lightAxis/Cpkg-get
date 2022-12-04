--- include
local THIS = PKGS.Sallo
local protocol = THIS.Web.Protocol
local handle = THIS.Web.Handle
local class = require("Class.middleclass")
local param = THIS.Param

local Golkin = DEPS.Sallo.Golkin
local Golkin_protocol = Golkin.Web.Protocol
local Golkin_param = Golkin.ENV.CONST

---@class Sallo.Web.Server
local Server = class("Sallo.Web.Server")


function Server:initialize()
    self.__handle = handle:new()
    self.__timerID = 0
    self.__GolkinServerID = nil
end

function Server:lookup_server()
    rednet.open(CPKG.rednetSide)
    rednet.lookup(param.Web.protocol, param.Web.serverName)
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

function Server:init_GolkinServerID()
    print("finding golkin server...")
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

function Server:start()
    print("start hosting in protocol : " .. param.Web.protocol .. " in node :" .. param.Web.serverName)

    while true do
        -- rednet_message, fromID, msg, protocol
        local a, b, c, d = os.pullEvent()
        if a == "rednet_message" and d == param.Web.protocol then
            print("---------------")
            print("get msg from id : " .. b)
            self.__handle:parse(c)
        end
        if a == "timer" and b == self.__timerID then
            print("----------------")
            print("start collect player data..")
            self:__CollectData()
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
    rednet.send(idToSend, textutils.serialize(msg), param.Web.protocol)
end

---handle GET_INFO
---@param msg Sallo.Web.Protocol.Msg
---@param msgstruct Sallo.Web.Protocol.MsgStruct.GET_INFO
function Server:__handle_GET_INFO(msg, msgstruct)

end

---handle GET
---@param msg Sallo.Web.Protocol.Msg
---@param msgstruct Sallo.Web.Protocol.MsgStruct.RESERVE_SKILLPT_RESET
function Server:__handle_GET(msg, msgstruct)

end

function Server:__CollectData()

end
