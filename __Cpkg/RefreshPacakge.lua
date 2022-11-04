local package_t = require("__Cpkg.Package_t")
local tool = require("__Cpkg.Tool")

local function isPackage(path)
    if not fs.exists(path .. "/pkg_init.lua") then
        return false
    end
    if not fs.exists(path .. "/pkg_info.sz") then
        return false
    end
    if not fs.exists(path .. "/include") then
        -- return false
        fs.makeDir(path .. "/include")
    end
    if not fs.exists(path .. "/src") then
        -- return false
        fs.makeDir(path .. "/src")
    end
    return true
end

local function readPackage(path)
    local p_t = package_t:new_pkg_t()
    p_t.SrcPath = path .. "/src"
    p_t.RootPath = path
    p_t.IncludePath = path .. "/include"
    p_t.DescPath = path .. "/pkg_info.sz"
    p_t.PkgName = fs.getName(path)
    local execs = {}
    for i, v in ipairs(fs.list(p_t.SrcPath)) do
        if (v:find("%.lua")) then
            local vv = v:gsub(".lua", "")
            table.insert(execs, vv)
        end
    end
    p_t.Execs = execs
    return p_t
end

---@type table<number, CPKG.Package_t>
local Pkgs = {}

tool.print_color("searching...", colors.blue)

local function recursivePackageFind(path)
    if isPackage(path) then
        local pkg = readPackage(path)
        table.insert(Pkgs, pkg)
        tool.print_color("find " .. pkg.PkgName .. " at " .. path, colors.blue)
        return nil
    end

    ---@type table<number, string>
    local files = fs.list(path)
    for k, v in pairs(files) do
        if fs.isDir(path .. "/" .. v) then
            if (not v:find("%.")) and (not v:find("%.lua")) then
                recursivePackageFind(path .. "/" .. v)
            end
        end
    end
end

recursivePackageFind(CPKG.RootPath)

local f = fs.open(CPKG.RootPath .. "/pkgs.sz", "w")
f.write(textutils.serialize(Pkgs))
f.close()

return true
