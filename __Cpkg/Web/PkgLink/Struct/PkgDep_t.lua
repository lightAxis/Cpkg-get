---@class __Cpkg.Web.PkgLink.Struct.PkgDep_t
---@field pkg string name of dependancy pkg
---@field version number version of dependancy pkg
---@field new fun():__Cpkg.Web.PkgLink.Struct.PkgDep_t
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.Struct.PkgDep_t
function struct.new()
    ---@type __Cpkg.Web.PkgLink.Struct.PkgDep_t
    local a = {}

    ---@type string
    a.pkg = "" -- name of dependancy pkg
    
    ---@type number
    a.version = -1 -- version of dependancy pkg
    
    return a
end

return struct 
