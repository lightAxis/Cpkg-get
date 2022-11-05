---@class CPKG.Package_t
---@field RootPath string
---@field DescPath string
---@field IncludePath string
---@field PkgName string
---@field SrcPath string
---@field Execs table<number, string>

---@class CPKG.PackageInfo_t
---@field Name string
---@field Desc string
---@field Author string
---@field ID string
---@field Email string
---@field Version number
---@field Repo string
---@field Deps table<number, CPKG.Deps_t>

---@class CPKG.Deps_t
---@field pkg string
---@field version number



local t = {}

function t:new_pkg_t()
    ---@type CPKG.Package_t
    local a = {}
    a.RootPath = ""
    a.DescPath = ""
    a.IncludePath = ""
    a.PkgName = ""
    a.SrcPath = ""
    ---@type table<number, string>
    a.Execs = {}
    return a
end

function t:new_pkgInfo_t()
    ---@type CPKG.PackageInfo_t
    local a = {}
    a.Name = ""
    a.Desc = ""
    a.Author = ""
    a.ID = ""
    a.Email = ""
    a.Version = 0
    a.Repo = ""
    a.Deps = {}
    return a
end

return t
