local THIS = require("Golkin.pkg_init")

local protocol = THIS.Web.Protocol
local client = THIS.Web.Client:new()
local handle = THIS.Web.Handle:new()
local const = THIS.ENV.CONST




--- get account
--- no account for name
handle:attachMsgHandle(protocol.Header.ACK_GET_ACCOUNT,
    ---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNT
    function(msg, msgstruct)
        print("ack get account!!")
        print(textutils.serialize(msgstruct))
    end)

handle:attachMsgHandle(protocol.Header.ACK_GET_ACCOUNTS,
    ---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS
    function(msg, msgstruct)
        print("ack get accounts!!")
        print(textutils.serialize(msgstruct))
    end)

handle:attachMsgHandle(protocol.Header.ACK_GET_OWNER_ACCOUNTS,
    ---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
    function(msg, msgstruct)
        print("ack get owner accounts!!")
        print(textutils.serialize(msgstruct))
    end)

handle:attachMsgHandle(protocol.Header.ACK_REGISTER,
    ---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
    function(msg, msgstruct)
        print("ack register!!")
        print(textutils.serialize(msgstruct))
    end)

handle:attachMsgHandle(protocol.Header.ACK_SEND,
    ---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_SEND
    function(msg, msgstruct)
        print("ack send!!")
        print(textutils.serialize(msgstruct))
    end)


local testFunc = function(i)
    if (i == 1) then
        -- no account
        client:send_GET_ACCOUNT("no", "no")
    elseif (i == 2) then
        -- no accounts
        client:send_GET_ACCOUNTS()
    elseif (i == 3) then
        -- no list
        client:send_GET_OWNER_ACCOUNT("noowner")
    elseif (i == 4) then
        -- no account to send
        local send_t = client:getSend_t()
        send_t.balance = 0
        send_t.from = "no"
        send_t.fromMsg = "no"
        send_t.owner = "nono"
        send_t.password = "no"
        send_t.to = "ho"
        send_t.toMsg = "hoho"
        client:send_SEND(send_t)
    elseif (i == 5) then
        -- success
        client:send_REGISTER("aname", "oname", "passwd")
    else
        return false
    end
    return true
end

local testFunc2 = function(i)
    if (i == 1) then
        -- one account aname
        client:send_GET_ACCOUNTS()
    elseif (i == 2) then
        --- no acc
        client:send_GET_ACCOUNT("aname2", "passwd")
    elseif (i == 3) then
        -- passwd unmet
        client:send_GET_ACCOUNT("aname", "passwd2")
    elseif (i == 4) then
        -- success
        client:send_GET_ACCOUNT("aname", "passwd")
    elseif (i == 5) then
        -- no list
        client:send_GET_OWNER_ACCOUNT("oname2")
    elseif (i == 6) then
        -- one list aname
        client:send_GET_OWNER_ACCOUNT("oname")
    else
        return false
    end
    return true
end

local testFunc3 = function(i)
    if (i == 1) then
        client:send_REGISTER("aname", "oname", "passwd")
    elseif (i == 2) then
        client:send_REGISTER("aname", "oname2", "passwd")
    elseif (i == 3) then
        client:send_REGISTER("aname2", "oname2", "passwd2")
    else
        return false
    end
    return true
end

local testFunc4 = function(i)
    local send_t = client:getSend_t()
    send_t.balance = 0
    send_t.from = "aname"
    send_t.fromMsg = "frommsg"
    send_t.owner = "oname"
    send_t.password = "passwd"
    send_t.to = "aname2"
    send_t.toMsg = "tomsg"
    if (i == 1) then
        -- balance cannot be neg
        send_t.balance = -1
        client:send_SEND(send_t)
    elseif (i == 2) then
        -- no account to send
        send_t.from = "aname_none"
        client:send_SEND(send_t)
    elseif (i == 3) then
        -- owner unmet
        send_t.owner = "oname_none"
        client:send_SEND(send_t)
    elseif (i == 4) then
        -- no balanace left to send
        send_t.balance = 100
        client:send_SEND(send_t)
    elseif (i == 5) then
        -- password unmet
        send_t.password = "passwd_none"
        client:send_SEND(send_t)
    elseif (i == 6) then
        -- no account to recieve
        send_t.to = "aname2_none"
        client:send_SEND(send_t)
    elseif (i == 7) then
        --- success
        client:send_SEND(send_t)
    else
        return false
    end
    return true
end


local timer = os.startTimer(2)
local calltest_i = 1

while true do
    local a, b, c, d = os.pullEvent()
    if a == "rednet_message" and d == const.protocol then
        print("----------")
        handle:parse(c)
    end

    if a == "timer" and b == timer then
        if testFunc(calltest_i) == false then break end
        calltest_i = calltest_i + 1
        timer = os.startTimer(2)
    end
end

calltest_i = 1
while true do
    local a, b, c, d = os.pullEvent()
    if a == "rednet_message" and d == const.protocol then
        print("----------")
        handle:parse(c)
    end

    if a == "timer" and b == timer then
        if testFunc2(calltest_i) == false then break end
        calltest_i = calltest_i + 1
        timer = os.startTimer(2)
    end
end

calltest_i = 1
while true do
    local a, b, c, d = os.pullEvent()
    if a == "rednet_message" and d == const.protocol then
        print("----------")
        handle:parse(c)
    end

    if a == "timer" and b == timer then
        if testFunc3(calltest_i) == false then break end
        calltest_i = calltest_i + 1
        timer = os.startTimer(2)
    end
end

calltest_i = 1
while true do
    local a, b, c, d = os.pullEvent()
    if a == "rednet_message" and d == const.protocol then
        print("----------")
        handle:parse(c)
    end

    if a == "timer" and b == timer then
        if testFunc4(calltest_i) == false then break end
        calltest_i = calltest_i + 1
        timer = os.startTimer(2)
    end
end

--- get accounts
--- no bank files

--- get owner accounts
--- no owner files

--- send
--- no account to send
