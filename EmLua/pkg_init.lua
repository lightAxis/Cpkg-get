---pkg dependancy
local args = { ... }


---@class DEPS
DEPS = DEPS or {}
---@class DEPS.EmLua
DEPS["EmLua"] = {}
DEPS["EmLua"].middleClass = require("middleClass.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.EmLua
local EmLua = {}
PKGS["EmLua"] = EmLua
--- absolute path of this pkg when runtime
EmLua.__PATH = fs.getDir(args[2])

--- get all include file
EmLua.CodeGenerator = require("EmLua.include.CodeGenerator")
EmLua.StringSeg_t = require("EmLua.include.stringSeg_t")
EmLua.ScriptSeg_t = require("EmLua.include.scriptSeg_t")


return EmLua
