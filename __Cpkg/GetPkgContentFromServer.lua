local pkgName = CPKG.Param[1]

local tool = require("__Cpkg.Tool")
local client = require("__Cpkg.Web.Client")
local protocol = require("__Cpkg.Web.PkgLink.Include")
local consts = require("__Cpkg.Consts")

---@type __Cpkg.Web.PkgLink.Msg
local recMsg = nil
---@type __Cpkg.Web.PkgLink.MsgStruct.IMsgStruct
local msgStruct = nil
recMsg = client.Req_with_timeout(protocol.Header.PKG_CONTENT, 3,
    function()
        tool.colorPrint(consts.colors.state, "requesting pkg content to server ...")
        client.Req_pkgContent(pkgName)
    end
)
if (recMsg == nil) then error("timeout!") end
---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_CONTENT
msgStruct = textutils.unserialize(recMsg.MsgStructStr)
if msgStruct.Result < protocol.Enum.PKG_CONTENT_R.NORMAL then
    print("error when get message back")
    error("no pkg names " .. pkgName .. " at server")
end

local folderList = msgStruct.Folders
local fileList = msgStruct.FilePaths
for k, v in pairs(fileList) do

    os.sleep(0.5)
    recMsg = client.Req_with_timeout(protocol.Header.PKG_FILE, 3,
        function()
            tool.colorPrint(consts.colors.state, "requesting file ",
                consts.colors.msg, v)
            client.Req_pkgFile(v)
        end)
    if recMsg == nil then error("timeout!") end
    ---@type __Cpkg.Web.PkgLink.MsgStruct.PKG_FILE
    msgStruct = textutils.unserialize(recMsg.MsgStructStr)
    if (msgStruct.Result < protocol.Enum.PKG_FILE_R.NORMAL) then
        tool.colorPrint(colors.red, "error when get file content")
        error("no file " .. v .. " in server")
    end

    local f = fs.open(v, "w")
    f.write(msgStruct.ContentStr)
    f.close()

end
