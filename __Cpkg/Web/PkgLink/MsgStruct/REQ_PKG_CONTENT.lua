---@class __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT : __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
---@field Name string name of the pkg to request
---@field new fun():__Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT
function struct.new()
    ---@type __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT
    local a = {}

    ---@type string
    a.Name = "" -- name of the pkg to request
    
    return a
end

return struct 
