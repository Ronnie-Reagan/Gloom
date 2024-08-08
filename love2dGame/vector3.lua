local Vector3 = {}
Vector3.__index = Vector3

-- Constructor to create a new Vector3 object
function Vector3.new(x, y, z)
    return setmetatable({ x = x or 0, y = y or 0, z = z or 0 }, Vector3)
end

-- Add another Vector3 to this Vector3
function Vector3:add(other)
    return Vector3.new(self.x + other.x, self.y + other.y, self.z + other.z)
end

-- Subtract another Vector3 from this Vector3
function Vector3:subtract(other)
    return Vector3.new(self.x - other.x, self.y - other.y, self.z - other.z)
end

-- Multiply this Vector3 by a scalar
function Vector3:multiply(scalar)
    return Vector3.new(self.x * scalar, self.y * scalar, self.z * scalar)
end

-- Normalize this Vector3
function Vector3:normalize()
    local length = math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    if length > 0 then
        return Vector3.new(self.x / length, self.y / length, self.z / length)
    else
        return Vector3.new(0, 0, 0)
    end
end

-- Calculate the distance to another Vector3
function Vector3:distance(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    local dz = self.z - other.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Convert yaw and pitch to a Vector3 direction
function Vector3.fromRotation(yaw, pitch)
    local x = math.cos(pitch) * math.cos(yaw)
    local y = math.sin(pitch)
    local z = math.cos(pitch) * math.sin(yaw)
    return Vector3.new(x, y, z)
end

return Vector3
