-- debug.lua
_Gdebug = {}
_GmaxdebugMessages = 2000
_GdebugMessages = {}
local debugMode = true

-- Log a message to the debug console and print it to the standard output
function debug.log(message)
    if #_GdebugMessages >= _GmaxdebugMessages then
        _GdebugMessages = {}
    end
    table.insert(_GdebugMessages, message)
    print(message)
end

-- Clear all debug messages
function debug.clear()
    _GdebugMessages = {}
end

-- Save all debug messages to a file
function debug.save()
    local fileName = os.date("%Y-%m-%d_%H-%M-%S") .. "_debug.log"
    local file = love.filesystem.newFile(fileName, "w")
    for _, message in ipairs(_GdebugMessages) do
        file:write(message .. "\n")
    end
    file:close()
    debug.log("Debug messages saved to " .. fileName)
end

-- Draw debug messages on the screen if debug mode is enabled
function debug.draw()
    if debugMode then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(12))
        for i, message in ipairs(_GdebugMessages) do
            love.graphics.print(message, 10, 10 + ((i - 1) * 15))
        end
    end
end

return debug
