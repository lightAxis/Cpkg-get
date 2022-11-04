---@class EmLua.CodeGenerator
local CodeGenerator = DEPS["EmLua"].Class("EmLua.CodeGenerator")

function CodeGenerator:initialize(global, tempPath, outputPath)
    self.global = global
    self.tempPath = tempPath
    self.outputPath = outputPath
end

---@class EmLua.CodeGenerator
---@field new fun(self:EmLua.CodeGenerator, global:table, tempPath:string, outputPath:string):EmLua.CodeGenerator

function CodeGenerator:makeScript()
    local scriptPath = PKGS.EmLua.__PATH .. "/include/genScript.lua"

    local o = fs.open(scriptPath, "r")
    local i = fs.open(self.tempPath, "")
end

return CodeGenerator
