require("Crotocol.pkg_init")

local includes = require("Crotocol.test.testCroto.Include")

local msg = includes.Msg.new()

msg.Header = includes.Header.GETHISTORY
msg.SendID = 2
msg.TargetID = 3

local msgstruct = includes.MsgStruct.GETHISTORY.new()
msgstruct.Count = 2
msgstruct.Owner = "me"
msgstruct.Drinks = {}
msgstruct.Eats = {}

msg.MsgStructStr = textutils.serialize(msgstruct)
local msgStr = textutils.serialize(msg)
print(msgStr)

local handle = require("Crotocol.test.testCroto.Handle"):new()

---comment
---@param msg Crotocol.testProto.Msg
---@param msgstruct Crotocol.testProto.MsgStruct.GETHISTORY
local a = function(msg, msgstruct)
    print(msg.Header)
    print(msg.SendID)
    print(msg.TargetID)
    print(msgstruct)
    print(textutils.serialize(msgstruct))
end
handle:attachMsgHandle(includes.Header.GETHISTORY, a)


handle:parse(msgStr)
