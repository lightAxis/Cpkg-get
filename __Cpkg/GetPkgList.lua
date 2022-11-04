local tool = require("__Cpkg.Tool")

local Pkgs = tool.getPkgs()

for k, v in pairs(Pkgs) do
    tool.print_color(v.PkgName, colors.blue)
end
