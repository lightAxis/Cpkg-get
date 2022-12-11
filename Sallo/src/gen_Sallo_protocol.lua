local THIS = require("Sallo.pkg_init")

-- you must disable all web include in Golkin/pkg_init.lua to build

local Crotocol = DEPS.Sallo.Crotocol

local builder = Crotocol.Builder:new("Sallo.Web.Protocol", "Sallo.include.Web.Protocol")
local enum = Crotocol.enum_t.new
local enumElm = Crotocol.enumElm_t.new
local struct = Crotocol.struct_t.new
local field = Crotocol.field_t.new
local efieldType = Crotocol.GenTool.Type
local fieldType = Crotocol.GenTool.makeTypeStr
local fieldInit = Crotocol.GenTool.makeInitStr


--- enum
builder:addEnum(enum("RANK_NAME", "enum name", {
    enumElm("NONE", -1, "this is error"),
    enumElm("UNRANKED", 0, "level 0"),
    enumElm("BRONZE", 1, "level 1"),
    enumElm("SILVER", 2, "level 2"),
    enumElm("GOLD", 3, "level 3"),
    enumElm("PLATINUM", 4, "level 4"),
    enumElm("DIAMOND", 5, "level 5"),
    enumElm("MASTER", 6, "level 6"),
    enumElm("GRANDMASTER", 7, "level 7"),
    enumElm("CHALLENGER", 8, "level 8"),
    enumElm("MASTERCHALLENGER", 9, "level 9"),
    enumElm("SELENDIS", 10, "level 10"),
    enumElm("HONOR", 11, "level 11"),
    enumElm("RAGE", 12, "level 12"),
    enumElm("BAHAR", 13, "level 13"),
    enumElm("ARCANE", 14, "level 14"),
    enumElm("BLUEHOLE", 15, "level 15"),
    enumElm("SKULL", 16, "level 16"),
    enumElm("HALLOFFAME", 17, "level inf"),
}))

builder:addEnum(enum("THEMA", "thema of sallo", {
    enumElm("NONE", -1, "this is error"),
    enumElm("NO_THEMA", 0, "no thema"),
    enumElm("LESS_THAN_WORM", 1, "level 1, brown"),
    enumElm("QUICKSILVER", 2, "level 2, gray"),
    enumElm("GOLDILOCKS_ZONE", 3, "level 3 yellow"),
    enumElm("PLATINA_DISCO", 4, "level 4, green"),
    enumElm("DIAMOND_FOR_EVER", 5, "level 5 cyan"),
    enumElm("MASTERPIECE", 6, "level 6 lime"),
    enumElm("GRAND_MOMS_TOUCH", 7, "level 7 yellow red "),
    enumElm("CHALLENGER_DEEP", 8, "level 8 dark, blue"),
    enumElm("MONSTER_CHALLANGE", 9, "level 9 purple"),
    enumElm("ARTANIS", 10, "level 10 white"),
    enumElm("HONOR_OF_MANKIND", 11, "level 11 light gray"),
    enumElm("OUTRAGED_JELLYBIN", 12, "level 12 pink"),
    enumElm("BA(NJU)HAR(A)", 13, "level 13 magenta"),
    enumElm("THE_ONYX_NIGHT_SKY", 14, "level 14 light orange"),
    enumElm("EYE_OF_EVENT_HORIZON", 15, "level 15 purple, yellow"),
    enumElm("PETROLLIC_REPUBLIC", 16, "level 16 black"),
    enumElm("HALLOFFAME", 17, "level inf"),
    enumElm("BACK_TO_NORMAL", 18, "level 0 normal")
}))

builder:addEnum(enum("SKILLTYPE", "type of skill", {
    enumElm("NONE", -1, "this is error!"),
    enumElm("EFFICIENCY", 1, "efficiency"),
    enumElm("PROFICIENCY", 2, "proficiency"),
    enumElm("CONCENTRATION", 3, "concentration"),
}))

builder:addEnum(enum("ITEM_TYPE", "enum of item type", {
    enumElm("NONE", -1, "this is error"),
    enumElm("THEMA", 1, "thema item to decorate name in leaderboard"),
}))

builder:addEnum(enum("ACK_REGISTER_INFO_R", "reply enum of ACK_REGISTER_INFO", {
    enumElm("NONE", -1, "this is error"),
    enumElm("INFO_ALREADY_EXISTS", -101, "info file is already exists"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 101, "success"),
}))

