local srcPath = CPKG.RootPath .. "/" .. CPKG.Param[1] .. "/src"

term.setTextColor(colors.yellow)
print("serching.. " .. srcPath)
term.setTextColor(colors.white)

if (fs.exists(srcPath) == false) then return function() return false, nil end end

---@type table<number, string>
local files = fs.list(srcPath)
local execs = {}

for k, v in pairs(files) do
    if (v:find("%.lua")) then
        local name = string.gsub(v, "%.lua", "")
        table.insert(execs, name)
    end
end

return function() return true, execs end
