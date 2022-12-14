local THIS = require("Golkin.pkg_init")

-- you must disable all web include in Golkin/pkg_init.lua to build

local Crotocol = DEPS.Golkin.Crotocol

local builder = Crotocol.Builder:new("Golkin.Web.Protocol", "Golkin.include.Web.Protocol")
local enum = Crotocol.enum_t.new
local enumElm = Crotocol.enumElm_t.new
local struct = Crotocol.struct_t.new
local field = Crotocol.field_t.new
local efieldType = Crotocol.GenTool.Type
local fieldType = Crotocol.GenTool.makeTypeStr
local fieldInit = Crotocol.GenTool.makeInitStr

--- add enums
builder:addEnum(enum("ACK_OWNER_LOGIN_R", "result enum for ACK_OWNER_LOGIN msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_OWNER_EXIST", -101, "error code when no owner exist"),
    enumElm("PASSWORD_UNMET", -102, "error code when login password unmet"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 101, "success to login")
}))

builder:addEnum(enum("ACK_GET_OWNERS_R", "result enum for ACK_GET_OWNERS msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_OWNERS", -201, "error code when no owner exist in server"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 201, "success to get owner list from server"),
}))

builder:addEnum(enum("ACK_GET_ACCOUNT_R", "result enum for ACK_GETACCOUNT msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_ACCOUNT_FOR_NAME", -301, "error code when no account for name exist in server"),
    enumElm("PASSWD_UNMET", -302, "error code when password not match with"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 301, "success to get account")
}))

builder:addEnum(enum("ACK_GET_ACCOUNTS_R", "result enum for ACK_GETACCOUNTS msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_BANK_FILE", -401, "error code when no banking accounts exist at bank server"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 401, "success to get accounts")
}))

builder:addEnum(enum("ACK_REGISTER_R", "result enum for ACK_REGISTER msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("ACCOUNT_ALREADY_EXISTS", -501, "account name already exist in server error"),
    enumElm("ACCOUNT_OWNER_UNMET", -502, "account already exist, and owner is different"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 501, "success to register new account to server")
}))

builder:addEnum(enum("ACK_REGISTER_OWNER_R", "result enum fro ACK_REGISTER_OWNER msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("OWNER_ALREADY_EXISTS", -601, "owner name already exist in server"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 601, "success to register new owner to server"),
}))

builder:addEnum(enum("ACK_SEND_R", "result enum for ACK_SEND msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_ACCOUNT_TO_SEND", -701, "no account to send money from"),
    enumElm("NO_ACCOUNT_TO_RECIEVE", -702, "no account to recieve money"),
    enumElm("NOT_ENOUGHT_BALLANCE_TO_SEND", -703, "not enough money left in account to send"),
    enumElm("PASSWORD_UNMET", -704, "password is not corrent"),
    enumElm("OWNER_UNMET", -705, "Owner is not matching"),
    enumElm("BALANCE_CANNOT_BE_NEGATIVE", -706, "balance value is less than 0"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 701, "success to send money")
}))

builder:addEnum(enum("ACK_GET_OWNER_ACCOUNTS_R", "result enum for ACK_GET_OWNER_ACCOUNTS", {
    enumElm("NONE", -1, "none result. this is error"),
    enumElm("NO_ACCOUNTS", -801, "no accounts for owner"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 801, "success to get accounts list"),
}))

builder:addEnum(enum("ACK_REMOVE_ACCOUNT_R", "result enum for ACK_REMOVE_ACCOUNT", {
    enumElm("NONE", -1, "none result. this is error"),
    enumElm("NO_ACCOUNTS", -901, "no accounts to remove"),
    enumElm("PASSWORD_UNMET", -902, "passwrod is not correct"),
    enumElm("OWNER_UNMET", -903, "Owner is not matching with account"),
    enumElm("OWNER_NOT_EXIST", -903, "owner of this account is not exist"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 901, "success to remove account"),
}))

--- make structs
builder:addStruct(struct("Daytime_t", "struct for represent daytime", {
    field("Realtime", fieldType(efieldType.str), fieldInit(efieldType.nil_), "time string from server")
}))

builder:addStruct(struct("History_t", "struct for banking history", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of this banking history"),
    field("InOut", fieldType(efieldType.num), fieldInit(efieldType.nil_),
        "input and output balance in this banking history"),
    field("BalanceLeft", fieldType(efieldType.num), fieldInit(efieldType.nil_), "balance left after this banking history"),
    field("Daytime", fieldType(efieldType.custom, builder:getStructClassName("Daytime_t")),
        fieldInit(efieldType.nil_), "daytime when this history occured"),
}))

builder:addStruct(struct("Account_t", "strcut for bank account info", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of this account"),
    field("Owner", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner of this account. must be ingame data"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_),
        "password of account for login, sending money. MD5 hashed"),
    field("Daytime", fieldType(efieldType.custom, builder:getStructClassName("Daytime_t")),
        fieldInit(efieldType.nil_), "daytime when this account registered"),
    field("Balance", fieldType(efieldType.num), fieldInit(efieldType.num, 0), "balance left in this account"),
    field("Histories", fieldType(efieldType.table, "number", builder:getStructClassName("History_t")),
        fieldInit(efieldType.table, nil, nil),
        "account histories"),
}))

