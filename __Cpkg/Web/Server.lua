---@class Cpkg.Web.Server
local server = {}

local protocol = require("__Cpkg.Web.PkgLink.Include")

local const = require("__Cpkg.Consts")
local tool = require("__Cpkg.Tool")

server.__Handle = require("__Cpkg.Web.Handle"):new()

function server.main()

end

---handler for req pkg content msg
---@param msg __Cpkg.Web.PkgLink.Msg
---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT
function server.__handle_REQ_PKG_CONTENT(msg, msgstruct)

    -- get target pkg name
    local targetPkgName = msgstruct.Name

    ---@type table<number, CPKG.Package_t>
    local pkgs = tool.getPkgs()

    -- if pkg found, parse recursive all folder and file
    local foundPkg = false
    ---@type table<string, number>
    local filePathsMap = {}
    ---@type table<number, string>
    local filePaths = {}
    ---@type table<string, number>
    local folderPathsMap = {}
    ---@type table<number, string>
    local folderPaths = {}
    for k, pkg in pairs(pkgs) do
        if (pkg.PkgName == targetPkgName) then
            server.__recursive_content_search(pkg.RootPath, filePathsMap, folderPathsMap)
            foundPkg = true
        end
    end

    --- make msg struct
    local replymsgstruct = protocol.MsgStruct.PKG_CONTENT.new()
    if (foundPkg) then
        replymsgstruct.Name = targetPkgName
        for k, v in pairs(filePathsMap) do
            table.insert(filePaths, k)
        end
        for k, v in pairs(folderPathsMap) do
            table.insert(folderPaths, k)
        end
        replymsgstruct.FilePaths = filePaths
        replymsgstruct.Folders = folderPaths
        replymsgstruct.Result = protocol.Enum.PKG_CONTENT_R.SUCCESS
    else
        replymsgstruct.Name = targetPkgName
        replymsgstruct.Result = protocol.Enum.PKG_CONTENT_R.NO_PKG_AT_SERVER
    end

    --- make reply msg
    local replymsg = protocol.Msg.new()
    replymsg.Header = protocol.Header.PKG_CONTENT
    replymsg.SendID = os.getComputerID()
    replymsg.TargetID = msg.SendID
    replymsg.MsgStructStr = textutils.serialize(replymsgstruct)

    --- send back
    rednet.send(replymsg.TargetID, textutils.serialize(replymsg), const.WebConst.Protocol)
end

function server.__recursive_content_search(currPath, filePathsMap, folderPathsMap)
    if fs.isDir(currPath) then
        folderPathsMap[currPath] = 1
        local files = fs.list(currPath)
        for k, v in pairs(files) do
            server.__recursive_content_search(v, filePathsMap, folderPathsMap)
        end
    else
        filePathsMap[currPath] = 1
    end
end

---handler for req pkg infos
---@param msg __Cpkg.Web.PkgLink.Msg
---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_INFOS
function server.__handle_REQ_PKG_INFOS(msg, msgstruct)

    ---@type table<number, CPKG.Package_t>
    local pkgs = tool.getPkgs()

    --- parse infos
    local replymsgstruct = protocol.MsgStruct.PKG_INFOS.new()
    for k, v in pairs(pkgs) do
        local pkgInfo = tool.getPkgInfo(v.DescPath)
        table.insert(replymsgstruct.Infos, pkgInfo)
    end

    if #replymsgstruct.Infos <= 0 then
        replymsgstruct.Result = protocol.Enum.PKG_INFOS_R.NO_PKGS_AT_SERVER
    else
        replymsgstruct.Result = protocol.Enum.PKG_INFOS_R.SUCCESS
    end

    --- make replymsg
    local replymsg = protocol.Msg.new()
    replymsg.Header = protocol.Header.PKG_INFOS
    replymsg.SendID = os.getComputerID()
    replymsg.TargetID = msg.SendID
    replymsg.MsgStructStr = textutils.serialize(replymsgstruct)

    --- send rednet
    rednet.send(replymsg.TargetID, textutils.serialize(replymsg), const.WebConst.Protocol)
end

---handler for req pkg file
---@param msg __Cpkg.Web.PkgLink.Msg
---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE
function server.__handle_REQ_PKG_FILE(msg, msgstruct)

    -- try open file
    local f = fs.open(msgstruct.reqFilePath, "r")

    -- parse file content
    local replymsgstruct = protocol.MsgStruct.PKG_FILE.new()
    if (f == nil) then
        replymsgstruct.Result = protocol.Enum.PKG_FILE_R.NO_FILE
    else
        replymsgstruct.Name = fs.getName(msgstruct.reqFilePath)
        replymsgstruct.AbsPath = msgstruct.reqFilePath
        replymsgstruct.ContentStr = f.readAll()
        replymsgstruct.Result = protocol.Enum.PKG_FILE_R.SUCCESS
    end

    -- prepare reply msg
    local replymsg = protocol.Msg.new()
    replymsg.Header = protocol.Header.PKG_FILE
    replymsg.SendID = os.getComputerID()
    replymsg.TargetID = msg.SendID
    replymsg.MsgStructStr = textutils.serialize(replymsgstruct)

    -- send rednet msg
    rednet.send(msg.SendID, textutils.serialize(replymsg), const.WebConst.Protocol)
end

return server
