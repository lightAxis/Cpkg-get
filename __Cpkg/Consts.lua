---@class Cpkg.Consts
local a = {}


---@enum Cpkg.colors
a.colors = {
    ["succ"] = colors.green,
    ["fail"] = colors.red,
    ["notice"] = colors.blue,
    ["state"] = colors.yellow,
    ["msg"] = colors.cyan,
}

---@class Cpkg.WebConst
a.WebConst = {
    ["Protocol"] = "Cpkg-get",
    ["MaxTimeout"] = 10,
}

return a
