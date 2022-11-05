local tool = require("__Cpkg.Tool")

local Pkgs = tool.getPkgs()

for k, v in pairs(Pkgs) do
    if v.PkgName == CPKG.Param[1] then
        local PkgInfo = tool.getPkgInfo(v.DescPath)
        tool.colorPrint(colors.blue, "Name ", colors.cyan, PkgInfo.Name)
        tool.colorPrint(colors.blue, "Desc ", colors.cyan, PkgInfo.Desc)
        tool.colorPrint(colors.blue, "Author ", colors.cyan, PkgInfo.Author)
        tool.colorPrint(colors.blue, "ID ", colors.cyan, PkgInfo.ID)
        tool.colorPrint(colors.blue, "Email ", colors.cyan, PkgInfo.Email)
        tool.colorPrint(colors.blue, "Version ", colors.cyan, tostring(PkgInfo.Version))
        tool.colorPrint(colors.blue, "Repo ", colors.cyan, PkgInfo.Repo)
        local depStr = ""
        for kk, vv in pairs(PkgInfo.Deps) do
            depStr = depStr .. vv.pkg .. ">=" .. tostring(vv.version) .. " "
        end
        tool.colorPrint(colors.blue, "Deps ", colors.cyan, depStr)
        term.setTextColor(colors.white)
        return nil
    end
end

tool.print_color("cannot find pkg : " .. CPKG.Param[1], colors.red)
