---pkg dependancy
local args = { ... }


---@class DEPS
DEPS = DEPS or {}
---@class DEPS.EmLua
DEPS["EmLua"] = {}
DEPS["EmLua"].Class = require("Class.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.EmLua
local EmLua = {}
PKGS["EmLua"] = EmLua
--- absolute path of this pkg when runtime
EmLua.__PATH = fs.getDir(args[2])
print(EmLua.__PATH, "pkginit", fs.getDir(args[2]))

EmLua.CodeGenerator = require("EmLua.include.CodeGenerator")
EmLua.StringSeg_t = require("EmLua.include.stringSeg_t")
EmLua.ScriptSeg_t = require("EmLua.include.scriptSeg_t")


return EmLua
