---@class __Cpkg.Web.PkgLink.Struct.PkgInfo_t
---@field Name string name of the pkg
---@field Desc string 
---@field Author string author of this pkg
---@field ID string ID of Author of this pkg in minecraft server if exists
---@field Email string Email address of pkg Author
---@field Version number current version of this pkg
---@field Repo string Repository address of this pkg if exists
---@field Deps table<number, __Cpkg.Web.PkgLink.Struct.PkgDep_t> Dependancies of this pkg
---@field new fun():__Cpkg.Web.PkgLink.Struct.PkgInfo_t
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.Struct.PkgInfo_t
function struct.new()
    ---@type __Cpkg.Web.PkgLink.Struct.PkgInfo_t
    local a = {}

    ---@type string
    a.Name = "" -- name of the pkg
    
    ---@type string
    a.Desc = "" -- 
    
    ---@type string
    a.Author = "" -- author of this pkg
    
    ---@type string
    a.ID = "" -- ID of Author of this pkg in minecraft server if exists
    
    ---@type string
    a.Email = "" -- Email address of pkg Author
    
    ---@type number
    a.Version = -1 -- current version of this pkg
    
    ---@type string
    a.Repo = "" -- Repository address of this pkg if exists
    
    ---@type table<number, __Cpkg.Web.PkgLink.Struct.PkgDep_t>
    a.Deps = {} -- Dependancies of this pkg
    
    return a
end

return struct 
