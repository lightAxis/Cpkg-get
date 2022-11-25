---@class Golkin.Web.Protocol.Enum
local a = {}

---result enum for ACK_OWNER_LOGIN msg
---@enum Golkin.Web.Protocol.Enum.ACK_OWNER_LOGIN_R 
a.ACK_OWNER_LOGIN_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_OWNER_EXIST"] = -101, -- error code when no owner exist
    ["PASSWORD_UNMET"] = -102, -- error code when login password unmet
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 101, -- success to login
}

---result enum for ACK_GETACCOUNT msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNT_R 
a.ACK_GET_ACCOUNT_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_ACCOUNT_FOR_NAME"] = -301, -- error code when no account for name exist in server
    ["PASSWD_UNMET"] = -302, -- error code when password not match with
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 301, -- success to get account
}

---result enum for ACK_GETACCOUNTS msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNTS_R 
a.ACK_GET_ACCOUNTS_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_BANK_FILE"] = -401, -- error code when no banking accounts exist at bank server
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 401, -- success to get accounts
}

---result enum for ACK_GET_OWNERS msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_OWNERS_R 
a.ACK_GET_OWNERS_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_OWNERS"] = -201, -- error code when no owner exist in server
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 201, -- success to get owner list from server
}

---result enum fro ACK_REGISTER_OWNER msg
---@enum Golkin.Web.Protocol.Enum.ACK_REGISTER_OWNER_R 
a.ACK_REGISTER_OWNER_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["OWNER_ALREADY_EXISTS"] = -601, -- owner name already exist in server
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 601, -- success to register new owner to server
}

---result enum for ACK_GET_OWNER_ACCOUNTS
---@enum Golkin.Web.Protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R 
a.ACK_GET_OWNER_ACCOUNTS_R = {
    ["NONE"] = -1, -- none result. this is error
    ["NO_ACCOUNTS"] = -801, -- no accounts for owner
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 801, -- success to get accounts list
}

---result enum for ACK_SEND msg
---@enum Golkin.Web.Protocol.Enum.ACK_SEND_R 
a.ACK_SEND_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_ACCOUNT_TO_SEND"] = -701, -- no account to send money from
    ["NO_ACCOUNT_TO_RECIEVE"] = -702, -- no account to recieve money
    ["NOT_ENOUGHT_BALLANCE_TO_SEND"] = -703, -- not enough money left in account to send
    ["PASSWORD_UNMET"] = -704, -- password is not corrent
    ["OWNER_UNMET"] = -705, -- Owner is not matching
    ["BALANCE_CANNOT_BE_NEGATIVE"] = -706, -- balance value is less than 0
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 701, -- success to send money
}

---result enum for ACK_REGISTER msg
---@enum Golkin.Web.Protocol.Enum.ACK_REGISTER_R 
a.ACK_REGISTER_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["ACCOUNT_ALREADY_EXISTS"] = -501, -- account name already exist in server error
    ["ACCOUNT_OWNER_UNMET"] = -502, -- account already exist, and owner is different
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 501, -- success to register new account to server
}


return a
