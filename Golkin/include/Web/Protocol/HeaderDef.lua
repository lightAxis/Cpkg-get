---@enum Golkin.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["GET_OWNER_ACCOUNTS"] = 0, -- get accounts of owner from server
    ["OWNER_LOGIN"] = 1, -- login owner
    ["ACK_GET_OWNER_ACCOUNTS"] = 2, -- reply to get_owner_account msg
    ["ACK_GET_ACCOUNT"] = 3, -- reply to get_account msg
    ["ACK_SEND"] = 4, -- reply send money to other account
    ["ACK_OWNER_LOGIN"] = 5, -- reply to login owner msg
    ["ACK_REGISTER_OWNER"] = 6, -- reply to register owner msg
    ["ACK_GET_OWNERS"] = 7, -- reply to get_owners msg
    ["SEND"] = 8, -- request send money to other account
    ["ACK_GET_ACCOUNTS"] = 9, -- reply msg of get accounts list from server
    ["GET_ACCOUNTS"] = 10, -- get account list from server
    ["ACK_REGISTER"] = 11, -- reply register new account to server
    ["REGISTER"] = 12, -- register new account to server
    ["GET_OWNERS"] = 13, -- get all owner list from server
    ["REGISTER_OWNER"] = 14, -- register new owner to server
    ["GET_ACCOUNT"] = 15, -- get account info from server
}

---@class Golkin.Web.Protocol.MsgStruct.IMsgStruct

return a
