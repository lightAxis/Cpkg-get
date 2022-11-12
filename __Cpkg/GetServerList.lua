local tool = require("__Cpkg.Tool")

local client = require("__Cpkg.Web.Client")

client.Req_pkgInfos()

local time = os.startTimer(3)

local protocol = require("__Cpkg.Web.PkgLink.Include")
local handle = require("__Cpkg.Web.Handle")
handle:attachMsgHandle(protocol.Header.PKG_INFOS,
    ---comment
    ---@param msg __Cpkg.Web.PkgLink.Msg
    ---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS
    function(msg, msgstruct)

    end)
while true do
    --- event, id, msg, protocol
    ---event, timernum
    local a, b, c, d = os.pullEvent()
    if a == "timer" and b == time then
        print("Timeout! is server lost?")
        break;
    elseif a == "rednet_message" and d == "Cpkg-get" then

    end
end
