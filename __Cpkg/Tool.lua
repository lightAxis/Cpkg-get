---@class Cpkg.Tool
local a = {}
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

function a.getPkgInfo(path)
    local f = fs.open(path, "r")
    if (f == nil) then error("cannot read pkginfo : " .. path) end
    ---@type CPKG.PackageInfo_t
    local PkgInfo = textutils.unserialize(f.readAll())
    f.close()
    return PkgInfo
end

return a
