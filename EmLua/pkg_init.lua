---pkg dependancy

local args = { ... }

DEPS = DEPS or {}
---@class DEPS.EmLua
DEPS["EmLua"] = {}
DEPS["EmLua"].Class = require("Class.pkg_init")

---@class PKG.EmLua
local EmLua = {}
EmLua.CodeGenerator = require("EmLua.include.CodeGenerator")

---@class PKG.EmLua.INFO
EmLua.__INFO = textutils.serializeJSON("pkg_info.json")
for k, v in pairs(EmLua.__INFO) do
    print(k, v)
end

---@class PKG.EmLua.PATH
--- absolute path of this pkg when runtime
EmLua.__PATH = args[1]

return EmLua
