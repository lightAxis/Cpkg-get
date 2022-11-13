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

for k, v in pairs(msgStruct.Infos) do
    tool.colorPrint(consts.colors.notice, v.Name .. ": v" .. tostring(v.Version))
end
