local Assets = {}

-- Helper function to draw a rectangle with border
local function drawRectangle(imageData, x, y, width, height, fillColor, borderColor)
    for i = x, x + width - 1 do
        for j = y, y + height - 1 do
            if i == x or i == x + width - 1 or j == y or j == y + height - 1 then
                imageData:setPixel(i, j, unpack(borderColor))
            else
                imageData:setPixel(i, j, unpack(fillColor))
            end
        end
    end
end

-- Helper function to add noise to texture
local function generateWhiteNoise(duration, sampleRate, volume)
    local samples = {}
    local amplitude = volume or 1
    for i = 0, sampleRate * duration - 1 do
        local sample = (math.random() * 2 - 1) * amplitude
        table.insert(samples, sample)
    end

    local soundData = love.sound.newSoundData(#samples, sampleRate, 16, 1) -- 16 bits, mono
    for i, sample in ipairs(samples) do
        soundData:setSample(i - 1, sample)
    end
    return soundData
end

local function generateSineWave(frequency, duration, sampleRate, volume)
    local samples = {}
    local amplitude = volume or 1
    for i = 0, sampleRate * duration - 1 do
        local sample = math.sin(2 * math.pi * frequency * i / sampleRate) * amplitude
        table.insert(samples, sample)
    end

    local soundData = love.sound.newSoundData(#samples, sampleRate, 16, 1) -- 16 bits, mono
    for i, sample in ipairs(samples) do
        soundData:setSample(i - 1, sample)
    end
    return soundData
end

local function mixSounds(soundDataList, sampleRate)
    local totalSamples = 0
    for _, soundData in ipairs(soundDataList) do
        totalSamples = totalSamples + soundData:getSampleCount()
    end

    local finalSoundData = love.sound.newSoundData(totalSamples, sampleRate, 16, 1)
    local sampleIndex = 0
    for _, soundData in ipairs(soundDataList) do
        for i = 0, soundData:getSampleCount() - 1 do
            local sample = soundData:getSample(i)
            local existingSample = finalSoundData:getSample(sampleIndex) or 0
            finalSoundData:setSample(sampleIndex, existingSample + sample)
            sampleIndex = sampleIndex + 1
        end
    end

    return finalSoundData
end

local function generateGunshotSound()
    local sampleRate = 48000 -- Samples per second
    local soundDataList = {}

    -- Initial Burst (white noise and various sine waves to create an explosive sound)
    table.insert(soundDataList, generateSineWave(40, 0.1, sampleRate, 0.7))
    table.insert(soundDataList, generateSineWave(50, 0.001, sampleRate, 0.6))
    table.insert(soundDataList, generateSineWave(10, 0.001, sampleRate, 0.5))
    table.insert(soundDataList, generateSineWave(15, 0.001, sampleRate, 0.4))
    table.insert(soundDataList, generateSineWave(20, 0.001, sampleRate, 0.3))

    return mixSounds(soundDataList, sampleRate)
end

Assets.guns = {
    pistol = {
        name = "Pistol",
        damage = 10, -- Damage in arbitrary units
        speed = 1,   -- Speed in shots per second
        sprite = function()
            local imageData = love.image.newImageData(16, 16)
            local fillColor = { 0.8, 0.8, 0.8, 1 }
            local borderColor = { 0.6, 0.6, 0.6, 1 }
            drawRectangle(imageData, 4, 4, 8, 8, fillColor, borderColor)
            return love.graphics.newImage(imageData)
        end,
        sound = function()
            return generateGunshotSound()
        end
    }
}

-- Enemy assets
Assets.enemies = {
    grunt = {
        name = "Grunt",
        health = 50, -- Health in arbitrary units
        sprite = function()
            local imageData = love.image.newImageData(32, 32)
            local bodyColor = { 0.8, 0.1, 0.1, 1 }
            local eyeColor = { 1, 1, 1, 1 }
            local pupilColor = { 0, 0, 0, 1 }
            -- Draw body with gradient
            for x = 0, 31 do
                for y = 0, 31 do
                    local shade = 0.7 + 0.3 * (y / 31)
                    imageData:setPixel(x, y, bodyColor[1] * shade, bodyColor[2] * shade, bodyColor[3] * shade,
                        bodyColor[4])
                end
            end
            -- Draw eyes
            drawRectangle(imageData, 8, 8, 4, 4, eyeColor, pupilColor)
            drawRectangle(imageData, 20, 8, 4, 4, eyeColor, pupilColor)
            addNoise(imageData, 0.05)
            return love.graphics.newImage(imageData)
        end
    }
}

-- Texture assets
Assets.textures = {
    wall = function()
        local imageData = love.image.newImageData(32, 32)
        local baseColor = { 0.6, 0.6, 0.6, 1 }
        local brickColor = { 0.5, 0.5, 0.5, 1 }
        local mortarColor = { 0.4, 0.4, 0.4, 1 }
        -- Draw bricks with mortar lines
        for x = 0, 31 do
            for y = 0, 31 do
                local color = baseColor
                if x % 8 < 7 and y % 8 < 7 then
                    color = brickColor
                else
                    color = mortarColor
                end
                imageData:setPixel(x, y, unpack(color))
            end
        end
        addNoise(imageData, 0.05)
        return love.graphics.newImage(imageData)
    end
}



return Assets
