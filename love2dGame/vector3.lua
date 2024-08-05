-- vector3.lua
local Vector3 = {}
Vector3.__index = Vector3

function Vector3.new(x, y, z)
    return setmetatable({ x = x or 0, y = y or 0, z = z or 0 }, Vector3)
end

function Vector3:add(v)
    return Vector3.new(self.x + v.x, self.y + v.y, self.z + v.z)
end

function Vector3:subtract(v)
    return Vector3.new(self.x - v.x, self.y - v.y, self.z - v.z)
end

function Vector3:multiply(scalar)
    return Vector3.new(self.x * scalar, self.y * scalar, self.z * scalar)
end

function Vector3:divide(scalar)
    return Vector3.new(self.x / scalar, self.y / scalar, self.z / scalar)
end

function Vector3:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3:normalize()
    local magnitude = self:magnitude()
    if magnitude == 0 then
        return Vector3.new(0, 0, 0)
    end
    return self:divide(magnitude)
end

return Vector3
