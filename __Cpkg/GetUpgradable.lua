local tool = require("__Cpkg.Tool")
local consts = require("__Cpkg.Consts")

local pkgs = tool.getPkgs()
if (pkgs == nil) then error("no pkgs !") end

---@type table<number, CPKG.Package_t>
local pkgs_updatable = {}

for k, v in pairs(pkgs) do
    if v.Upgradable == true then
        tool.colorPrint(consts.colors.notice, "- " .. v.PkgName)
        table.insert(pkgs_updatable, v)
    end
end

return pkgs_updatable
