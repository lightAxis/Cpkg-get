---@enum Golkin.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["ACK_REGISTER"] = 0, -- reply register new account to server
    ["ACK_GET_HISTORY"] = 1, -- get history of account in count
    ["ACK_SEND"] = 2, -- reply send money to other account
    ["GET_ACCOUNT"] = 3, -- get account info from server
    ["SEND"] = 4, -- request send money to other account
    ["ACK_GET_ACCOUNTS"] = 5, -- reply msg of get accounts list from server
    ["GET_ACCOUNTS"] = 6, -- get account list from server
    ["GET_HISTORY"] = 7, -- get account history of specific name
    ["REGISTER"] = 8, -- register new account to server
    ["ACK_GET_ACCOUNT"] = 9, -- reply to get_account msg
}

---@class Golkin.Web.Protocol.MsgStruct.IMsgStruct

return a
