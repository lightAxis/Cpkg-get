---@class __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE : __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
---@field reqFilePath string file path to request. must send abs path of pkg
---@field new fun():__Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE
function struct.new()
    ---@type __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE
    local a = {}

    ---@type string
    a.reqFilePath = "" -- file path to request. must send abs path of pkg
    
    return a
end

return struct 
