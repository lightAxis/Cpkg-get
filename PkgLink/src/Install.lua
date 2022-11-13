require("PkgLink.pkg_init")

local thisPkg = PKGS.PkgLink

local Crotocol = DEPS.PkgLink.Crotocol

local builder = Crotocol.Builder:new("__Cpkg.Web.PkgLink", "__Cpkg.Web.PkgLink")
local enum = Crotocol.enum_t.new
local enumElm = Crotocol.enumElm_t.new
local struct = Crotocol.struct_t.new
local field = Crotocol.field_t.new
local efieldType = Crotocol.GenTool.Type
local fieldType = Crotocol.GenTool.makeTypeStr
local fieldInit = Crotocol.GenTool.makeInitStr


--- add enums
builder:addEnum(enum("PKG_FILE_R", "result enum of pkg file request", {
    enumElm("SERIALIZATION_FAILED", -2, "failed serialization at server"),
    enumElm("NO_FILE", -1, "no file exist at server"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 1, "success")
}))

builder:addEnum(enum("PKG_INFOS_R", "result enum of pkg infos request", {
    enumElm("NO_PKGS_AT_SERVER", -1, "no pkgs left in server"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 1, "success")
}))

builder:addEnum(enum("PKG_CONTENT_R", "result enum of pkg content request", {
    enumElm("NO_PKG_AT_SERVER", -1, "no pkg at server in name"),
    enumElm("NORMAL", 0, "standard for success"),
    enumElm("SUCCESS", 1, "success"),
}))


--- add struct
builder:addStruct(struct("PkgDep_t", "dependancy info of pkg", {
    field("pkg", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "name of dependancy pkg"),
    field("version", fieldType(efieldType.num), fieldInit(efieldType.num, -1),
        "version of dependancy pkg")
}))

builder:addStruct(struct("PkgInfo_t", "informations of pkg", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "name of the pkg"),
    field("Desc", fieldType(efieldType.str), fieldInit(efieldType.str, "",
        "description of pkg")),
    field("Author", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "author of this pkg"),
    field("ID", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "ID of Author of this pkg in minecraft server if exists"),
    field("Email", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "Email address of pkg Author"),
    field("Version", fieldType(efieldType.num), fieldInit(efieldType.num, -1),
        "current version of this pkg"),
    field("Repo", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "Repository address of this pkg if exists"),
    field("Deps", fieldType(efieldType.table, "number", builder:getStructClassName("PkgDep_t")),
        fieldInit(efieldType.table, nil, nil),
        "Dependancies of this pkg"),
}))

-- builder:addStruct(struct("PkgInfo_VerOnly_t", "only version & deps version informations of pkg", {
--     field("Name", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
--         "name of the pkg"),
--     field("Deps", fieldType(efieldType.table, "number", builder:getStructClassName("PkgDep_t")),
--         fieldInit(efieldType.table, nil, nil), "Dependancies of this pkg")
-- }))


--- add headers
builder:addHeader(struct("PKG_CONTENT", "content file of pkg", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "name of this pkg"),
    field("Folders", fieldType(efieldType.table, "number", "string"), fieldInit(efieldType.table, nil, nil),
        "all folders of this pkg"),
    field("FilePaths", fieldType(efieldType.table, "number", "string"), fieldInit(efieldType.table, nil, nil),
        "all file fullpath of this pkg"),
    field("Result", fieldType(efieldType.custom, builder:getEnumClassName("PKG_CONTENT_R")), fieldInit(efieldType.num, 0)
        , "result")
}))

builder:addHeader(struct("PKG_INFOS", "infos of all pkgs in server", {
    field("Infos", fieldType(efieldType.table, "number", builder:getStructClassName("PkgInfo_t")),
        fieldInit(efieldType.table, nil, nil),
        "informations of pkgs"),
    field("Result", fieldType(efieldType.custom, builder:getEnumClassName("PKG_INFOS_R")), fieldInit(efieldType.num, 0),
        "result")

}))

builder:addHeader(struct("PKG_FILE", "infos of file in pkg", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "name of this file"),
    field("AbsPath", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "absolute path from root"),
    field("RelPath", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "relative path inside the pkg"),
    field("ContentStr", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "serialized file content string"),
    field("Result", fieldType(efieldType.custom, builder:getEnumClassName("PKG_FILE_R")), fieldInit(efieldType.num, 0),
        "result")
}))

builder:addHeader(struct("REQ_PKG_CONTENT", "request server pkg content", {
    field("Name", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "name of the pkg to request"),

}))

builder:addHeader(struct("REQ_PKG_INFOS", "request pkg info", {}))

builder:addHeader(struct("REQ_PKG_FILE", "request file in pkg", {
    field("reqFilePath", fieldType(efieldType.str), fieldInit(efieldType.str, ""),
        "file path to request. must send abs path of pkg")
}))

builder:generate(PKGS.PkgLink.__PATH .. "/../__Cpkg/Web/PkgLink")
builder:generateHandler(PKGS.PkgLink.__PATH .. "/../__Cpkg/Web", "require(\"class.middleclass\")")
