term.setTextColor(colors.yellow)
print("serching.. " .. CPKG.RootPath)
term.setTextColor(colors.white)

local exist = fs.exists(CPKG.RootPath)
if (exist == false) then return function() return false, nil end end

---@type table<number, string>
local files = fs.list(CPKG.RootPath)

local Pkgs = {}
for i, v in ipairs(files) do
    if fs.isDir(fs.combine(CPKG.RootPath, v)) == true then
        if (v ~= "__Cpkg") then

            if (not v:find('%.')) then
                table.insert(Pkgs, v)
            end
        end
    end
end

return function() return true, Pkgs end
