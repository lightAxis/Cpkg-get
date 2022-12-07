---@class Golkin.Web.Protocol.Enum_INV
local a = {}

---result enum for ACK_OWNER_LOGIN msg
---@enum Golkin.Web.Protocol.Enum.ACK_OWNER_LOGIN_R_INV 
a.ACK_OWNER_LOGIN_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-101] = "NO_OWNER_EXIST", -- error code when no owner exist
    [-102] = "PASSWORD_UNMET", -- error code when login password unmet
    [0] = "NORMAL", -- standard for normal msg
    [101] = "SUCCESS", -- success to login
}

---result enum for ACK_SEND msg
---@enum Golkin.Web.Protocol.Enum.ACK_SEND_R_INV 
a.ACK_SEND_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-701] = "NO_ACCOUNT_TO_SEND", -- no account to send money from
    [-702] = "NO_ACCOUNT_TO_RECIEVE", -- no account to recieve money
    [-703] = "NOT_ENOUGHT_BALLANCE_TO_SEND", -- not enough money left in account to send
    [-704] = "PASSWORD_UNMET", -- password is not corrent
    [-705] = "OWNER_UNMET", -- Owner is not matching
    [-706] = "BALANCE_CANNOT_BE_NEGATIVE", -- balance value is less than 0
    [0] = "NORMAL", -- standard for normal msg
    [701] = "SUCCESS", -- success to send money
}

---result enum for ACK_GETACCOUNTS msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNTS_R_INV 
a.ACK_GET_ACCOUNTS_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-401] = "NO_BANK_FILE", -- error code when no banking accounts exist at bank server
    [0] = "NORMAL", -- standard for normal msg
    [401] = "SUCCESS", -- success to get accounts
}

---result enum for ACK_GET_OWNERS msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_OWNERS_R_INV 
a.ACK_GET_OWNERS_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-201] = "NO_OWNERS", -- error code when no owner exist in server
    [0] = "NORMAL", -- standard for normal msg
    [201] = "SUCCESS", -- success to get owner list from server
}

---result enum for ACK_REGISTER msg
---@enum Golkin.Web.Protocol.Enum.ACK_REGISTER_R_INV 
a.ACK_REGISTER_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-501] = "ACCOUNT_ALREADY_EXISTS", -- account name already exist in server error
    [-502] = "ACCOUNT_OWNER_UNMET", -- account already exist, and owner is different
    [0] = "NORMAL", -- standard for normal msg
    [501] = "SUCCESS", -- success to register new account to server
}

---result enum fro ACK_REGISTER_OWNER msg
---@enum Golkin.Web.Protocol.Enum.ACK_REGISTER_OWNER_R_INV 
a.ACK_REGISTER_OWNER_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-601] = "OWNER_ALREADY_EXISTS", -- owner name already exist in server
    [0] = "NORMAL", -- standard for normal msg
    [601] = "SUCCESS", -- success to register new owner to server
}

---result enum for ACK_REMOVE_ACCOUNT
---@enum Golkin.Web.Protocol.Enum.ACK_REMOVE_ACCOUNT_R_INV 
a.ACK_REMOVE_ACCOUNT_R_INV = {
    [-1] = "NONE", -- none result. this is error
    [-901] = "NO_ACCOUNTS", -- no accounts to remove
    [-902] = "PASSWORD_UNMET", -- passwrod is not correct
    [-903] = "OWNER_UNMET", -- Owner is not matching with account
    [-903] = "OWNER_NOT_EXIST", -- owner of this account is not exist
    [0] = "NORMAL", -- standard for normal msg
    [901] = "SUCCESS", -- success to remove account
}

---result enum for ACK_GETACCOUNT msg
---@enum Golkin.Web.Protocol.Enum.ACK_GET_ACCOUNT_R_INV 
a.ACK_GET_ACCOUNT_R_INV = {
    [-1] = "NONE", -- none result. this is error!
    [-301] = "NO_ACCOUNT_FOR_NAME", -- error code when no account for name exist in server
    [-302] = "PASSWD_UNMET", -- error code when password not match with
    [0] = "NORMAL", -- standard for normal msg
    [301] = "SUCCESS", -- success to get account
}

---result enum for ACK_GET_OWNER_ACCOUNTS
---@enum Golkin.Web.Protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R_INV 
a.ACK_GET_OWNER_ACCOUNTS_R_INV = {
    [-1] = "NONE", -- none result. this is error
    [-801] = "NO_ACCOUNTS", -- no accounts for owner
    [0] = "NORMAL", -- standard for normal msg
    [801] = "SUCCESS", -- success to get accounts list
}


return a
