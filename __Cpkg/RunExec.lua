local tool = require("__Cpkg.Tool")

local Pkgs = tool.getPkgs()

for k, v in pairs(Pkgs) do
    if v.PkgName == CPKG.Param[1] then
        for kk, vv in pairs(v.Execs) do
            if vv == CPKG.Param[2] then
                local runPath = v.SrcPath .. "/" .. vv
                -- runPath = runPath:gsub("%/", ".")
                -- runPath = runPath:gsub("Cpkg%-get%.", '')
                runPath = runPath .. ".lua"

                -- require(runPath)
                local f, error = loadfile(runPath, "t", _ENV)
                if f == nil then
                    tool.print_color(error, colors.red)
                    tool.print_color("try 'cpkg refresh' ?", colors.blue)
                else
                    f()
                end
            end
        end
    end
end
