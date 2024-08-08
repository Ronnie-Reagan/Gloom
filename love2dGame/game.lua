local CONFIG = require("config")
local TextureShader = require("texture_shader")
local Vector3 = require("vector3")
local debug = require("debugger")
local Assets = require("assets") -- Make sure you have the assets file included
local Game = {}

-- Initialize the game
function Game:init()
    self.player = {
        position = Vector3.new(5, 5, 0), -- Use Vector3 for position
        rotation = Vector3.new(0, 0, 0), -- Use Vector3 for rotation (x, y, z)
        speed = CONFIG.PLAYER.speed,     -- Initialize speed from config
        health = CONFIG.PLAYER.health,
        stamina = 100,
        maxStamina = 100,
        ammoCount = CONFIG.PLAYER.ammoCount,
        running = false,
        runMultiplier = 2,
        currentWeapon = CONFIG.WEAPONS.PISTOL,
        jumpSpeed = 5,                   -- Jump speed in meters per second
        gravity = -9.8,                  -- Gravity in meters per second squared
        velocity = Vector3.new(0, 0, 0), -- Use Vector3 for velocity
        isGrounded = true,
        groundLevel = 0
    }
    self.isRunning = false
    self.enemies = {}
    self:initEnemies()
    self.map = CONFIG.LEVELS.maps[1].layout
    self.gameDebugMessages = { "Game initialized" }
    self.weaponAmmo = CONFIG.WEAPONS.PISTOL.magazine + 1
    self.floor = { x = 0 } -- Define the floor level

    -- Load audio assets
    self.pistolSound = love.audio.newSource(Assets.guns.pistol.sound(), "static")
end

-- Initialize enemies
function Game:initEnemies()
    table.insert(self.enemies, {
        position = Vector3.new(7, 7, 0),
        health = 100,
        damage = 10,
        texture = TextureShader:getEnemy(),
        speed = 0 -- set to 1 when they are visible
    })
    -- Add more enemies as needed
end

-- Check collisions for an entity
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
    if entity.position.z < self.floor.x then
        entity.position.z = self.floor.x
        entity.velocity.z = 0
        entity.isGrounded = true
    end
end

-- Check enemy collisions with player
function Game:checkEnemyCollisions()
    for _, enemy in ipairs(self.enemies) do
        if Vector3.distance(self.player.position, enemy.position) < 1 then
            self.player.health = self.player.health - enemy.damage
            if self.player.health <= 0 then
                self:gameOver()
            end
        end
    end
end

-- Start the game
function Game:start()
    self.isRunning = true
    love.mouse.setRelativeMode(true)
    debug.log("Game started")
end

-- Update game state
function Game:update(dt)
    if self.isRunning then
        self:updatePlayer(dt)
        self:updateEnemies(dt)
        self:checkEnemyCollisions()
    end
end

-- Update player state
function Game:updatePlayer(dt)
    local player = self.player
    local moveSpeed = player.speed * dt

    -- Sprinting logic
    if love.keyboard.isDown("lshift") then
        moveSpeed = player.speed * player.runMultiplier * dt
        player.running = true
    else
        player.running = false
    end

    -- Horizontal movement
    local move = Vector3.new(0, 0, 0)
    if love.keyboard.isDown("w") then
        move = Vector3.new(math.cos(player.rotation.z), math.sin(player.rotation.z), 0)
    elseif love.keyboard.isDown("s") then
        move = Vector3.new(-math.cos(player.rotation.z), -math.sin(player.rotation.z), 0)
    elseif love.keyboard.isDown("d") then
        move = Vector3.new(-math.sin(player.rotation.z), math.cos(player.rotation.z), 0)
    elseif love.keyboard.isDown("a") then
        move = Vector3.new(math.sin(player.rotation.z), -math.cos(player.rotation.z), 0)
    end

    -- Apply movement based on velocity
    player.velocity = move:multiply(player.speed)
    player.position = player.position:add(player.velocity:multiply(dt))

    -- Jumping logic
    if player.isGrounded and love.keyboard.isDown("space") then
        player.velocity.z = player.jumpSpeed
        player.isGrounded = false
    end

    -- Apply gravity
    player.velocity.z = player.velocity.z + player.gravity * dt
    player.position.z = player.position.z + player.velocity.z * dt

    -- Check for collisions
    self:checkCollisions(player)
end

-- Update enemies state
function Game:updateEnemies(dt)
    for _, enemy in ipairs(self.enemies) do
        local direction = Vector3.subtract(self.player.position, enemy.position):normalize()
        enemy.position = enemy.position:add(direction:multiply(enemy.speed * dt))
        self:checkCollisions(enemy)
    end
end

-- Handle mouse movement
function Game:mouseMoved(dx, dy)
    self.player.rotation.z = (self.player.rotation.z + dx * CONFIG.MENU.settings.mouseSensitivityX) % (2 * math.pi)
    self.player.rotation.x = self.player.rotation.x + dy * CONFIG.MENU.settings.mouseSensitivityY
    debug.log("Mouse moved: dx = " .. dx .. ", dy = " .. dy)
end

-- Draw game elements
function Game:draw()
    if self.isRunning then
        TextureShader:drawWorld(self.player, self.map, CONFIG.MENU.settings.fov)
        self:drawEnemies()
        self:drawHUD()
        TextureShader:drawFPS()
    end
end

-- Draw enemies
function Game:drawEnemies()
    for _, enemy in ipairs(self.enemies) do
        TextureShader:drawEnemy(enemy.position.x, enemy.position.y)
        debug.log("Enemy Location: X: " .. enemy.position.x .. ". Y: " .. enemy.position.y)
    end
end

-- Draw HUD
function Game:drawHUD()
    local player = self.player
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Health: " .. player.health, 10, 10)
    love.graphics.print("Stamina: " .. player.stamina, 10, 30)
    love.graphics.print("Ammo: " .. player.ammoCount, 10, 50)
    love.graphics.print("Z: " .. player.position.z, 10, 70) -- Display the vertical position
end

-- Handle shooting
function Game:shoot()
    if self.isRunning then
        if self.player.ammoCount > 0 then
            love.audio.play(self.pistolSound)
            self:checkEnemyHit()
            self.player.ammoCount = self.player.ammoCount - 1
        else
            -- Implement auto-reload or prompt to reload based on settings
        end
    end
end

-- Check if an enemy is hit by the player's shot
function Game:checkEnemyHit()
    local weapon = self.player.currentWeapon
    for _, enemy in ipairs(self.enemies) do
        local distance = self.player.position:distance(enemy.position)
        if distance < weapon.range then
            enemy.health = enemy.health - weapon.damage
            if enemy.health <= 0 then
                self:removeEnemy(enemy)
            end
        end
    end
end

-- Remove an enemy from the game
function Game:removeEnemy(enemy)
    for i, e in ipairs(self.enemies) do
        if e == enemy then
            table.remove(self.enemies, i)
            break
        end
    end
end

-- Handle game over
function Game:gameOver()
    self.isRunning = false
    love.mouse.setRelativeMode(false)
    debug.log("Game Over")
end

return Game
