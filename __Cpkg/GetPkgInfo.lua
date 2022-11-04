local tool = require("__Cpkg.Tool")

local Pkgs = tool.getPkgs()

for k, v in pairs(Pkgs) do
    if v.PkgName == CPKG.Param[1] then
        local PkgInfo = tool.getPkgInfo(v.DescPath)
        -- term.setTextColor(colors.blue)
        -- print("Name", PkgInfo.Name)
        -- print("Desc", PkgInfo.Desc)
        -- print("Author", PkgInfo.Author)
        -- print("ID", PkgInfo.ID)
        -- print("Email", PkgInfo.Email)
        -- print("Version", tostring(PkgInfo.Version))
        -- print("Repo", PkgInfo.Repo)
        -- term.setTextColor(colors.white)

        term.setTextColor(colors.blue)
        tool.print_color("Name", colors.blue)
        tool.print_color(PkgInfo.Name, colors.cyan)
        tool.print_color("Desc", colors.blue)
        tool.print_color(PkgInfo.Desc, colors.cyan)
        tool.print_color("Author", colors.blue)
        tool.print_color(PkgInfo.Author, colors.cyan)
        tool.print_color("ID", colors.blue)
        tool.print_color(PkgInfo.ID, colors.cyan)
        tool.print_color("Email", colors.blue)
        tool.print_color(PkgInfo.Email, colors.cyan)
        tool.print_color("Version", colors.blue)
        tool.print_color(tostring(PkgInfo.Version), colors.cyan)
        tool.print_color("Repo", colors.blue)
        tool.print_color(PkgInfo.Repo, colors.cyan)
        term.setTextColor(colors.white)
        return nil
    end
end

tool.print_color("cannot find pkg : " .. CPKG.Param[1], colors.red)
