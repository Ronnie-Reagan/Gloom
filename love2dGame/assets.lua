local Assets = {}

Assets.guns = {
    pistol = {
        name = "Pistol",
        damage = 10, -- Damage in arbitrary units
        speed = 1,   -- Speed in shots per second
        sprite = function()
            local imageData = love.image.newImageData(16, 16)
            for x = 0, 15 do
                for y = 0, 15 do
                    imageData:setPixel(x, y, 0.8, 0.8, 0.8, 1)
                end
            end
            return love.graphics.newImage(imageData)
        end
    }
}

Assets.enemies = {
    grunt = {
        name = "Grunt",
        health = 50, -- Health in arbitrary units
        sprite = function()
            local imageData = love.image.newImageData(32, 32)
            for x = 0, 31 do
                for y = 0, 31 do
                    imageData:setPixel(x, y, 1, 0, 0, 1)
                end
            end
            return love.graphics.newImage(imageData)
        end
    }
}

return Assets
