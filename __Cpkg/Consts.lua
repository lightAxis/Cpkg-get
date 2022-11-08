---@class Cpkg.Consts
local a = {}


---@enum Cpkg.colors
a.colors = {
    ["succ"] = colors.green,
    ["fail"] = colors.red,
    ["info"] = colors.blue,
    ["msg"] = colors.cyan,
}

---@class Cpkg.WebConst
a.WebConst = {
    ["Protocol"] = "Cpkg-get",
}

return a
