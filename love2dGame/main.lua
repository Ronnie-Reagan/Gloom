local CONFIG = require("config")
local Game = require("game")
local TextureShader = require("texture_shader")
local debug = require("debugger")

local scaleX, scaleY
local selectedMenuOption = 1
local selectedSettingsOption = 1
local settingsMenuOpened = false

-- Function to update scaling factors
local function updateScalingFactors()
    scaleX = love.graphics.getWidth() / CONFIG.WINDOW.defaultWidth
    scaleY = love.graphics.getHeight() / CONFIG.WINDOW.defaultHeight
    debug.log("Scale X: " .. scaleX .. ". Scale Y: " .. scaleY)
end

-- Function to handle resolution change
local function changeResolution(width, height)
    love.window.setMode(width, height)
    updateScalingFactors()
end

-- Function to start the game
local function startGame()
    Game:start()
    debug.clear() -- Clear the debug console when starting the game
end

-- Function to show high scores
local function showHighScores()
    -- Your high scores display logic here
end

-- Function to open settings
local function openSettings()
    settingsMenuOpened = true
end

-- Function to quit the game
local function quitGame()
    love.event.quit()
end

-- Function to handle menu selection
local function selectMenuOption()
    local option = CONFIG.MENU.options[selectedMenuOption]
    if option.action == "startGame" then
        startGame()
    elseif option.action == "showHighScores" then
        showHighScores()
    elseif option.action == "openSettings" then
        openSettings()
    elseif option.action == "quitGame" then
        quitGame()
    end
end

-- Function to check if mouse is over a menu option
local function isMouseOverOption(mx, my, x, y, width, height)
    return mx > x and mx < x + width and my > y and my < y + height
end

-- Function to draw the settings menu
local function drawSettingsMenu()
    love.graphics.setFont(love.graphics.newFont(18))
    love.graphics.printf("Settings Menu", 0, 50, love.graphics.getWidth(), "center")

    for i, option in ipairs(CONFIG.MENU.settings.options) do
        local y = 140 + (i - 1) * 40
        love.graphics.printf(option.label, 100, y, 200, "left")
        for j, value in ipairs(option.values) do
            local x = 300 + (j - 1) * 100
            if j == option.selected then
                love.graphics.setColor(CONFIG.MENU.button.selectedColour)
            else
                love.graphics.setColor(CONFIG.MENU.button.defaultColour)
            end
            love.graphics.rectangle("fill", x, y, 80, 30)
            love.graphics.setColor(CONFIG.MENU.button.textColour)
            love.graphics.printf(value, x, y + 5, 80, "center")
        end
    end

    local applyButtonX = love.graphics.getWidth() - 110
    local applyButtonY = love.graphics.getHeight() - 50
    love.graphics.setColor(CONFIG.MENU.button.defaultColour)
    love.graphics.rectangle("fill", applyButtonX, applyButtonY, 100, 40)
    love.graphics.setColor(CONFIG.MENU.button.textColour)
    love.graphics.printf("Apply", applyButtonX, applyButtonY + 10, 100, "center")
end

-- Function to draw the main menu
local function drawMenu()
    love.graphics.setFont(love.graphics.newFont(CONFIG.MENU.button.fontSize))
    local centerX = love.graphics.getWidth() / 2

    if settingsMenuOpened then
        drawSettingsMenu()
    else
        if CONFIG.MENU.options then
            for i, option in ipairs(CONFIG.MENU.options) do
                local y = (100 + (i - 1) * (CONFIG.MENU.button.height + CONFIG.MENU.button.spacing)) * scaleY
                local optionX = centerX - (CONFIG.MENU.button.width * scaleX / 2)
                if i == selectedMenuOption then
                    love.graphics.setColor(CONFIG.MENU.button.selectedColour)
                    love.graphics.rectangle("fill", optionX, y, CONFIG.MENU.button.width * scaleX,
                        CONFIG.MENU.button.height * scaleY)
                    love.graphics.setColor(CONFIG.MENU.button.selectedTextColour)
                else
                    love.graphics.setColor(CONFIG.MENU.button.defaultColour)
                    love.graphics.rectangle("fill", optionX, y, CONFIG.MENU.button.width * scaleX,
                        CONFIG.MENU.button.height * scaleY)
                    love.graphics.setColor(CONFIG.MENU.button.textColour)
                end
                love.graphics.printf(option.label, optionX, y + 10, CONFIG.MENU.button.width * scaleX, "center")
            end
        end
    end
end

-- Love2D draw callback
function love.draw()
    if Game.isRunning then
        Game:draw()
    else
        drawMenu()
    end
    debug.draw() -- Draw the debug console
end

-- Love2D load callback
function love.load()
    debug.log("Game loading")
    love.window.setMode(CONFIG.WINDOW.windowWidth, CONFIG.WINDOW.windowHeight)
    love.window.setTitle(CONFIG.WINDOW.windowTitle)
    updateScalingFactors()
    Game:init()
    TextureShader:load()
    debug.log("Game loaded")
