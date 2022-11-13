local class = require("Class.middleclass")

---public class Vector2
---
---**require** :
--- - Class.middleclass
---@class MathLib.Vector2
local Vector2 = class("Vector2")

-- constructor
---@param x number
---@param y number
function Vector2:initialize(x, y)
    self.x = x
    self.y = y
end

-- properties description
---@class MathLib.Vector2
---@field x number|nil
---@field y number|nil
---@field new fun(self:MathLib.Vector2, x:number, y:number): MathLib.Vector2
---@operator add(MathLib.Vector2):MathLib.Vector2
---@operator sub(MathLib.Vector2):MathLib.Vector2
---@operator mul(MathLib.Vector2):MathLib.Vector2
---@operator div(MathLib.Vector2):MathLib.Vector2

-- functions

-- get L2 norm of this vector
---@return number norm
function Vector2:norm() return math.sqrt(self.x * self.x + self.y + self.y) end

-- operator + overloading
-- add each element value
---@param lhs MathLib.Vector2
---@param rhs MathLib.Vector2
---@return MathLib.Vector2 vec
function Vector2.__add(lhs, rhs) return Vector2:new(lhs.x + rhs.x, lhs.y + rhs.y) end

-- operator - overloading
---sub each element value
---@param lhs MathLib.Vector2
---@param rhs MathLib.Vector2
---@return MathLib.Vector2 vec
function Vector2.__sub(lhs, rhs) return Vector2:new(lhs.x - rhs.x, lhs.y - rhs.y) end

---operator - overloading
---mul each element value
---@param lhs MathLib.Vector2
---@param rhs MathLib.Vector2
---@return MathLib.Vector2
function Vector2.__mul(lhs, rhs) return Vector2:new(lhs.x * rhs.x, lhs.y * rhs.y) end

---operator - overloading
---div each element value
---@param lhs MathLib.Vector2
---@param rhs MathLib.Vector2
function Vector2.__div(lhs, rhs) return Vector2:new(lhs.x / rhs.x, lhs.y / rhs.y) end

-- operator .toString() overloading
---print each element to term
function Vector2:toString() return "(" .. self.x .. "," .. self.y .. ")" end

-- operator dot product
---@param vec2 MathLib.Vector2 Vector2 to dot
---@return number result
function Vector2:dot(vec2) return self.x * vec2.x + self.y * vec2.y end

-- deep copy
---@return MathLib.Vector2 vec
function Vector2:Copy() return Vector2:new(self.x, self.y) end

return Vector2
