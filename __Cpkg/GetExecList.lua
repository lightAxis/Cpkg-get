local tool = require("__Cpkg.Tool")

local Pkgs = tool.getPkgs()

for k, v in pairs(Pkgs) do
    if v.PkgName == CPKG.Param[1] then
        for kk, vv in pairs(v.Execs) do
            tool.print_color(vv, colors.blue)
        end
    end
end
