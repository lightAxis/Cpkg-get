local pkgs_updateble = require("__Cpkg.GetUpgradable")

local tool = require("__Cpkg.Tool")

for k, v in pairs(pkgs_updateble) do
    local f = loadfile(CPKG.RootPath .. "/__Cpkg/DoInstallFromServer.lua", "t", _ENV)
    CPKG.Param[1] = v.PkgName
    f()
end
