-- player.lua : gestion du joueur
local enemy = require("enemy")
local player = {}

function player.load()
    player.x = 100
    player.y = 100
    player.width = 20
    player.height = 20
    player.speed = 100
    player.hp = 3
    player.maxHp = 3
    player.attackCooldown = 0
    player.facing = "down" 
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

    if dx ~= 0 or dy ~= 0 then
      if math.abs(dx) > math.abs(dy) then
          player.facing = dx > 0 and "right" or "left"
      else
          player.facing = dy > 0 and "down" or "up"
      end
  end

  if player.attackCooldown > 0 then
      player.attackCooldown = player.attackCooldown - dt
  end
end

function player.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end

function player.getCenter()
    return player.x + player.width / 2, player.y + player.height / 2
end

function player.drawHUD()
  local x, y = 10, 10
  for i = 1, player.maxHp do
      if i <= player.hp then
          love.graphics.setColor(1, 0, 0)  -- rouge : cœur plein
      else
          love.graphics.setColor(0.5, 0.5, 0.5)  -- gris : cœur vide
      end
      love.graphics.rectangle("fill", x + (i - 1) * 25, y, 20, 20)
  end
end

function player.attack()
  if player.attackCooldown > 0 then return end
  player.attackCooldown = 0.5  -- 0.5s de cooldown

  local ax, ay, aw, ah = player.x, player.y, player.width, player.height
  local range = 25

  if player.facing == "up" then
      ay = ay - range
      ah = range
  elseif player.facing == "down" then
      ay = ay + player.height
      ah = range
  elseif player.facing == "left" then
      ax = ax - range
      aw = range
  elseif player.facing == "right" then
      ax = ax + player.width
      aw = range
  end

  enemy.hitAt(ax, ay, aw, ah)
end


return player
