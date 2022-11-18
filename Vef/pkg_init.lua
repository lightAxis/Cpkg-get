---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.PkgLink
DEPS["Vef"] = {}

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Vef
local Vef = {}
PKGS["Vef"] = Vef

Vef.ENV = {}
--- absolute path of this pkg when runtime
---@type string
Vef.ENV.PATH = fs.getDir(args[2])

return Vef
