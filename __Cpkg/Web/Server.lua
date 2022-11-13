---@class Cpkg.Web.Server
local server = {}

local protocol = require("__Cpkg.Web.PkgLink.Include")

local const = require("__Cpkg.Consts")
local tool = require("__Cpkg.Tool")

server.__Handle = require("__Cpkg.Web.Handle"):new()

function server.main()

    rednet.host(const.WebConst.Protocol, "server")
    print("start hosting in protocol:" .. const.WebConst.Protocol .. " name server")

    server.__Handle:attachMsgHandle(protocol.Header.REQ_PKG_CONTENT,
        server.__handle_REQ_PKG_CONTENT)
    server.__Handle:attachMsgHandle(protocol.Header.REQ_PKG_FILE,
        server.__handle_REQ_PKG_FILE)
    server.__Handle:attachMsgHandle(protocol.Header.REQ_PKG_INFOS,
        server.__handle_REQ_PKG_INFOS)

    while true do
        --- eventname, sender, msg, protocol
        local a, b, c, d = os.pullEvent("rednet_message")

        print("msg come from : " .. tostring(b) .. "/ protocol:" .. d)
        if (d == const.WebConst.Protocol) then
            server.__Handle:parse(c)
        end
    end

end

---handler for req pkg content msg
---@param msg __Cpkg.Web.PkgLink.Msg
---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_CONTENT
function server.__handle_REQ_PKG_CONTENT(msg, msgstruct)
    print("start handle REQ_PKG_CONTENT : " .. msgstruct.Name)
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
    print("reply back result : " .. replymsgstruct.Result)
    print("reply total " .. tostring(#replymsgstruct.Folders) .. " dirs, "
        .. tostring(#replymsgstruct.FilePaths) .. " files")
    print("---")
    --- send back
    rednet.send(replymsg.TargetID, textutils.serialize(replymsg), const.WebConst.Protocol)
end

function server.__recursive_content_search(currPath, filePathsMap, folderPathsMap)
    if fs.isDir(currPath) then
        folderPathsMap[currPath] = 1
        local files = fs.list(currPath)
        for k, v in pairs(files) do
            server.__recursive_content_search(fs.combine(currPath, v), filePathsMap, folderPathsMap)
        end
    else
        filePathsMap[currPath] = 1
    end
end

---handler for req pkg infos
---@param msg __Cpkg.Web.PkgLink.Msg
---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_INFOS
function server.__handle_REQ_PKG_INFOS(msg, msgstruct)
    print("start handle REQ_PKG_INFOS")
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
    print("reply result :" .. replymsgstruct.Result)
    print("reply " .. tostring(#replymsgstruct.Infos) .. " pkgs")
    print("---")
    --- send rednet
    rednet.send(replymsg.TargetID, textutils.serialize(replymsg), const.WebConst.Protocol)
end

---handler for req pkg file
---@param msg __Cpkg.Web.PkgLink.Msg
---@param msgstruct __Cpkg.Web.PkgLink.MsgStruct.REQ_PKG_FILE
function server.__handle_REQ_PKG_FILE(msg, msgstruct)
    print("start handle REQ_PKG_FILE : " .. msgstruct.reqFilePath)
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
    print("reply result : " .. replymsgstruct.Result)
    print("reply " .. tostring(#replymsgstruct.ContentStr) .. " chars")
    print("---")
    -- send rednet msg
    rednet.send(msg.SendID, textutils.serialize(replymsg), const.WebConst.Protocol)
end

return server
