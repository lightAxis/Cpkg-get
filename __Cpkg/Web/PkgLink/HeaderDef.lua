---@enum __Cpkg.Web.PkgLink.Header
local a = {
    ["NONE"] = -1,
    ["PKG_CONTENT"] = 0, -- content file of pkg
    ["PKG_INFOS"] = 1, -- infos of all pkgs in server
    ["PKG_FILE"] = 2, -- infos of file in pkg
    ["REQ_PKG_CONTENT"] = 3, -- request server pkg content
    ["REQ_PKG_FILE"] = 4, -- request file in pkg
    ["REQ_PKG_INFOS"] = 5, -- request pkg info
}

---@class __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct

return a
