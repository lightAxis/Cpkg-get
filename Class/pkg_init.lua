local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Class
DEPS["Class"] = {}

---@class PKG.Class
local Class__ = {}
Class__.middleclass = require("Class.include.middleclass")

---@class PKG.Class.PATH
Class__.PATH = fs.getDir(args[2])

return Class__
