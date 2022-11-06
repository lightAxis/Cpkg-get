local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Class
DEPS["middleClass"] = {}

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Class
local middleClass = {}
PKGS["middleClass"] = middleClass
middleClass.middleClass = require("middleClass.include.middleclass")

---@type string
middleClass.__PATH = fs.getDir(args[2])

return middleClass
