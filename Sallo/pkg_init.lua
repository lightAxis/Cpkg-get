---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Sallo
DEPS["Sallo"] = {}
DEPS["Sallo"].Crotocol = require("Crotocol.pkg_init")
DEPS["Sallo"].EmLua = require("EmLua.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Sallo
local Sallo = {}
PKGS["Sallo"] = Sallo

Sallo.ENV = {}
--- absolute path of this pkg when runtime
---@type string
Sallo.ENV.PATH = fs.getDir(args[2])

Sallo.Param = require("Sallo.include.Param.param")

return Sallo
