local class = require("Class.middleclass")

---public class Vector3
---
---**require** :
--- - Class.middleclass
---@class MathLib.Vector3
local Vector3 = class("Vector3")

-- constructor
---@param x number
---@param y number
---@param z number
function Vector3:initialize(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

---@class MathLib.Vector3
---@field x number|nil
---@field y number|nil
---@field z number|nil
---@field new fun(self:MathLib.Vector3, x:number, y:number, z:number): MathLib.Vector3
---@operator add(MathLib.Vector3):MathLib.Vector3
---@operator sub(MathLib.Vector3):MathLib.Vector3
---@operator mul(MathLib.Vector3):MathLib.Vector3
---@operator div(MathLib.Vector3):MathLib.Vector3

-- functions

-- operator+ overloading
---add by each element
---@param lhs MathLib.Vector3
---@param rhs MathLib.Vector3
---@return MathLib.Vector3
function Vector3.__add(lhs, rhs)
    return Vector3:new(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
end

-- operator- overloading
---sub by each element
---@param lhs MathLib.Vector3
---@param rhs MathLib.Vector3
---@return MathLib.Vector3
function Vector3.__sub(lhs, rhs)
    return Vector3:new(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
end

-- operator* (element mult) overloading
---@param lhs MathLib.Vector3
---@param rhs MathLib.Vector3
---@return MathLib.Vector3
function Vector3.__mul(lhs, rhs)
    return Vector3:new(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
end

-- operator /(element div)
---@param lhs MathLib.Vector3
---@param rhs MathLib.Vector3
---@return MathLib.Vector3
function Vector3.__div(lhs, rhs)
    return Vector3:new(lhs.x / rhs.x, lhs.y / rhs.y, lhs.z / rhs.z)
end

-- operator dot product v1 dot v2
---@param vec3 MathLib.Vector3
---@return number
function Vector3:dot(vec3)
    return self.x * vec3.x + self.y + vec3.y + self.z * vec3.z
end

-- operator cross product
---@param vec3 MathLib.Vector3
---@return MathLib.Vector3
function Vector3:cross(vec3)
    return Vector3:new(self.y * vec3.z - self.z * vec3.y,
        self.z * vec3.x - self.x * vec3.z,
        self.x * vec3.y - self.y * vec3.x)
end

-- deep copy
---@return MathLib.Vector3
function Vector3:Copy() return Vector3(self.x, self.y, self.z) end

return Vector3
