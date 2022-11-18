---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Crotocol
DEPS["Crotocol"] = {}
DEPS["Crotocol"].EmLua = require("EmLua.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Crotocol
local Crotocol = {}
PKGS["Crotocol"] = Crotocol

Crotocol.ENV = {}
--- absolute path of this pkg when runtime
---@type string
Crotocol.ENV.PATH = fs.getDir(args[2])

Crotocol.enum_t = require("Crotocol.include.enum_t")
Crotocol.enumElm_t = require("Crotocol.include.enumElm_t")
Crotocol.field_t = require("Crotocol.include.field_t")
Crotocol.struct_t = require("Crotocol.include.struct_t")
Crotocol.GenTool = require("Crotocol.include.GenTool")
Crotocol.Builder = require("Crotocol.include.Builder")

return Crotocol
