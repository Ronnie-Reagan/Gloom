local CONFIG = {
    -- Game Variables
    GAME = {
        hardMode = false,
        timePlayed = 0,
        debug = true
    },

    -- Window Settings
    WINDOW = {
        windowWidth = 1280,
        windowHeight = 720,
        windowTitle = "GLOOM V 0.001",
        defaultWidth = 1280,
        defaultHeight = 720
    },

    -- Colours
    COLOURS = {
        red = { 1, 0, 0 },
        green = { 0, 1, 0 },
        blue = { 0, 0, 1 },
        orange = { 1, 0.5, 0 },
        yellow = { 1, 1, 0 },
        violet = { 0.5, 0, 1 },
        indigo = { 0.3, 0, 0.5 },
        white = { 1, 1, 1 },
        black = { 0, 0, 0 },
        grey = { 0.5, 0.5, 0.5 }
    },

    -- Level Configuration
    LEVELS = {
        currentLevel = 1,
        totalLevels = 3,
        maps = {
            {
                name = "Level 1",
                layout = {
                    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1 },
                    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
                    { 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1 },
                    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
                    { 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
                }
            },
            {
                name = "Level 2",
                layout = {
                    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1 },
                    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
                    { 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1 },
                    { 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1 },
                    { 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1 },
                    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
                    { 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
                }
            },
            {
                name = "Level 3",
                layout = {
                    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1 },
                    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
                    { 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1 },
                    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
                    { 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1 },
                    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
                    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
                }
            }
        }
    },

    -- Heads Up Display
    HUD = {
        map = {
            x = 20,
            y = 20,
            height = 90,
            width = 90,
            blips = { size = 10 }
        },
        ammo = {
            x = 1160,
            y = 680,
            height = 20,
            width = 120,
            textScale = 100,
            backgroundOpacity = 50
        },
        health = {
            x = 1040,
            y = 700,
            width = 240,
            height = 20
        }
    },

    -- Main Menu
    MENU = {
        options = {
            { label = "START",      action = "startGame" },
            { label = "HIGHSCORES", action = "showHighScores" },
            { label = "SETTINGS",   action = "openSettings" },
            { label = "QUIT",       action = "quitGame" }
        },
        button = {
            height = 50,
            width = 200,
            textScale = 100,
            spacing = 10,
            fontSize = 14,
            textColour = { 1, 1, 1 },
            defaultColour = { 0.5, 0.5, 0.5 },
            selectedColour = { 0.7, 0.7, 0.7 },
            selectedTextColour = { 1, 1, 1 }
        },
        settings = {
            resolution = { width = 800, height = 600 },
            fov = math.pi / 3,
            showSettings = false,
            options = {
                {
                    label = "Resolution",
                    values = {
                        "800x600",
                        "1024x768",
                        "1280x720",
                        "1920x1080",
                        "3840x2160"
                    },
                    selected = 1
                },
                {
                    label = "Field of View",
                    values = {
                        "40",
                        "60",
                        "80",
                        "100",
                        "120"
                    },
                    selected = 2
                }
            }
        }
    },

    -- Player Data
    PLAYER = {
        alive = true,
        health = 100,
        speed = 10.1, -- Meters per second
        position = { x = nil, y = nil, z = nil },
        ammoCount = 50,
        regeneration = true,
        regenMultiplier = 1
    },

    -- Weapon Data
    WEAPONS = {
        PISTOL = {
            fireRate = 1.5,
            magazine = 12,
            reloadTime = 2,
            ammo = { damage = 5, range = 100, speed = 300 }
        },
        COLT = {
            fireRate = 4,
            magazine = 30,
            reloadTime = 3.5,
            ammo = { damage = 24, range = 450, speed = 800 }
        },
        KALASHNIKOV = {
            fireRate = 3.6,
            magazine = 30,
            reloadTime = 3,
            ammo = { damage = 25, range = 250, speed = 800 }
        },
        REVOLVER = {
            fireRate = 1,
            magazine = 5,
            reloadTime = 2.5,
            ammo = { damage = 12, range = 80, speed = 280 }
        }
    },

    -- Enemy Data
    ENEMY = {
        type = {
            grunt = { health = 50, speed = 50, damage = 15, chance = 50 },
            soldier = { health = 100, speed = 100, damage = 30, chance = 45 },
            boss = { health = 250, speed = 75, damage = 50, chance = 5 }
        }
    }
}

-- Health Colour Function
function CONFIG:getHealthColour(health)
    if health < 1 then
        return self.COLOURS.black
    elseif health < 25 then
        return self.COLOURS.red
    elseif health < 50 then
        return self.COLOURS.yellow
    else
        return self.COLOURS.green
    end
end

-- Resolution and FOV functions
function CONFIG:getResolutions()
    return self.MENU.settings.options[1].values
end

function CONFIG:getFOVs()
    return self.MENU.settings.options[2].values
end

function CONFIG:setResolution(index)
    local resolution = self:getResolutions()[index]
    local width, height = resolution:match("(%d+)x(%d+)")
    love.window.setMode(tonumber(width), tonumber(height))
end

function CONFIG:setFOV(index)
    local fov = self:getFOVs()[index]
    self.MENU.settings.fov = math.rad(tonumber(fov))
end

return CONFIG
