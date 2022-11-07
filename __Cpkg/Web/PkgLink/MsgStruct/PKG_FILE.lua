---@class __Cpkg.Web.PkgLink.MsgStruct.PKG_FILE : __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
---@field Name string name of this file
---@field AbsPath string absolute path from root
---@field RelPath string relative path inside the pkg
---@field ContentStr string serialized file content string
---@field Result __Cpkg.Web.PkgLink.Enum.PKG_FILE_R result
---@field new fun():__Cpkg.Web.PkgLink.MsgStruct.PKG_FILE
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.MsgStruct.PKG_FILE
function struct.new()
    ---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_FILE
    local a = {}

    ---@type string
    a.Name = "" -- name of this file
    
    ---@type string
    a.AbsPath = "" -- absolute path from root
    
    ---@type string
    a.RelPath = "" -- relative path inside the pkg
    
    ---@type string
    a.ContentStr = "" -- serialized file content string
    
    ---@type __Cpkg.Web.PkgLink.Enum.PKG_FILE_R
    a.Result = 0 -- result
    
    return a
end

return struct 
