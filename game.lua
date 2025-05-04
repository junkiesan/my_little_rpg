-- game.lua : cycle principal du jeu
local player = require("player")
local npc = require("npc")
local dialogue = require("dialogue")
local enemy = require("enemy")

local game = {}

function game.load()
    love.graphics.setBackgroundColor(0.1, 0.6, 0.1) -- herbe
    player.load()
    npc.load()
    dialogue.load()
    enemy.load()
end

function game.update(dt)
    if not dialogue.active then
        player.update(dt)
        enemy.update(dt, player)
    end
    npc.update(dt, player)
end

function game.draw()
    npc.draw()
    player.draw()
    player.drawHUD()
    dialogue.draw()
    enemy.draw()
end

function game.keypressed(key)
    dialogue.keypressed(key, player, npc)
end

return game
