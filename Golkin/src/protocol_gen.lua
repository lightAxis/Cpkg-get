local THIS = require("Golkin.pkg_init")

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
builder:addEnum(enum("ACK_GET_ACCOUNT_R", "result enum for ACK_GETACCOUNT msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_ACCOUNT_FOR_NAME", -101, "error code when no account for name exist in server"),
    enumElm("PASSWD_UNMET", -102, "error code when password not match with"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 101, "success to get account")
}))

builder:addEnum(enum("ACK_GET_ACCOUNTS_R", "result enum for ACK_GETACCOUNTS msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_BANK_FILE", -201, "error code when no banking accounts exist at bank server"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 201, "success to get accounts")
}))

builder:addEnum(enum("ACK_GET_HISTORY_R", "result enum for ACK_GETHISTORY msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_ACCOUNT", -301, "error when no account in that name account exists"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 301, "success to get histories")
}))

builder:addEnum(enum("ACK_REGISTER_R", "result enum for ACK_REGISTER msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("ACCOUNT_ALREADY_EXISTS", -401, "account name already exist in server error"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 401, "success to register new account to server")
}))

builder:addEnum(enum("ACK_SEND_R", "result enum for ACK_SEND msg", {
    enumElm("NONE", -1, "none result. this is error!"),
    enumElm("NO_ACCOUNT_TO_SEND", -501, "no account to send money from"),
    enumElm("NO_ACCOUNT_TO_RECIEVE", -502, "no account to recieve money"),
    enumElm("NOT_ENOUGHT_BALLANCE_TO_SEND", -503, "not enough money left in account to send"),
    enumElm("NORMAL", 0, "standard for normal msg"),
    enumElm("SUCCESS", 501, "success to send money")
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
    field("Daytime", fieldType(efieldType.table, "number", builder:getStructClassName("Daytime_t")),
        fieldInit(efieldType.table, nil, nil),
        "daytime when this history occured"),
}))

builder:addStruct(struct("Account_t", "strcut for bank account info", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of this account"),
    field("Owner", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner of this account. must be ingame data"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_),
        "password of account for login, sending money. MD5 hashed"),
    field("Balance", fieldType(efieldType.num), fieldInit(efieldType.num, 0), "balance left in this account"),
    field("Histories", fieldType(efieldType.table, "number", builder:getStructClassName("History_t")),
        fieldInit(efieldType.table, nil, nil),
        "account histories"),
}))

--- headers definitions

builder:addHeader(struct("GET_ACCOUNT", "get account info from server", {
    field("UserName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of the account to get"),
    field("IDToSendBack", fieldType(efieldType.num), fieldInit(efieldType.nil_), "id to send back account info"),
}))

builder:addHeader(struct("ACK_GET_ACCOUNT", "reply to get_account msg", {
    field("Account", fieldType(efieldType.custom, builder:getStructClassName("Account_t")),
        fieldInit(efieldType.table, nil, nil), "account table field"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.bool, false), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_ACCOUNT_R")),
        fieldInit(efieldType.num, -1), "result enum")
}))

builder:addHeader(struct("GET_ACCOUNTS", "get account list from server", {
    field("IDToSendBack", fieldType(efieldType.num), fieldInit(efieldType.nil_), "id to send ack msg back")
}))

builder:addHeader(struct("ACK_GET_ACCOUNTS", "reply msg of get accounts list from server", {
    field("AccountsList", fieldType(efieldType.table, "number", "string"), fieldInit(efieldType.table, nil, nil),
        "list of account in server"),
    field("Success", fieldType(efieldType.bool), fieldInit("bool", false), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_ACCOUNTS_R")),
        fieldInit(efieldType.num, -1), "return state of msg"),
}))

builder:addHeader(struct("GET_HISTORY", "get account history of specific name", {
    field("UserName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "username to search history"),
    field("Count", fieldType(efieldType.num), fieldInit(efieldType.num, -1), "count to read at server"),
    field("IDToSendBack", fieldType(efieldType.num), fieldInit(efieldType.nil_), "id to send back ack on this"),
}))

builder:addHeader(struct("ACK_GET_HISTORY", "get history of account in count", {
    field("Histories", fieldType(efieldType.table, "number", builder:getStructClassName("History_t")),
        fieldInit(efieldType.table, nil, nil), "history of account"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_HISTORY_R")),
        fieldInit(efieldType.num, -1), "return state")
}))

builder:addHeader(struct("REGISTER", "register new account to server", {
    field("AccountName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "account name to create"),
    field("UserName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "username to register"),
    field("IDToSendBack", fieldType(efieldType.num), fieldInit(efieldType.num, -1), "id to send reply back"),
}))

builder:addHeader(struct("ACK_REGISTER", "reply register new account to server", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the request or not"),
    field("State",
        fieldType(efieldType.custom, builder:getEnumClassName("ACK_REGISTER_R")), fieldInit(efieldType.num, -1),
        "state of request"),
}))

builder:addHeader(struct("SEND", "request send money to other account", {
    field("From", fieldType(efieldType.str), fieldInit(efieldType.nil_), "sending money from Account"),
    field("FromMsg", fieldType(efieldType.str), fieldInit(efieldType.nil_), "display msg as in sender history name"),
    field("To", fieldType(efieldType.str), fieldInit(efieldType.nil_), "recieve money from account"),
    field("ToMsg", fieldType(efieldType.str), fieldInit(efieldType.nil_), "display msg as in reciever history name"),
    field("Balance", fieldType(efieldType.num), fieldInit(efieldType.nil_), "balance to send"),
    field("IDToSendBack", fieldType(efieldType.num), fieldInit(efieldType.nil_), "ID to send back reply"),
}))

builder:addHeader(struct("ACK_SEND", "reply send money to other account", {
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success the send action or not"),
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_SEND_R")), fieldInit(efieldType.num, -1),
        "result state to reply"),
}))

builder:generate(PKGS.Golkin.ENV.PATH .. "/include/Web/Protocol")
builder:generateHandler(PKGS.Golkin.ENV.PATH .. "/include/Web", "require(\"Class.middleclass\")")
