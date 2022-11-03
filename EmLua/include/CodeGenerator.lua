
---@class EmLua.CodeGenerator
local CodeGenerator = DEPS["EmLua"].Class("EmLua.CodeGenerator")

function CodeGenerator:initialize(a,b)
    self.a = 0
    self.b = "d"
end

---@class EmLua.CodeGenerator
---@field a number
---@field b string
---@field new fun(self:EmLua.CodeGenerator, a:number, b:number):EmLua.CodeGenerator

return CodeGenerator