builder:addEnum(enum("ACK_SET_INFO_CONNECTED_ACCOUNT_R", "reply enum of ACK_SET_INFO_CONNECTED_ACCOUNT", {
    enumElm("NONE", -1, "this is error"),
    enumElm("INFO_NOT_EXIST", -201, "info not exist in sallo server"),
    enumElm("INFO_PASSWD_UNMET", -202, "info password is not matching"),
    enumElm("ACCOUNT_NOT_EXIST", -203, "account not exist in golkin server"),
    enumElm("ACCOUNT_OWNER_UNMET", -204, "account owner in unmet in  golkin server"),
    enumElm("ACCOUNT_PASSWD_UNMET", -205, "account password in unmnet in golkin server"),
    enumElm("BANKING_REQUEST_TIMEOUT", -206, "timeout for banking request"),
    enumElm("BANKING_ERROR", -207, "account from banking has error"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 201, "success")
}))

builder:addEnum(enum("ACK_GET_INFO_R", "reply enum of ACK_GET_INFO", {
    enumElm("NONE", -1, "this is error!"),
    enumElm("NORMAL", 0, "standard for success or not"),
    enumElm("INFO_NOT_EXIST", -301, "info file is corrupted"),
    enumElm("SUCCESS", 301, "success"),
}))

builder:addEnum(enum("ACK_GET_INFOS_R", "reply enum of ACK_GET_INFOS", {
    enumElm("NONE", -1, "this is error!"),
    enumElm("NO_INFO_EXIST", -401, "no info is registered in server"),
    enumElm("NORMAL", 0, "standard for success or not"),
    enumElm("SUCCESS", 401, "success"),
}))

builder:addEnum(enum("ACK_CHANGE_SKILL_STAT_R", "reply enum of ACK_CHANGE_SKILL_STAT", {
    enumElm("NONE", -1, "this is error"),
    enumElm("NO_OWNER_EXIST", -501, "no owner exist in ownerName"),
    enumElm("TOTAL_SKILLPT_UNMET", -502, "total skillpoint in larger than current info"),
    enumElm("SKILL_UNLOCK_CONDITION_UNMET", -503, "skill unlock state does not make sense"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 501, "success")
}))

builder:addEnum(enum("ACK_BUY_RANK_R", "reply enum of ACK_BUY_RANK", {
    enumElm("NONE", -1, "this is error!"),
    enumElm("NO_INFO", -601, "no owner exist in owner names"),
    enumElm("SALLO_PASSWORD_UNMET", -602, "password of sallo info unmnet"),
    enumElm("RANK_ALREADY_EXIST", -603, "rank already bought"),
    enumElm("RANK_UNLOCK_CONDITION_UNMET", -604, "the unlock condition of this rank is unmet"),
    enumElm("NO_CONNECTED_ACCOUNT", -605, "no connected account to pay"),
    enumElm("BANKING_REQUEST_TIMEOUT", -606, "banking request timeout"),
    enumElm("BANKING_ERROR", -607, "when banking error occurs"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 601, "success")
}))

builder:addEnum(enum("ACK_BUY_THEMA_R", "reply enum of ACK_BUY_THEMA", {
    enumElm("NONE", -1, "this is error!"),
    enumElm("NO_INFO", -701, "no owner exist in owner names"),
    enumElm("SALLO_PASSWORD_UNMET", -702, "password of sallo info unmnet"),
    enumElm("THEMA_ALREADY_EXIST", -703, "thema already exist in item"),
    enumElm("THEMA_UNLOCK_CONDITION_UNMET", -704, "the unlock condition of this thema is unmet"),
    enumElm("NO_CONNECTED_ACCOUNT", -705, "no connected account to pay"),
    enumElm("BANKING_REQUEST_TIMEOUT", -706, "banking request timeout"),
    enumElm("BANKING_ERROR", -707, "when banking error occurs"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 701, "success")
}))



--- structs
builder:addStruct(struct("thema_t", "struct of thema by sallo", {
    field("Enum", fieldType(efieldType.custom, builder:getEnumClassName("THEMA")), fieldInit(efieldType.num, -1),
        "enum of thema"),
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of thema"),
    field("isAquired", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "boolean is get?"),
    field("isVisible", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "is visible in the rank?"),
}))

