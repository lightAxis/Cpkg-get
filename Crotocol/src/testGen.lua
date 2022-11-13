require("Crotocol.pkg_init")

local thisPkg = PKGS.Crotocol

local builder = thisPkg.Builder:new("Crotocol.testProto", "Crotocol.test.testCroto")
local enum = thisPkg.enum_t.new
local enumElm = thisPkg.enumElm_t.new
local struct = thisPkg.struct_t.new
local field = thisPkg.field_t.new
local efieldType = thisPkg.GenTool.Type
local fieldType = thisPkg.GenTool.makeTypeStr
local fieldInit = thisPkg.GenTool.makeInitStr

--- add enums
builder:addEnum(enum("SNACK", "snack enum!",
    {
        enumElm("NONE", -1, "init"),
        enumElm("icecream", 0, "snack1!"),
        enumElm("sunchip", 1, "snack2!"),
        enumElm("pokachip", 2, "snack3!"),
        enumElm("otherchip", 3, "is this snack?"),
    }))

builder:addEnum(enum("BEVERAGE", "drink ! DF",
    {
        enumElm("coffee", -2, "sucks"),
        enumElm("NONE", -1, "init"),
        enumElm("pocari", 1, "delicious"),
        enumElm("orangeJuice", 2, "jeju island!"),
    }))

--- add structs
builder:addStruct(struct("DRINK", "drinkin history",
    {
        field("Drinker",
            fieldType(efieldType.str),
            fieldInit(efieldType.str, ""),
            "person who drink the beverage"),
        field("Bevarage",
            fieldType(efieldType.custom, builder:getEnumClassName("BEVERAGE")),
            fieldInit(efieldType.custom, "-1"),
            "drinked bevarage"),
    }))

builder:addStruct(struct("EAT", "eating history",
    {
        field("Eater",
            fieldType(efieldType.str),
            fieldInit(efieldType.str, ""),
            "person who eat food"),
        field("Snack",
            fieldType(efieldType.custom, builder:getEnumClassName("SNACK")),
            fieldInit(efieldType.custom, "-1"),
            "eated food"),
        field("Count",
            fieldType(efieldType.num),
            fieldInit(efieldType.num, 0),
            "eat time"),
    }))

--- add msg
builder:addHeader(struct("GETHISTORY", "get history of eat",
    {
        field("Count",
            fieldType(efieldType.num),
            fieldInit(efieldType.num, 0),
            "count of history"),
        field("Owner",
            fieldType("str"),
            fieldInit(efieldType.str, ""),
            "owner of this history"),
        field("Drinks",
            fieldType(efieldType.table, "number", builder:getStructClassName("DRINK")),
            fieldInit(efieldType.table, nil),
            "history of drinks!"),
        field("Eats",
            fieldType(efieldType.table, "number", builder:getStructClassName("EAT")),
            fieldInit(efieldType.table, nil),
            "history of eats!"),
    }))


builder:generate(thisPkg.__PATH .. "/test/testCroto")
builder:generateHandler(thisPkg.__PATH .. "/test/testCroto", "require(\"class.middleclass\")")
builder:saveTo(thisPkg.__PATH .. "/test/savefile.sz")
-- builder:loadFrom(thisPkg.__PATH .. "/test/savefile.sz")
