-- enemy.lua : gestion des ennemis simples
local enemy = {}

function enemy.load()
    enemy.list = {
        {
            x = 250,
            y = 200,
            width = 20,
            height = 20,
            color = {0.7, 0, 0},
            damage = 1,
            hp = 2
        }
    }
    enemy.loot = {}
    enemy.invincibleTime = 0
end

function enemy.update(dt, player)
    -- délai d'invincibilité après une collision
    if enemy.invincibleTime > 0 then
        enemy.invincibleTime = enemy.invincibleTime - dt
    end

    for _, e in ipairs(enemy.list) do
        if enemy.invincibleTime <= 0 and enemy.checkCollision(e, player) then
            player.hp = math.max(0, player.hp - e.damage)
            enemy.invincibleTime = 1  -- 1 seconde d’invincibilité
        end
    end
    for i = #enemy.list, 1, -1 do
      if enemy.list[i].hp <= 0 then
          table.insert(enemy.loot, {
            x = enemy.list[i].x,
            y = enemy.list[i].y,
            w = 10,
            h = 10,
            collected = false
        })
          table.remove(enemy.list, i)
      end
  end
end

function enemy.draw()
    for _, e in ipairs(enemy.list) do
        love.graphics.setColor(e.color)
        love.graphics.rectangle("fill", e.x, e.y, e.width, e.height)
        love.graphics.setColor(e.hp > 0 and e.color or {0.2, 0.2, 0.2})
    end
end

function enemy.checkCollision(e, player)
    return e.x < player.x + player.width and
           player.x < e.x + e.width and
           e.y < player.y + player.height and
           player.y < e.y + e.height
end

function enemy.hitAt(x, y, w, h)
  for _, e in ipairs(enemy.list) do
      if e.hp > 0 and
         x < e.x + e.width and
         e.x < x + w and
         y < e.y + e.height and
         e.y < y + h then
          e.hp = e.hp - 1
          return true
      end
  end
  return false
end

function enemy.drawLoot()
  for _, item in ipairs(enemy.loot) do
      if not item.collected then
          love.graphics.setColor(1, 1, 0)  -- jaune
          love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
      end
  end
end

function enemy.checkLootPickup(player)
  for _, item in ipairs(enemy.loot) do
      if not item.collected and
         item.x < player.x + player.width and
         player.x < item.x + item.w and
         item.y < player.y + player.height and
         player.y < item.y + item.h then
          item.collected = true
          player.hp = math.min(player.maxHp, player.hp + 1)
      end
  end
end

return enemy
