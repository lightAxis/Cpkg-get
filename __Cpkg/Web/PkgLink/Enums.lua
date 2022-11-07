---@class __Cpkg.Web.PkgLink.Enum
local a = {}

---result enum of pkg file request
---@enum __Cpkg.Web.PkgLink.Enum.PKG_FILE_R 
a.PKG_FILE_R = {
    ["SERIALIZATION_FAILED"] = -2, -- failed serialization at server
    ["NO_FILE"] = -1, -- no file exist at server
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 1, -- success
}

---result enum of pkg infos request
---@enum __Cpkg.Web.PkgLink.Enum.PKG_INFOS_R 
a.PKG_INFOS_R = {
    ["NO_PKGS_AT_SERVER"] = -1, -- no pkgs left in server
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 1, -- success
}

---result enum of pkg content request
---@enum __Cpkg.Web.PkgLink.Enum.PKG_CONTENT_R 
a.PKG_CONTENT_R = {
    ["NO_PKG_AT_SERVER"] = -1, -- no pkg at server in name
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 1, -- success
}


return a
