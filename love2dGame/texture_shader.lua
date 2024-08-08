local TextureShader = {}

-- Function to add debug messages
function TextureShader:addDebugMessage(message)
    table.insert(_GdebugMessages, message)
end

-- Function to create shader
function TextureShader:createShader()
    local vertexShader = [[
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            return transform_projection * vertex_position;
        }
    ]]

    local fragmentShader = [[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 texcolor = Texel(texture, texture_coords);
            float darknessFactor = 0.4; // Adjust this value to control the darkness level
            texcolor.rgb *= darknessFactor;
            return texcolor * color;
        }
    ]]

    return love.graphics.newShader(vertexShader, fragmentShader)
end

-- Function to generate textures
local function generateTexture(width, height, colorFunc)
    local imageData = love.image.newImageData(width, height)
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            local r, g, b, a = colorFunc(x, y)
            imageData:setPixel(x, y, r, g, b, a)
        end
    end
    return love.graphics.newImage(imageData)
end

-- Function to load textures
function TextureShader:load()
    self.logFileName = os.date("%Y-%m-%d_%H-%M-%S") .. "_Texture_Shader_Debug_debug.log"
    self.floorTexture = generateTexture(64, 64, function(x, y)
        local color = ((x + y) % 16 < 8) and 0.3 or 0.35
        return color, color, color, 1
    end)
    self.ceilingTexture = generateTexture(64, 64, function(x, y)
        local color = ((x + y) % 16 < 8) and 0.5 or 0.55
        return color, color, color, 1
    end)
    self.wallTexture = generateTexture(64, 64, function(x, y)
        local color = ((x + y) % 8 < 4) and 0.4 or 0.2
        return color, color, color, 1
    end)
    self.gunTexture = generateTexture(32, 32, function(x, y)
        local color = (x % 4 == 0 or y % 4 == 0) and 1 or 0.5
        return color, color, color, 1
    end)
    self.enemyTexture = generateTexture(32, 32, function(x, y)
        local color = (x % 4 == 0 or y % 4 == 0) and 0.8 or 0.3
        return color, 0, 0, 1
    end)
    self.textureDebugMessages = {}
    self:addDebugMessage("Textures loaded")
end

-- Getter functions for textures
function TextureShader:getFloor() return self.floorTexture end

function TextureShader:getCeiling() return self.ceilingTexture end

function TextureShader:getWall() return self.wallTexture end

function TextureShader:getGun() return self.gunTexture end

function TextureShader:getEnemy() return self.enemyTexture end

-- Function to draw the game world
function TextureShader:drawWorld(player, map, fov)
    local startTime = math.floor(love.timer.getTime() * 1000000)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local numRays = w
    local maxDepth = 100
    local deltaAngle = fov / numRays

    self:addDebugMessage("Player position: " ..
        "X:" .. tostring(player.position.x) ..
        ", Y:" .. tostring(player.position.y) ..
        ", Z:" .. tostring(player.position.z) ..
        ", Rotation: " .. tostring(player.rotation.z) ..
        ", Pitch:" .. tostring(player.rotation.x) ..
        ", Roll:" .. tostring(player.rotation.y))

    local shader = self:createShader()
    love.graphics.setShader(shader)

    for i = 1, numRays - 1 do
        local rayAngle = player.rotation.z - fov / 2 + deltaAngle * i
        local distanceToWall = 0
        local hitWall = false
        local eyeX = math.cos(rayAngle)
        local eyeY = math.sin(rayAngle)

        while not hitWall and distanceToWall < maxDepth do
            distanceToWall = distanceToWall + 0.01 -- Adjusted increment for faster ray tracing
            local testX = math.floor(player.position.x + eyeX * distanceToWall)
            local testY = math.floor(player.position.y + eyeY * distanceToWall)

            if testX < 0 or testX >= #map[1] or testY < 0 or testY >= #map then
                hitWall = true
                distanceToWall = maxDepth
            elseif map[testY + 1][testX + 1] == 1 then
                hitWall = true
            end
        end

        local lineHeight = (1 / distanceToWall) * h

        -- Adjust line height based on player's pitch
        local verticalAdjustment = player.rotation.x * 100
        local drawStart = math.max(-lineHeight / 2 + h / 2 - verticalAdjustment, 0)
        local drawEnd = math.min(lineHeight / 2 + h / 2 - verticalAdjustment, h)

        -- Adjust vertical position based on player's Z position
        drawStart = drawStart + player.position.z * 50
        drawEnd = drawEnd + player.position.z * 50

        local shade = 1 - (distanceToWall / maxDepth)
        love.graphics.setColor(shade, shade, shade)
        love.graphics.rectangle("fill", i * (w / numRays), drawStart, w / numRays, drawEnd - drawStart)
    end

    love.graphics.setShader()
    local finishTime = (math.floor(love.timer.getTime() * 1000000) - startTime)
    self:addDebugMessage("World drawn. Number of rays: " ..
        numRays ..
        ". Time to draw: " ..
        finishTime .. " Micro Seconds." .. " Current delta time: " .. math.floor(love.timer.getDelta() * 1000000))
end

-- Function to draw FPS
function TextureShader:drawFPS()
    local fps = love.timer.getFPS()
    local color = { 0, 1, 0 }
    if fps < 30 then
        color = { 1, 0, 0 }
    elseif fps < 60 then
        color = { 1, 0.5, 0 }
    end
    love.graphics.setColor(color)
    local y = (love.graphics.getWidth() - 60)
    love.graphics.print("FPS: " .. fps, y, 10)
end

-- Function to draw gun
function TextureShader:drawGun()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self:getGun(), love.graphics.getWidth() - 64, love.graphics.getHeight() - 64)
end

-- Function to draw enemy
function TextureShader:drawEnemy(x, y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self:getEnemy(), x, y)
end

-- Function to draw debug messages
function TextureShader:drawDebugMessages()
    love.graphics.setColor(1, 1, 1)
    local y = 30
    for _, message in ipairs(self.textureDebugMessages) do
        love.graphics.print(message, 10, y)
        y = y + 20
    end
end

return TextureShader
