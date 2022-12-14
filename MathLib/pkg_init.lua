---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.MathLib
DEPS["MathLib"] = {}

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.MathLib
local MathLib = {}
PKGS["MathLib"] = MathLib

MathLib.ENV = {}
--- absolute path of this pkg when runtime
---@type string
MathLib.ENV.PATH = fs.getDir(args[2])

MathLib.Vector2 = require("MathLib.include.Vector2")
MathLib.Vector3 = require("MathLib.include.Vector3")

return MathLib