end

-- Love2D update callback (dt = time elapsed)
function love.update(dt)
    if Game.isRunning then
        Game:update(dt)
    end
end

-- Love2D keypressed callback for menu navigation and game control
function love.keypressed(key)
    debug.log("Key pressed: " .. key) -- Log the key press

    if Game.isRunning then
        if key == "escape" then
            Game.isRunning = false -- Exit to main menu
            love.mouse.setRelativeMode(false)
            debug.log("Game paused")
        end
    else
        if key == "up" then
            if settingsMenuOpened then
                selectedSettingsOption = selectedSettingsOption - 1
                if selectedSettingsOption < 1 then
                    selectedSettingsOption = #CONFIG.MENU.settings.options
                end
            else
                selectedMenuOption = selectedMenuOption - 1
                if selectedMenuOption < 1 then
                    selectedMenuOption = #CONFIG.MENU.options
                end
            end
        elseif key == "down" then
            if settingsMenuOpened then
                selectedSettingsOption = selectedSettingsOption + 1
                if selectedSettingsOption > #CONFIG.MENU.settings.options then
                    selectedSettingsOption = 1
                end
            else
                selectedMenuOption = selectedMenuOption + 1
                if selectedMenuOption > #CONFIG.MENU.options then
                    selectedMenuOption = 1
                end
            end
        elseif key == "left" and settingsMenuOpened then
            local option = CONFIG.MENU.settings.options[selectedSettingsOption]
            option.selected = option.selected - 1
            if option.selected < 1 then
                option.selected = #option.values
            end
        elseif key == "right" and settingsMenuOpened then
            local option = CONFIG.MENU.settings.options[selectedSettingsOption]
            option.selected = option.selected + 1
            if option.selected > #option.values then
                option.selected = 1
            end
        elseif key == "return" or key == "kpenter" then
            if settingsMenuOpened then
                CONFIG:setResolution(CONFIG.MENU.settings.options[1].selected)
                CONFIG:setFOV(CONFIG.MENU.settings.options[2].selected)
                settingsMenuOpened = false
            else
                selectMenuOption()
            end
        end
    end
end

-- Love2D mousemoved callback for player looking around and menu navigation
function love.mousemoved(x, y, dx, dy, istouch)
    if Game.isRunning then
        Game:mouseMoved(dx, dy)
        debug.log(string.format("Mouse moved: dx = %d, dy = %d", dx, dy))
    else
        if settingsMenuOpened then
            for i = 1, #CONFIG.MENU.settings.options do
                if isMouseOverOption(x, y, 300, 140 + (i - 1) * 40, 200, 30) then
                    selectedSettingsOption = i
                end
            end
        else
            for i = 1, #CONFIG.MENU.options do
                if isMouseOverOption(x, y, love.graphics.getWidth() / 2 - (CONFIG.MENU.button.width * scaleX / 2),
                        (100 + (i - 1) * (CONFIG.MENU.button.height + CONFIG.MENU.button.spacing)) * scaleY,
                        CONFIG.MENU.button.width * scaleX, CONFIG.MENU.button.height * scaleY) then
                    selectedMenuOption = i
                    break
                end
            end
        end
    end
end

-- Love2D mousepressed callback for shooting and menu selection
function love.mousepressed(x, y, button, istouch, presses)
    debug.log("Mouse button pressed: " .. button) -- Log the mouse button press

    if Game.isRunning then
        if button == 1 then -- Left mouse button for shooting
            Game:shoot()
            debug.log("LMB Clicked: Firing weapon: " .. Game.player.currentWeapon)
        end
    else
        if button == 1 then
            if settingsMenuOpened then
                local applyButtonX = love.graphics.getWidth() - 110
                local applyButtonY = love.graphics.getHeight() - 50
                if x > applyButtonX and x < applyButtonX + 100 and y > applyButtonY and y < applyButtonY + 40 then
                    CONFIG:setResolution(CONFIG.MENU.settings.options[1].selected)
                    CONFIG:setFOV(CONFIG.MENU.settings.options[2].selected)
                    settingsMenuOpened = false
                else
                    for i = 1, #CONFIG.MENU.settings.options do
                        if y > 140 + (i - 1) * 40 and y < 140 + i * 40 then
                            selectedSettingsOption = i
                            break
                        end
                    end
                    for j = 1, #CONFIG.MENU.settings.options[selectedSettingsOption].values do
                        if x > 300 + (j - 1) * 100 and x < 300 + j * 100 then
                            CONFIG.MENU.settings.options[selectedSettingsOption].selected = j
                            break
                        end
                    end
                end
            else
                if x > 10 and x < 160 and y > love.graphics.getHeight() - 40 and y < love.graphics.getHeight() - 10 then
                    debug.save()
                else
                    selectMenuOption()
                end
            end
        end
    end
end
