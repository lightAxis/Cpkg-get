local tool = require("__Cpkg.Tool")

local Pkgs = tool.getPkgs()

for k, v in pairs(Pkgs) do
    if v.PkgName == CPKG.Param[1] then
        local isFindPkg = false
        for kk, vv in pairs(v.Execs) do
            tool.print_color(vv, colors.blue)
            isFindPkg = true
        end
        if not isFindPkg then
            tool.print_color("there is no exec in " .. v.PkgName, colors.blue)
            tool.print_color("try 'cpkg refresh' ?", colors.blue)
        end
        return nil
    end
end
tool.print_color("there is no pkg named " .. CPKG.Param[1] .. " !", colors.red)
tool.print_color("try 'cpkg refresh' ?", colors.blue)
return nil
