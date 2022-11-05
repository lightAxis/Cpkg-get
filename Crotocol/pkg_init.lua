---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.EmLua
DEPS["Crotocol"] = {}
DEPS["Crotocol"].middleClass = require("middleClass.pkg_init")
DEPS["Crotocol"].EmLua = require("EmLua.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Crotocol
local Crotocol = {}
PKGS["Crotocol"] = Crotocol
--- absolute path of this pkg when runtime
Crotocol.__PATH = fs.getDir(args[2])

return Crotocol
