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
--- absolute path of this pkg when runtime
EmLua.__PATH = args[1]

EmLua.CodeGenerator = require("EmLua.include.CodeGenerator")

PKGS["EmLua"] = EmLua
return EmLua
