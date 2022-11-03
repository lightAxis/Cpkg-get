local args = {...}

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Class
DEPS["Class"] = {}

---@class PKG.Class
local Class__ = {}
Class__.middleclass = require("Class.include.middleclass")

---@class PKG.Class.INFO
local info = {}
info.Name = "Class"
info.Desc = "lua native Classing library."
info.Author = "kikito"
info.ID = ""
info.Email = ""
info.Version = 1.0
info.Repo = "https://github.com/kikito/middleclass"
-- info = textutils.serializeJSON("pkg_info.json")
Class__.INFO = info

---@class PKG.Class.PATH
Class__.PATH = args[1]

return Class__