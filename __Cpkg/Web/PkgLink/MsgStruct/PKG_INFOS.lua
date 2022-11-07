---@class __Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS : __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
---@field Infos table<number, __Cpkg.Web.PkgLink.Struct.PkgInfo_t> informations of pkgs
---@field Result __Cpkg.Web.PkgLink.Enum.PKG_INFOS_R result
---@field new fun():__Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS
local struct = {}

---constructor
---@return __Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS
function struct.new()
    ---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS
    local a = {}

    ---@type table<number, __Cpkg.Web.PkgLink.Struct.PkgInfo_t>
    a.Infos = {} -- informations of pkgs
    
    ---@type __Cpkg.Web.PkgLink.Enum.PKG_INFOS_R
    a.Result = 0 -- result
    
    return a
end

return struct 
