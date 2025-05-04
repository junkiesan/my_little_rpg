-- npc.lua : gestion du ou des PNJ
local npc = {}

function npc.load()
  npc.list = {
      {
          id = "pnj1",
          x = 400, y = 300, width = 20, height = 20,
          color = {0, 0, 1},
          message = "Bonjour, aventurier !",
          role = "questGiver"
      },
      {
          id = "pnj2",
          x = 150, y = 400, width = 20, height = 20,
          color = {0, 1, 0},
          message = "Salut, je suis l'autre PNJ.",
          role = "questTarget"
      }
  }
end

function npc.update(dt, player)
    for _, n in ipairs(npc.list) do
        local dx = player.x + player.width/2 - (n.x + n.width/2)
        local dy = player.y + player.height/2 - (n.y + n.height/2)
        n.near = (dx * dx + dy * dy) < 30 * 30
    end
end

function npc.draw()
    for _, n in ipairs(npc.list) do
        love.graphics.setColor(n.color)
        love.graphics.rectangle("fill", n.x, n.y, n.width, n.height)
    end
end

function npc.getNearby()
    for _, n in ipairs(npc.list) do
        if n.near then return n end
    end
    return nil
end

function npc.getById(id)
  for _, n in ipairs(npc.list) do
      if n.id == id then return n end
  end
end

return npc
