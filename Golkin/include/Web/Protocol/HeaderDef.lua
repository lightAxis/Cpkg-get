---@enum Golkin.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["OWNER_LOGIN"] = 0, -- login owner
    ["ACK_REGISTER"] = 1, -- reply register new account to server
    ["REMOVE_ACCOUNT"] = 2, -- request remove account
    ["ACK_SEND"] = 3, -- reply send money to other account
    ["SEND"] = 4, -- request send money to other account
    ["ACK_GET_ACCOUNTS"] = 5, -- reply msg of get accounts list from server
    ["REGISTER"] = 6, -- register new account to server
    ["GET_OWNERS"] = 7, -- get all owner list from server
    ["REGISTER_OWNER"] = 8, -- register new owner to server
    ["GET_OWNER_ACCOUNTS"] = 9, -- get accounts of owner from server
    ["ACK_OWNER_LOGIN"] = 10, -- reply to login owner msg
    ["ACK_GET_ACCOUNT"] = 11, -- reply to get_account msg
    ["ACK_REMOVE_ACCOUNT"] = 12, -- reply of REMOVE_ACCOUNT
    ["GET_ACCOUNT"] = 13, -- get account info from server
    ["GET_ACCOUNTS"] = 14, -- get account list from server
    ["ACK_REGISTER_OWNER"] = 15, -- reply to register owner msg
    ["ACK_GET_OWNER_ACCOUNTS"] = 16, -- reply to get_owner_account msg
    ["ACK_GET_OWNERS"] = 17, -- reply to get_owners msg
}

---@class Golkin.Web.Protocol.MsgStruct.IMsgStruct

return a
