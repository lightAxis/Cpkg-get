---@enum Golkin.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["GET_OWNER_ACCOUNTS"] = 0, -- get accounts of owner from server
    ["ACK_REGISTER"] = 1, -- reply register new account to server
    ["ACK_GET_ACCOUNT"] = 2, -- reply to get_account msg
    ["ACK_SEND"] = 3, -- reply send money to other account
    ["GET_ACCOUNT"] = 4, -- get account info from server
    ["SEND"] = 5, -- request send money to other account
    ["ACK_GET_ACCOUNTS"] = 6, -- reply msg of get accounts list from server
    ["GET_ACCOUNTS"] = 7, -- get account list from server
    ["REGISTER"] = 8, -- register new account to server
    ["ACK_GET_OWNER_ACCOUNTS"] = 9, -- reply to get_owner_account msg
}

---@class Golkin.Web.Protocol.MsgStruct.IMsgStruct

return a
