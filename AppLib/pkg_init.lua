---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.PkgLink
DEPS["AppLib"] = {}

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.AppLib
local AppLib = {}
PKGS["AppLib"] = AppLib
--- absolute path of this pkg when runtime
---@type string
AppLib.__PATH = fs.getDir(args[2])

AppLib.EventEnum = require("AppLib.include.EventEnum")
AppLib.EventRounter = require("AppLib.include.EventRounter")

return AppLib
