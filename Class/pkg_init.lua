local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Class
DEPS["Class"] = {}

---@class PKG.Class
local Class__ = {}
Class__.middleclass = require("Class.include.middleclass")

---@class PKG.Class.PATH
Class__.PATH = args[1]

return Class__
