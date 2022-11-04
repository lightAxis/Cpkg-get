---@class Cpkg.Tool
local a = {}
function a.print_color(text, color)
    term.setTextColor(color)
    print(text)
    term.setTextColor(colors.white)
end

function a.getPkgs()
    local f = fs.open(CPKG.RootPath .. "/pkgs.sz", "r")

    ---@type table<number, CPKG.Package_t>
    local Pkgs = textutils.unserialize(f.readAll())
    f.close()
    return Pkgs
end

function a.getPkgInfo(path)
    local f = fs.open(path, "r")
    ---@type CPKG.PackageInfo_t
    local PkgInfo = textutils.unserialize(f.readAll())
    f.close()
    return PkgInfo
end

return a
