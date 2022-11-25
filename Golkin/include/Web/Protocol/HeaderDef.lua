---@enum Golkin.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["GET_OWNER_ACCOUNTS"] = 0, -- get accounts of owner from server
    ["OWNER_LOGIN"] = 1, -- login owner
    ["ACK_GET_OWNER_ACCOUNTS"] = 2, -- reply to get_owner_account msg
    ["ACK_GET_ACCOUNT"] = 3, -- reply to get_account msg
    ["ACK_SEND"] = 4, -- reply send money to other account
    ["ACK_GET_OWNERS"] = 5, -- reply to get_owners msg
    ["SEND"] = 6, -- request send money to other account
    ["ACK_GET_ACCOUNTS"] = 7, -- reply msg of get accounts list from server
    ["GET_ACCOUNTS"] = 8, -- get account list from server
    ["ACK_REGISTER"] = 9, -- reply register new account to server
    ["REGISTER"] = 10, -- register new account to server
    ["GET_OWNERS"] = 11, -- get all owner list from server
    ["ACK_OWNER_LOGIN"] = 12, -- reply to login owner msg
    ["GET_ACCOUNT"] = 13, -- get account info from server
}

---@class Golkin.Web.Protocol.MsgStruct.IMsgStruct

return a
