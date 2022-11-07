---@class __Cpkg.Web.PkgLink.MsgStruct.PKG_CONTENT : __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
---@field Name string name of this pkg
---@field Folders table<number, string> all folders of this pkg
---@field FilePaths table<number, string> all file fullpath of this pkg
---@field Result __Cpkg.Web.PkgLink.Enum.PKG_CONTENT_R result
---@field new fun():__Cpkg.Web.PkgLink.MsgStruct.PKG_CONTENT
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.MsgStruct.PKG_CONTENT
function struct.new()
    ---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_CONTENT
    local a = {}

    ---@type string
    a.Name = "" -- name of this pkg
    
    ---@type table<number, string>
    a.Folders = {} -- all folders of this pkg
    
    ---@type table<number, string>
    a.FilePaths = {} -- all file fullpath of this pkg
    
    ---@type __Cpkg.Web.PkgLink.Enum.PKG_CONTENT_R
    a.Result = 0 -- result
    
    return a
end

return struct 
