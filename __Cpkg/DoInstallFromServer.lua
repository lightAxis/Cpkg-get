local pkgToInstall = CPKG.Param[1]

local client = require("__Cpkg.Web.Client")
local tool = require("__Cpkg.Tool")
local protocol = require("__Cpkg.Web.PkgLink.Include")
local const = require("__Cpkg.Consts")

local msg = client.Req_with_timeout(protocol.Header.PKG_INFOS, 3,
    function()
        client.Req_pkgInfos()
    end)
if (msg == nil) then error("cannot get pkg info from server!") end
---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS
local msgStruct = textutils.unserialize(msg.MsgStructStr)
if msgStruct == nil then error("cannot parse msgStruct") end

---comment
---@param pkgName string
---@param pkgDict table<string, __Cpkg.Web.PkgLink.Struct.PkgInfo_t>
---@param deps table<string, __Cpkg.Web.PkgLink.Struct.PkgDep_t>
local function findDepsRecursive(pkgName, pkgDict, deps)
    for k, v in pairs(pkgDict[pkgName].Deps) do
        if (deps[v.pkg] == nil) then
            deps[v.pkg] = v
        else
            if deps[v.pkg].version < v.version then
                deps[v.pkg] = v
            end
        end
        findDepsRecursive(v.pkg, pkgDict, deps)
    end
end

---@type table<string, __Cpkg.Web.PkgLink.Struct.PkgInfo_t>
local pkgDict = {}
for k, v in pairs(msgStruct.Infos) do
    pkgDict[v.Name] = v
end

if (pkgDict[pkgToInstall] == nil) then
    error("no pkg named " .. pkgToInstall .. " is at server. use 'cpkg list server' to see available pkgs")
end

---@type table<string, __Cpkg.Web.PkgLink.Struct.PkgDep_t>
local deps = {}
---@type __Cpkg.Web.PkgLink.Struct.PkgDep_t
local currentPkgDep = {}
currentPkgDep.pkg = pkgToInstall
currentPkgDep.version = pkgDict[pkgToInstall].Version
table.insert(deps, currentPkgDep)
findDepsRecursive(pkgToInstall, pkgDict, deps)

tool.colorPrint(const.colors.succ, "install pkg : " .. pkgToInstall)

---@type table<string, CPKG.Package_t>
local pkgsDic_local = {}
for k, v in pairs(tool.getPkgs()) do
    pkgsDic_local[v.PkgName] = v
end

for k, v in pairs(deps) do
    if pkgsDic_local[v.pkg] == nil then
        CPKG.Param[1] = v.pkg
        tool.colorPrint(const.colors.notice, "dep no exist : " .. v.pkg)
        local f = loadfile(CPKG.RootPath .. "/__Cpkg/GetPkgContentFromServer.lua", "t", _ENV)
        f()
    else
        local pkgInfo = tool.getPkgInfo(pkgsDic_local[v.pkg].DescPath)
        if pkgInfo.Version < v.version then
            CPKG.Param[1] = v.pkg
            tool.colorPrint(const.colors.notice, "dep version old : " .. v.pkg)
            local f = loadfile(CPKG.RootPath .. "/__Cpkg/GetPkgContentFromServer.lua", "t", _ENV)
            f()
        end
    end
end

tool.colorPrint(const.colors.succ, "Refreshing..")
require("__Cpkg.RefreshPacakge")
tool.colorPrint(const.colors.state, "----")
