---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.PkgLink
DEPS["PkgLink"] = {}
DEPS["PkgLink"].Crotocol = require("Crotocol.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.PkgLink
local PkgLink = {}
PKGS["PkgLink"] = PkgLink

PkgLink.ENV = {}
--- absolute path of this pkg when runtime
---@type string
PkgLink.ENV.PATH = fs.getDir(args[2])

return PkgLink
