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

builder:addEnum(enum("ACK_GET_INFO_R", "reply enum of ACK_GET_INFO", {
    enumElm("NONE", -1, "this is error!"),
    enumElm("NORMAL", 0, "standard for success or not"),
    enumElm("INFO_FILE_CORRUPTED", -101, "info file is corrupted"),
    enumElm("SUCCESS", 101, "success"),
}))

builder:addEnum(enum("ACK_RESERVE_SKILLPT_RESET_R", "reply enum of ACK_RESERVE_SKILLPT_RESET", {
    enumElm("NONE", -1, "this is error"),
    enumElm("NO_OWNER_EXIST", -201, "no owner exist in ownerName"),
    enumElm("SKILLPT_STATE_CONDITION_UNMET", -202, "skill point state does not make sense"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 201, "success")
}))

builder:addStruct(struct("thema_t", "struct of thema by sallo", {
    field("enum", fieldType(efieldType.custom, builder:getEnumClassName("THEMA")), fieldInit(efieldType.num, -1),
        "enum of thema"),
    field("name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of thema"),
    field("isAquired", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "boolean is get?"),
    field("isVisible", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "is visible in the rank?"),
}))

builder:addStruct(struct("main_t", "struct of main bu sallo", {
    field("level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "level number of info"),
    field("rank", fieldType(efieldType.custom, builder:getEnumClassName("RANK_NAME")), fieldInit(efieldType.num, -1),
        "rank enum of info"),
    field("salary", fieldType(efieldType.num), fieldInit(efieldType.nil_), "salary per hour number"),
    field("exp_gauge", fieldType(efieldType.num), fieldInit(efieldType.nil_), "max guage of current rank info"),
    field("exp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "current exp filled"),
    field("cap_gauge", fieldType(efieldType.num), fieldInit(efieldType.nil_), "max cap gauge"),
    field("cap_left", fieldType(efieldType.num), fieldInit(efieldType.nil_), "cap point left today"),
}))

builder:addStruct(struct("stat_t", "struct of state by sallo", {
    field("exp_per_min", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp per minute"),
    field("cap_per_minute", fieldType(efieldType.num), fieldInit(efieldType.nil_), "cap usage per minute"),
    field("gold_per_minute", fieldType(efieldType.num), fieldInit(efieldType.nil_), "goldary per minute"),
    field("exp_per_cap", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp accisition per cap"),
    field("cap_amplifier", fieldType(efieldType.num), fieldInit(efieldType.nil_), "cap amplifer for cap gauge"),
    field("gold_per_cap", fieldType(efieldType.num), fieldInit(efieldType.nil_), "salaray per cap point"),
}))

builder:addStruct(struct("statistics_t", "struct of statistics by sallo", {
    field("today_exp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp get today"),
    field("today_cap", fieldType(efieldType.num), fieldInit(efieldType.nil_), "cap get today"),
    field("today_gold", fieldType(efieldType.num), fieldInit(efieldType.nil_), "goldary get today"),
    field("total_exp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "exp get total"),
    field("total_cap", fieldType(efieldType.num), fieldInit(efieldType.nil_), "cap get total"),
    field("total_gold", fieldType(efieldType.num), fieldInit(efieldType.nil_), "goldary get total"),
}))

builder:addStruct(struct("skillState_t", "struct of skill state in info by sallo", {
    field("total_sp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "total skill point get until now"),
    field("left_sp", fieldType(efieldType.num), fieldInit(efieldType.nil_), "skill point left"),
    field("concentration_level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "concentration skill level"),
    field("efficiency_level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "efficiency skill level"),
    field("proficiency_level", fieldType(efieldType.num), fieldInit(efieldType.nil_), "proficiency skill level"),
}))

builder:addStruct(struct("history_t", "struct of info history by sallo", {
    field("dateTime", fieldType(efieldType.str), fieldInit(efieldType.nil_), "time when this history made"),
    field("data", fieldType(efieldType.str), fieldInit(efieldType.nil_), "content of history by raw string")
}))

-- struct
builder:addStruct(struct("info_t", "all information table of one person", {
    field("name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of sallo info"),
    field("thema", fieldType(efieldType.custom, builder:getStructClassName("thema_t")), fieldInit(efieldType.nil_),
        "thema struct field"),
    field("main", fieldType(efieldType.custom, builder:getStructClassName("main_t")),
        fieldInit(efieldType.table, nil, nil),
        "main field of info"),
    field("stat", fieldType(efieldType.custom, builder:getStructClassName("stat_t")),
        fieldInit(efieldType.table, nil, nil),
        "stat field of info"),
    field("statistics", fieldType(efieldType.custom, builder:getStructClassName("statistics_t")),
        fieldInit(efieldType.table, nil, nil),
        "statistics fiedl of info"),
    field("skillState", fieldType(efieldType.custom, builder:getStructClassName("skillState_t")),
        fieldInit(efieldType.table, nil, nil),
        "skill state of info"),
    field("histories", fieldType(efieldType.table, "number", builder:getStructClassName("history_t")),
        fieldInit(efieldType.table, nil, nil),
        "history field of info. go"),
    field("reserved_skillpt_reset", fieldType(efieldType.custom, builder:getStructClassName("skillState_t")),
        fieldInit(efieldType.nil_), "reserved skillpoint reset setting from owner"),
}))

--- header
builder:addHeader(struct("GET_INFO", "give back info_t of sallo", {
    field("name", fieldType(efieldType.str), fieldInit(efieldType.nil_), "name of sallo info to request")
}))

builder:addHeader(struct("ACK_GET_INFO", "reply msg of GET_INFO", {
    field("state", fieldType(efieldType.custom, builder:getEnumClassName("ACK_GET_INFO_R")),
        fieldInit(efieldType.num, -1),
        "state enum of reply"),
    field("success", fieldType(efieldType.bool), fieldType(efieldType.nil_), "success or not "),
    field("state_t", fieldType(efieldType.custom, builder:getStructClassName("info_t")),
        fieldInit(efieldType.table, nil, nil), "serialized info str"),
}))

builder:addHeader(struct("RESERVE_SKILLPT_RESET", "send reserve skillpoint reset to server", {
    field("ownerName", fieldType(efieldType.str), fieldInit(efieldType.nil_), "owner name of info"),
    field("skillState", fieldType(efieldType.custom, builder:getStructClassName("skillState_t")),
        fieldInit(efieldType.nil_), "skill state to reserve reset")
}))

builder:addHeader(struct("ACK_RESERVE_SKILLPT_RESET", "reply msg of RESETVE_SKILLPT_RESET", {
    field("state", fieldType(efieldType.custom, builder:getEnumClassName("ACK_RESERVE_SKILLPT_RESET_R")),
        fieldInit(efieldType.num, -1), "return state"),
    field("success", fieldType(efieldType.bool), fieldInit(efieldType.nil_), "success or not"),
}))


builder:generate(THIS.ENV.PATH .. "/include/Web/Protocol")
builder:generateHandler(THIS.ENV.PATH .. "/include/Web", "require(\"Class.middleclass\")")
