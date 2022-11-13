---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.PkgLink
DEPS["VDef"] = {}

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.VDef
local VDef = {}
PKGS["VDef"] = VDef
--- absolute path of this pkg when runtime
---@type string
VDef.__PATH = fs.getDir(args[2])

return VDef
