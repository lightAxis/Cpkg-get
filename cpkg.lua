CPKG = CPKG or {}
-- CPKG.RootPath = "/d/git/Cpkg"
CPKG.RootPath = "Cpkg-get"
CPKG.Param = {}

package.path = package.path .. ";" .. CPKG.RootPath .. "/?.lua"

---@type table<number, string>
local args = { ... }



-- args = {}
-- args[1] = "list"
-- args[2] = "installed"
-- args[3] = "to"
---@enum Cpkg.Enum.Help
local helpEnum_main = {
    ["--help"] = "use with : --help, list, version, info, run, update, upgradable, upgrade, install, uninstall, purge",
    ["list"] = "cpkg list <installed | server | exec> : show list of installed pkg | server pkg | execution at pkg",
    ["version"] = "cpkg version : show version of cpkg",
    ["info"] = "cpkg info <package_name> <exec_name> : show info of package or execuatble",
    ["run"] = "cpkg run <package_name> <exec_name> : run executable in package",
    ["update"] = "cpkg update : check newest pacakge version from cpkg server",
    ["upgradable"] = "cpkg upgradable : show packages that new version found from cpkg update",
    ["upgrade"] = "cpkg upgrade : download  & upgrade the upgradable packages from MCserver's cpkg server ",
    ["install"] = "cpkg install <package_name> : download package from cpkg server. Already newest version, than ignores",
    ["uninstall"] = "cpkg uninstall <package_name> : uninstall package at local repo. Leaving config behind",
    ["purge"] = "cpkg purge <package_name> : ",
}

local helpEnum_list = {
    ["--help"] = "use with : installed, server, exec, --help",
    ["installed"] = "cpkg list installed : show list of installed packages in local repo",
    ["server"] = "cpkg list server : show list of pkgs in MCserver's cpkg server repo",
    ["exec"] = "cpkg list exec <package_name> : show list of executables in local pkg",
}

local function printHelp(argnil, arghelp, name, helpenum)
    if (argnil == nil) then
        term.setTextColor(colors.red)
        print("arg is missing!")
        term.setTextColor(colors.blue)
        print(helpenum[name])
        term.setTextColor(colors.white)
        return true
    elseif (arghelp == "--help") then
        term.setTextColor(colors.blue)
        print(helpenum[name])
        term.setTextColor(colors.white)
        return true
    end

    return false
end

if printHelp(args[1], args[1], "--help", helpEnum_main) == true then return nil
elseif args[1] == "list" then
    if printHelp(args[2], args[2], "list", helpEnum_main) == true then return nil end
    -- check list next args

    if args[2] == "installed" then
        if printHelp(args[2], args[3], "installed", helpEnum_list) == true then return nil end
        -- start list all installed pkgs
        local exists, pkgList = require("__Cpkg.GetPkgList")()
        if (exists == false) then print("no exist folder : " .. CPKG.RootPath) return nil end
        for k, v in pairs(pkgList) do
            print(k, v)
        end

    elseif args[2] == "server" then
        if printHelp(args[2], args[3], "server", helpEnum_list) == true then return nil end
        -- start list all server pkgs

    elseif args[2] == "exec" then
        if printHelp(args[3], args[3], "exec", helpEnum_list) == true then return nil end
        -- start execute pkg
        CPKG.Param = {}
        CPKG.Param[1] = args[3]
        local isExist, execList = require("__Cpkg.GetExecList")()
        if (isExist == false) then print("no module [" .. args[3] .. "] exist src folder") return nil end
        for k, v in pairs(execList) do
            print(k, v)
        end

    else
        term.setTextColor(colors.red)
        print("arg is wrong!")
        term.setTextColor(colors.blue)
        print(helpEnum_main["list"])
        term.setTextColor(colors.white)
    end

elseif args[1] == "version" then
    if printHelp(args[1], args[2], "version", helpEnum_main) == true then return nil end
    -- show version of cpkg

elseif args[1] == "info" then
    if printHelp(args[2], args[2], "info", helpEnum_main) == true then return nil end
    local pkgName = args[2]
    local execname = args[3]

    if (execname == nil) then
        -- show info of pkgName
        CPKG.Param = {}
        CPKG.Param[1] = pkgName
    else
        -- show info of exec
    end


elseif args[1] == "run" then
    if printHelp(args[2], args[2], "run", helpEnum_main) == true then return nil end
    local pkgName = args[2]
    local execName = args[3]
    --- run exec at pkg

elseif args[1] == "update" then
    if printHelp(args[1], args[2], "update", helpEnum_main) == true then return nil end


elseif args[1] == "updatable" then
    if printHelp(args[1], args[2], "updatable", helpEnum_main) == true then return nil end

elseif args[1] == "upgrade" then
    if printHelp(args[1], args[2], "upgradable", helpEnum_main) == true then return nil end

elseif args[1] == "install" then
    if printHelp(args[2], args[2], "install", helpEnum_main) == true then return nil end

elseif args[1] == "uninstall" then
    if printHelp(args[2], args[2], "uninstall", helpEnum_main) == true then return nil end

elseif args[1] == "purge" then
    if printHelp(args[2], args[2], "purge", helpEnum_main) == true then return nil end
end
