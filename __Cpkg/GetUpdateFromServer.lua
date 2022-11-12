local pkgName = CPKG.Param[1]

local client = require("__Cpkg.Web.Client")
local tool = require("__Cpkg.Tool")
local consts = require("__Cpkg.Consts")
local protocol = require("__Cpkg.Web.PkgLink.Include")

---@type __Cpkg.Web.PkgLink.Msg
local recMsg = nil
---@type __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
local msgStruct = nil
recMsg = client.Req_with_timeout(protocol.Header.PKG_INFOS, 3,
    function()
        tool.colorPrint(consts.colors.state, "requesting pkginfos to server ...")
        client.Req_pkgInfos()
    end
)
if (recMsg == nil) then error("timeout!") end
---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_INFOS
msgStruct = textutils.unserialize(recMsg.MsgStructStr)
if msgStruct.Result < protocol.Enum.PKG_INFOS_R.NORMAL then
    tool.colorPrint(consts.colors.fail, "error when get message back")
    error("no pkgs at server")
end

os.sleep(1)
local pkgs_server = msgStruct.Infos
local pkgs_local = tool.getPkgs()

---@type table<number, CPKG.PackageInfo_t>
local pkgInfos_updatable = {}

for k, pkg_local in pairs(pkgs_local) do
    tool.colorPrint(consts.colors.notice, "check pkg : ",
        consts.colors.msg, pkg_local.PkgName)
    os.sleep(0.2)
    for kk, pkginfo_server in pairs(pkgs_server) do
        if (pkg_local.PkgName == pkginfo_server.Name) then
            local pkgInfo_local = tool.getPkgInfo(pkg_local.DescPath)
            if (pkgInfo_local.Version < pkginfo_server.Version) then
                table.insert(pkgInfos_updatable, pkgInfo_local)
                pkg_local.Upgradable = true
                pkgInfo_local.Upgradable = true
                tool.savePkgInfo(pkg_local.DescPath, pkgInfo_local)
            end
        end
    end
end
tool.savePkgs(pkgs_local)


if #pkgInfos_updatable > 0 then
    tool.colorPrint(consts.colors.succ, "find new version!")
end
for k, pkgInfo in pairs(pkgInfos_updatable) do
    tool.colorPrint(consts.colors.notice, "- " .. pkgInfo.Name)
end