builder:addStruct(struct("Owner_t", "struct for bank account owners", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of this owner"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_), "password of owner for login, MD5 hashed")
}))

--- headers definitions

builder:addHeader(struct("OWNER_LOGIN", "login owner", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of the owner"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_), "password for login. MD5 hashed"),
}))

builder:addHeader(struct("GET_OWNERS", "get all owner list from server", {
}))

builder:addHeader(struct("ACK_GET_OWNERS", "reply to get_owners msg", {
    field("OwnerNames", fieldType(efieldType.table, "number", "string"), fieldInit(efieldType.nil_),
        "names of owners in server"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_OWNERS_R")),
        fieldInit(efieldType.num, -1), "result state"),
}))

builder:addHeader(struct("ACK_OWNER_LOGIN", "reply to login owner msg", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_OWNER_LOGIN_R")),
        fieldInit(efieldType.num, -1), "result enum"),
}))

builder:addHeader(struct("GET_ACCOUNT", "get account info from server", {
    field("AccountName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of the account to get"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_), "md5 hashed password for account"),
}))

builder:addHeader(struct("ACK_GET_ACCOUNT", "reply to get_account msg", {
    field("Account", fieldType(efieldType.custom, builder:getStructClassName("Account_t")),
        fieldInit(efieldType.table, nil, nil), "account table field"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.bool, false), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_ACCOUNT_R")),
        fieldInit(efieldType.num, -1), "result enum")
}))

builder:addHeader(struct("GET_OWNER_ACCOUNTS", "get accounts of owner from server", {
    field("Owner", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner of the accounts"),
}))

builder:addHeader(struct("ACK_GET_OWNER_ACCOUNTS", "reply to get_owner_account msg",
    {
        field("Accounts", fieldType(efieldType.table, "number", builder:getStructClassName("Account_t")),
            fieldInit(efieldType.table, nil, nil), "accounts list"),
        field("Success", fieldType(efieldType.bool), fieldInit(efieldType.bool, false), "success the request or not"),
        field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_OWNER_ACCOUNTS_R")),
            fieldInit(efieldType.num, -1), "result enum")
    }))

builder:addHeader(struct("GET_ACCOUNTS", "get account list from server", {
}))

builder:addHeader(struct("ACK_GET_ACCOUNTS", "reply msg of get accounts list from server", {
    field("AccountsList", fieldType(efieldType.table, "number", "string"), fieldInit(efieldType.table, nil, nil),
        "list of account in server"),
    field("Success", fieldType(efieldType.bool), fieldInit("bool", false), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_ACCOUNTS_R")),
        fieldInit(efieldType.num, -1), "return state of msg"),
}))

builder:addHeader(struct("REGISTER", "register new account to server", {
    field("AccountName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "account name to create"),
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name to register"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_), "password for account"),
}))

builder:addHeader(struct("ACK_REGISTER", "reply register new account to server", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State",
        fieldType(efieldType.custom, builder:getEnumClassName("ACK_REGISTER_R")), fieldInit(efieldType.num, -1),
        "state of request"),
}))

builder:addHeader(struct("REGISTER_OWNER", "register new owner to server", {
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name to create"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_), "password for owner"),
}))

builder:addHeader(struct("ACK_REGISTER_OWNER", "reply to register owner msg", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_REGISTER_OWNER_R")),
        fieldInit(efieldType.num, -1), "return state"),
}))

builder:addHeader(struct("SEND", "request send money to other account", {
    field("From", fieldType(efieldType.str), fieldInit(efieldType.nil_), "sending money from Account"),
    field("FromMsg", fieldType(efieldType.str), fieldInit(efieldType.nil_), "display msg as in sender history name"),
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner of sender account"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_), "password of account"),
    field("To", fieldType(efieldType.str), fieldInit(efieldType.nil_), "recieve money from account"),
    field("ToMsg", fieldType(efieldType.str), fieldInit(efieldType.nil_), "display msg as in reciever history name"),
    field("Balance", fieldType(efieldType.num), fieldInit(efieldType.nil_), "balance to send"),
}))

builder:addHeader(struct("ACK_SEND", "reply send money to other account", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the send action or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_SEND_R")), fieldInit(efieldType.num, -1),
        "result state to reply"),
}))

builder:addHeader(struct("REMOVE_ACCOUNT", "request remove account", {
    field("AccountName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of account to remove"),
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of owner of account to remove"),
    field("OwnerPassword", fieldType(efieldType.str), fieldInit(efieldType.nil_), "account of password to remove"),
}))

builder:addHeader(struct("ACK_REMOVE_ACCOUNT", "reply of REMOVE_ACCOUNT", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_REMOVE_ACCOUNT_R")),
        fieldInit(efieldType.num, -1), "result state to reply")
}))


builder:generate(PKGS.Golkin.ENV.PATH .. "/include/Web/Protocol")
builder:generateHandler(PKGS.Golkin.ENV.PATH .. "/include/Web", "require(\"Class.middleclass\")")
