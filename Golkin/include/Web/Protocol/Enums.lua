---@class Golkin.Web.Protocol.Enum
local a = {}

---result enum for ACK_GETACCOUNT msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNT_R 
a.ACK_GET_ACCOUNT_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_ACCOUNT_FOR_NAME"] = -101, -- error code when no account for name exist in server
    ["PASSWD_UNMET"] = -102, -- error code when password not match with
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 101, -- success to get account
}

---result enum for ACK_GETACCOUNTS msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNTS_R 
a.ACK_GET_ACCOUNTS_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_BANK_FILE"] = -201, -- error code when no banking accounts exist at bank server
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 201, -- success to get accounts
}

---result enum for ACK_GET_OWNER_ACCOUNTS
---@enum Golkin.Web.Protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R 
a.ACK_GET_OWNER_ACCOUNTS_R = {
    ["NONE"] = -1, -- none result. this is error
    ["NO_ACCOUNTS"] = -501, -- no accounts for owner
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 501, -- success to get accounts list
}

---result enum for ACK_SEND msg
---@enum Golkin.Web.Protocol.Enum.ACK_SEND_R 
a.ACK_SEND_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["NO_ACCOUNT_TO_SEND"] = -401, -- no account to send money from
    ["NO_ACCOUNT_TO_RECIEVE"] = -402, -- no account to recieve money
    ["NOT_ENOUGHT_BALLANCE_TO_SEND"] = -403, -- not enough money left in account to send
    ["PASSWORD_UNMET"] = -404, -- password is not corrent
    ["OWNER_UNMET"] = -405, -- Owner is not matching
    ["BALANCE_CANNOT_BE_NEGATIVE"] = -406, -- balance value is less than 0
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 401, -- success to send money
}

---result enum for ACK_REGISTER msg
---@enum Golkin.Web.Protocol.Enum.ACK_REGISTER_R 
a.ACK_REGISTER_R = {
    ["NONE"] = -1, -- none result. this is error!
    ["ACCOUNT_ALREADY_EXISTS"] = -301, -- account name already exist in server error
    ["ACCOUNT_OWNER_UNMET"] = -302, -- account already exist, and owner is different
    ["NORMAL"] = 0, -- standard for normal msg
    ["SUCCESS"] = 301, -- success to register new account to server
}


return a
