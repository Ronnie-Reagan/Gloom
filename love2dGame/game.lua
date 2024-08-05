local CONFIG = require("config")
local TextureShader = require("texture_shader")
local Vector3 = require("vector3")

local Game = {}

function Game:init()
    self.player = {
        position = Vector3.new(5, 5, 0), -- Use Vector3 for position
        rotation = 0,                    -- left-right rotation
        speed = CONFIG.PLAYER.speed,     -- Initialize speed from config
        health = CONFIG.PLAYER.health,
        stamina = 100,
        maxStamina = 100,
        ammoCount = CONFIG.PLAYER.ammoCount,
        running = false,
        runMultiplier = 2,
        currentWeapon = CONFIG.WEAPONS.PISTOL,
        jumpSpeed = 3,                   -- Jump speed in meters per second
        gravity = -9.8,                  -- Gravity in meters per second squared
        velocity = Vector3.new(0, 0, 0), -- Use Vector3 for velocity
        isGrounded = true,
        groundLevel = 0
    }
    self.isRunning = false
    self.map = {
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 0, 1, 1, 1, 0, 0, 1 },
        { 1, 0, 1, 0, 0, 0, 1, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 0, 1, 0, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 1, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 1, 1, 0, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    }
    self.gameDebugMessages = { "Game initialized" }
    self.weaponAmmo = CONFIG.WEAPONS.PISTOL.magazine + 1
    self.floor = { y = 0 } -- Define the floor level
end

function Game:checkCollisions(entity)
    -- Check collisions with the map boundaries
    if entity.position.x < 1 then entity.position.x = 1 end
    if entity.position.y < 1 then entity.position.y = 1 end
    if entity.position.x > #self.map[1] - 1 then entity.position.x = #self.map[1] - 1 end
    if entity.position.y > #self.map - 1 then entity.position.y = #self.map - 1 end

    -- Check collisions with map walls
    if self.map[math.floor(entity.position.y)][math.floor(entity.position.x)] == 1 then
        -- Handle wall collision by stopping movement or repositioning
        entity.position.x = math.floor(entity.position.x) + 0.5
        entity.position.y = math.floor(entity.position.y) + 0.5
    end

    -- Check collisions with the floor
    if entity.position.z < self.floor.y then
        entity.position.z = self.floor.y
        entity.velocity.z = 0
        entity.isGrounded = true
    end
end

function Game:start()
    self.isRunning = true
    love.mouse.setRelativeMode(true)
    table.insert(self.gameDebugMessages, "Game started")
end

function Game:update(dt)
    if self.isRunning then
        self:updatePlayer(dt)
    end
end

function Game:updatePlayer(dt)
    local player = self.player
    local moveSpeed = player.speed * dt

    -- Debug: Show initial positions and speeds
    table.insert(self.gameDebugMessages,
        "Initial Player Position: X" .. player.position.x .. ", Y" .. player.position.y .. ", Z" .. player.position.z)
    table.insert(self.gameDebugMessages,
        "Initial Player Velocity: X" .. player.velocity.x .. ", Y" .. player.velocity.y .. ", Z" .. player.velocity.z)

    -- Sprinting logic
    if love.keyboard.isDown("lshift") then
        moveSpeed = player.speed * player.runMultiplier * dt
        player.running = true
        table.insert(self.gameDebugMessages, "Sprinting. Speed: " .. moveSpeed)
    else
        player.running = false
    end

    -- Horizontal movement
    local move = Vector3.new(0, 0, 0)
    if love.keyboard.isDown("w") then
        move = move:add(Vector3.new(math.cos(player.rotation), math.sin(player.rotation), 0))
        table.insert(self.gameDebugMessages, "Moving Forward.")
    end
    if love.keyboard.isDown("s") then
        move = move:add(Vector3.new(-math.cos(player.rotation), -math.sin(player.rotation), 0))
        table.insert(self.gameDebugMessages, "Moving Backward.")
    end
    if love.keyboard.isDown("d") then
        move = move:add(Vector3.new(-math.sin(player.rotation), math.cos(player.rotation), 0))
        table.insert(self.gameDebugMessages, "Strafing Right.")
    end
    if love.keyboard.isDown("a") then
        move = move:add(Vector3.new(math.sin(player.rotation), -math.cos(player.rotation), 0))
        table.insert(self.gameDebugMessages, "Strafing Left.")
    end

    -- Apply movement
    player.position = player.position:add(move:multiply(moveSpeed))

    -- Debug: Show position after horizontal movement
    table.insert(self.gameDebugMessages,
        "Player Position after Horizontal Movement: X" ..
        player.position.x .. ", Y" .. player.position.y .. ", Z" .. player.position.z)

    -- Jumping logic
    if player.isGrounded and love.keyboard.isDown("space") then
        player.velocity.z = player.jumpSpeed * 10
        player.isGrounded = false
        table.insert(self.gameDebugMessages, "Jumping. Vertical Speed: " .. player.velocity.z)
    end

    -- Apply gravity
    player.velocity.z = player.velocity.z + (player.gravity * dt)
    player.position.z = player.position.z + player.velocity.z * dt

    -- Debug: Show position after applying gravity
    table.insert(self.gameDebugMessages,
        "Player Position after Gravity: X" ..
        player.position.x .. ", Y" .. player.position.y .. ", Z" .. player.position.z)

    -- Check for collisions
    self:checkCollisions(player)

    -- Debug: Final positions and velocities
    table.insert(self.gameDebugMessages,
        "Final Player Position: X" .. player.position.x .. ", Y" .. player.position.y .. ", Z" .. player.position.z)
    table.insert(self.gameDebugMessages,
        "Final Player Velocity: X" .. player.velocity.x .. ", Y" .. player.velocity.y .. ", Z" .. player.velocity.z)
end

function Game:mouseMoved(dx, dy)
    local lastRotation = math.deg(self.player.rotation)
    self.player.rotation = (self.player.rotation + dx * 0.002) % (2 * math.pi)
    local directionFacingDegrees = math.deg(self.player.rotation)
    local messageToAdd = "Mouse moved: " ..
        dx ..
        ", " ..
        dy .. "\nLast Rotation: " .. tostring(lastRotation) .. ", New Rotation: " .. tostring(directionFacingDegrees)
    table.insert(self.gameDebugMessages, messageToAdd)
end

function Game:draw()
    if self.isRunning then
        TextureShader:drawWorld(self.player, self.map, CONFIG.MENU.settings.fov)
        self:drawHUD()
        TextureShader:drawFPS()
    end
end

function Game:drawHUD()
    local player = self.player
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Health: " .. player.health, 10, 10)
    love.graphics.print("Stamina: " .. player.stamina, 10, 30)
    love.graphics.print("Ammo: " .. player.ammoCount, 10, 50)
    love.graphics.print("Z: " .. player.position.z, 10, 70) -- Display the vertical position
end

function Game:shoot()
    if self.isRunning then
        if self.weaponAmmo > 0 then
            local weapon = self.player.currentWeapon
            -- Fire current weapon logic here
            self.weaponAmmo = self.weaponAmmo - 1
        else
            -- Implement auto-reload or prompt to reload based on settings
        end
    end
end

return Game
