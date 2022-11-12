---@class Cpkg.Tool
local a = {}

local const = require("__Cpkg.Consts")

function a.print_color(text, color)
    term.setTextColor(color)
    print(text)
    term.setTextColor(colors.white)
end

function a.colorPrint(...)
    local curColor
    for i = 1, #arg do -- arg is ...
        if type(arg[i]) == 'number' then
            curColor = arg[i]
        else
            if curColor then
                term.setTextColor(curColor)
            end
            write(arg[i])
        end
    end
    print() -- this is a print function, so it needs a new line.
end

function a.getPkgs()
    if not fs.exists(CPKG.RootPath .. "/pkgs_local.sz", "r") then
        a.print_color("no local cpkg cache file!", colors.red)
        a.print_color("use 'cpkg refresh' to initialze", colors.blue)
    end
    local f = fs.open(CPKG.RootPath .. "/pkgs_local.sz", "r")

    ---@type table<number, CPKG.Package_t>
    local Pkgs = textutils.unserialize(f.readAll())
    f.close()
    return Pkgs
end

---@param pkgs table<number, CPKG.Package_t>
function a.savePkgs(pkgs)
    local f = fs.open(CPKG.RootPath .. "/pkgs_local.sz", "w")
    if f == nil then error("cannot write pkginfo to root") end
    f.write(textutils.serialize(pkgs))
end

---@param path string
---@return CPKG.PackageInfo_t
function a.getPkgInfo(path)
    local f = fs.open(path, "r")
    if (f == nil) then error("cannot read pkginfo : " .. path) end
    ---@type CPKG.PackageInfo_t
    local PkgInfo = textutils.unserialize(f.readAll())
    f.close()
    return PkgInfo
end

---@param path string
---@param info CPKG.PackageInfo_t
function a.savePkgInfo(path, info)
    local f = fs.open(path, "w")
    if (f == nil) then error("cannot write pkginfo : " .. path) end
    ---@type CPKG.PackageInfo_t
    f.write(textutils.serialize(info))
    f.close()
end

---get id of server
---@return number
function a.getServerID()
    if CPKG.ServerID == nil then
        local id = rednet.lookup(const.WebConst.Protocol, "server")
        if id == nil then a.colorPrint(colors.red, "No Cpkg-get server is activated!") end
        CPKG.ServerID = id
        return id
    end
    return CPKG.ServerID

end

return a
