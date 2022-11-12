local tool = require("__Cpkg.Tool")
local consts = require("__Cpkg.Consts")
local pkgName = CPKG.Param[1]

local pkgs = tool.getPkgs()
if (pkgs == nil) then error("error while read pkgs info") end

for k, v in pairs(pkgs) do
    if (v.PkgName == pkgName) then
        tool.colorPrint(consts.colors.state, "delete pkg ..",
            consts.colors.notice, v.PkgName)
        os.sleep(1)
        fs.delete(v.RootPath)
    end
end
tool.colorPrint(consts.colors.succ, "deleted!")
