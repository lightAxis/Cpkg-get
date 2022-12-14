---pkg dependancy
local args = { ... }


---@class DEPS
DEPS = DEPS or {}
---@class DEPS.EmLua
DEPS["EmLua"] = {}

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.EmLua
local EmLua = {}
PKGS["EmLua"] = EmLua

EmLua.ENV = {}
--- absolute path of this pkg when runtime
---@type string
EmLua.ENV.PATH = fs.getDir(args[2])

--- get all include file
EmLua.CodeGenerator = require("EmLua.include.CodeGenerator")
EmLua.StringSeg_t = require("EmLua.include.stringSeg_t")
EmLua.ScriptSeg_t = require("EmLua.include.scriptSeg_t")


return EmLua
