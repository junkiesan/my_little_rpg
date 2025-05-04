-- player.lua : gestion du joueur
local player = {}

function player.load()
    player.x = 100
    player.y = 100
    player.width = 20
    player.height = 20
    player.speed = 100
end

function player.update(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown("right", "d") then dx = 1 end
    if love.keyboard.isDown("left", "q") then dx = -1 end
    if love.keyboard.isDown("down", "s") then dy = 1 end
    if love.keyboard.isDown("up", "z") then dy = -1 end

    player.x = player.x + dx * player.speed * dt
    player.y = player.y + dy * player.speed * dt

    -- bordures écran
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    player.x = math.max(0, math.min(player.x, w - player.width))
    player.y = math.max(0, math.min(player.y, h - player.height))
end

function player.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end

function player.getCenter()
    return player.x + player.width / 2, player.y + player.height / 2
end

return player