builder:addStruct(struct("main_t", "struct of main bu sallo", {
    field("Level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "level number of info"),
    field("Rank", fieldType(efieldType.custom, builder:getEnumClassName("RANK_NAME")), fieldInit(efieldType.num, -1),
        "rank enum of info"),
    field("Exp_gauge", fieldType(efieldType.num), fieldInit(efieldType.nil_), "max guage of current rank info"),
    field("Exp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "current exp filled"),
    field("Act_gauge", fieldType(efieldType.num), fieldInit(efieldType.nil_), "max act gauge"),
    field("Act_left", fieldType(efieldType.num), fieldInit(efieldType.nil_), "act point left today"),
}))

builder:addStruct(struct("stat_t", "struct of state by sallo", {
    field("Exp_per_min", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp per minute"),
    field("Act_per_minute", fieldType(efieldType.num), fieldInit(efieldType.nil_), "act usage per minute"),
    field("Gold_per_minute", fieldType(efieldType.num), fieldInit(efieldType.nil_), "goldary per minute"),
    field("Exp_per_act", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp accisition per act"),
    field("Act_amplifier", fieldType(efieldType.num), fieldInit(efieldType.nil_), "act amplifer for act gauge"),
    field("Gold_per_act", fieldType(efieldType.num), fieldInit(efieldType.nil_), "salaray per act point"),
}))

builder:addStruct(struct("statistics_t", "struct of statistics by sallo", {
    field("Today_exp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp get today"),
    field("Today_act", fieldType(efieldType.num), fieldInit(efieldType.nil_), "act get today"),
    field("Today_gold", fieldType(efieldType.num), fieldInit(efieldType.nil_), "goldary get today"),
    field("Total_exp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp get total"),
    field("Total_act", fieldType(efieldType.num), fieldInit(efieldType.nil_), "act get total"),
    field("Total_gold", fieldType(efieldType.num), fieldInit(efieldType.nil_), "goldary get total"),
}))

builder:addStruct(struct("skillState_t", "struct of skill state in info by sallo", {
    field("Total_sp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "total skill point get until now"),
    field("Left_sp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "skill point left"),
    field("Concentration_level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "concentration skill level"),
    field("Efficiency_level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "efficiency skill level"),
    field("Proficiency_level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "proficiency skill level"),
}))

builder:addStruct(struct("history_t", "struct of info history by sallo", {
    field("DateTime", fieldType(efieldType.str), fieldInit(efieldType.nil_), "time when this history made"),
    field("Data", fieldType(efieldType.str), fieldInit(efieldType.nil_), "content of history by raw string")
}))

builder:addStruct(struct("item_t", "struct of item", {
    field("ItemType", fieldType(efieldType.custom, builder:getEnumClassName("ITEM_TYPE")),
        fieldInit(efieldType.num, -1), "item type enum"),
    field("ItemIndex", fieldType(efieldType.num), fieldInit(efieldType.nil_), "item index, by enum"),
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of the item")
}))

-- struct
builder:addStruct(struct("info_t", "all information table of one person", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of sallo info"),
    field("Password", fieldType(efieldType.str), fieldInit(efieldType.nil_),
        "password when used to revise the info content"),
    field("AccountName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "account connected to this info"),
    field("Thema", fieldType(efieldType.custom, builder:getStructClassName("thema_t")), fieldInit(efieldType.nil_),
        "thema struct field"),
    field("Main", fieldType(efieldType.custom, builder:getStructClassName("main_t")),
        fieldInit(efieldType.table, nil, nil),
        "main field of info"),
    field("Stat", fieldType(efieldType.custom, builder:getStructClassName("stat_t")),
        fieldInit(efieldType.table, nil, nil),
        "stat field of info"),
    field("Statistics", fieldType(efieldType.custom, builder:getStructClassName("statistics_t")),
        fieldInit(efieldType.table, nil, nil),
        "statistics fiedl of info"),
    field("SkillState", fieldType(efieldType.custom, builder:getStructClassName("skillState_t")),
        fieldInit(efieldType.table, nil, nil),
        "skill state of info"),
    field("Histories", fieldType(efieldType.table, "number", builder:getStructClassName("history_t")),
        fieldInit(efieldType.table, nil, nil),
        "history field of info. go"),
    field("Items", fieldType(efieldType.table, "number", builder:getStructClassName("item_t")),
        fieldInit(efieldType.table, nil, nil), "owned items list for info"),
    field("SalaryLeft", fieldType(efieldType.num), fieldInit(efieldType.nil_), "salary left to send to player")
}))

--- header
builder:addHeader(struct("REGISTER_INFO", "register new info with passwd", {
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of this info"),
    field("Passwd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "passwd using when edit this info"),
}))

builder:addHeader(struct("ACK_REGISTER_INFO", "reply of REGISTER_INFO", {
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_REGISTER_INFO_R")),
        fieldInit(efieldType.num, -1), "result state enum"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not"),
}))

builder:addHeader(struct("SET_INFO_CONNECTED_ACCOUNT", "set connection between sallo info and golkin account", {
    field("InfoName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of info to connect"),
    field("InfoPasswd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "password of info"),
    field("AccountName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of account to connect"),
    field("AccountPasswd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "passwd of account to connect"),
    field("AccountOwner", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner of account to connect"),
}))

builder:addHeader(struct("ACK_SET_INFO_CONNECTED_ACCOUNT", "reply of SET_INFO_CONNECTED_ACCOUNT", {
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_SET_INFO_CONNECTED_ACCOUNT_R")),
        fieldInit(efieldType.num, -1), "state of result"),
    field("BankErrorMsg", fieldType(efieldType.str), fieldInit(efieldType.nil_), "error msg from banking"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not"),
}))

builder:addHeader(struct("GET_INFO", "give back info_t of sallo", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of sallo info to request")
}))

builder:addHeader(struct("ACK_GET_INFO", "reply msg of GET_INFO", {
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_INFO_R")),
        fieldInit(efieldType.num, -1),
        "state enum of reply"),
    field("Success", fieldType(efieldType.bool), fieldType(efieldType.nil_), "success or not "),
    field("Info", fieldType(efieldType.custom, builder:getStructClassName("info_t")),
        fieldInit(efieldType.table, nil, nil), "serialized info str"),
}))

builder:addHeader(struct("GET_INFOS", "give back info list", {

}))

builder:addHeader(struct("ACK_GET_INFOS", "reply of GET_INFOS", {
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_INFOS_R")),
        fieldInit(efieldType.num, -1), "state of reply"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not"),
    field("Infos", fieldType(efieldType.table, "number", builder:getStructClassName("info_t")),
        fieldInit(efieldType.table, nil, nil), "info name list from server")
}))

builder:addHeader(struct("CHANGE_SKILL_STAT", "send reserve skillpoint reset to server", {
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of info"),
    field("SkillState", fieldType(efieldType.custom, builder:getStructClassName("skillState_t")),
        fieldInit(efieldType.nil_), "skill state to reserve reset")
}))

builder:addHeader(struct("ACK_CHANGE_SKILL_STAT", "reply msg of RESETVE_SKILLPT_RESET", {
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_CHANGE_SKILL_STAT_R")),
        fieldInit(efieldType.num, -1), "return state"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not"),
}))

builder:addHeader(struct("BUY_RANK", "buy skill from account", {
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of info and account"),
    field("InfoPasswd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "info password"),
    field("AccountPasswd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "passwd of account to send send"),
    field("Rank", fieldType(efieldType.custom, builder:getEnumClassName("RANK_NAME")),
        fieldInit(efieldType.num, -1), "rank to buy"),
}))

builder:addHeader(struct("ACK_BUY_RANK", "reply msg of BUY_RANK", {
    field("State", fieldType(efieldType.custom, builder:getEnumClassName("ACK_BUY_RANK_R")),
        fieldInit(efieldType.num, -1), "result state enum"),
    field("Banking_state", fieldType(efieldType.num), fieldInit(efieldType.num, -1), "banking state from golkin"),
    field("Success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not")
}))

builder:addHeader(struct("BUY_THEMA", "buy skill from account", {
    field("OwnerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of info and account"),
    field("InfoPasswd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "info password"),
    field("AccountPasswd", fieldType(efieldType.str), fieldInit(efieldType.nil_), "passwd of account to send send"),
    field("Thema", fieldType(efieldType.custom, builder:getEnumClassName("THEMA")),
        fieldInit(efieldType.num, -1), "thema to buy"),
}))

builder:addHeader(struct("ACK_BUY_THEMA", "reply msg of BUY_THEMA", {
    field("state", fieldType(efieldType.custom, builder:getEnumClassName("ACK_BUY_THEMA_R")),
        fieldInit(efieldType.num, -1), "result state enum"),
    field("banking_state", fieldType(efieldType.num), fieldInit(efieldType.num, -1), "banking state from golkin"),
    field("success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not")
}))




builder:generate(THIS.ENV.PATH .. "/include/Web/Protocol")
builder:generateHandler(THIS.ENV.PATH .. "/include/Web", "require(\"Class.middleclass\")")
