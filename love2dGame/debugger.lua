-- debug.lua
local debug = {}
local maxdebugMessages = 200
local debugMessages = {}

function debug.log(message)
    if #debugMessages >= maxdebugMessages then
        table.remove(debugMessages, 1)
    end
    table.insert(debugMessages, message)
    print(message)
end

function debug.clear()
    debugMessages = {}
end

function debug.save()
    local file = love.filesystem.newFile(os.date("%Y-%m-%d_%H-%M-%S") .. "_debug.log", "w")
    for _, message in ipairs(debugMessages) do
        file:write(message .. "\n")
    end
    file:close()
    debug.log("debug messages saved to debug_log.txt")
end

function debug.draw()
    if CONFIG and CONFIG.GAME and CONFIG.GAME.debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(12))
        for i, message in ipairs(debugMessages) do
            love.graphics.print(message, 10, 10 + (i - 1) * 15)
        end
    end
end

return debug
