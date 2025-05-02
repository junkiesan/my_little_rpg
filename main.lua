-- love.load() s'exécute au démarrage du jeu.
function love.load()
  -- On peut définir ici la couleur de fond de la fenêtre, par exemple un gris clair.
  love.graphics.setBackgroundColor(0.8, 0.8, 0.9)  -- RGB entre 0 et 1 (ici ~80% gris bleuté)
  -- Initialisation du joueur
    player = {}                 -- on crée une table Lua pour stocker les infos du joueur (équivalent d'un objet simple)
    player.x = 100              -- position initiale en X (px)
    player.y = 100              -- position initiale en Y (px)
    player.width = 20           -- largeur du joueur (px)
    player.height = 20          -- hauteur du joueur (px)
    player.speed = 100          -- vitesse du joueur (pixels par seconde)
end

-- love.update(dt) s'exécute à chaque frame pour mettre à jour la logique du jeu.
function love.update(dt)
  -- Pour l'instant, notre jeu n'a pas de logique à mettre à jour.
  -- On pourrait par exemple calculer un chronomètre ou animer quelque chose ici.
  -- Gestion du déplacement du joueur
  local vx, vy = 0, 0   -- composantes du mouvement (vx pour horizontal, vy pour vertical)
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
      vx = 1    -- on ira vers la droite
  end
  if love.keyboard.isDown("left") or love.keyboard.isDown("q") then
      vx = -1   -- vers la gauche
  end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      vy = 1    -- vers le bas
  end
  if love.keyboard.isDown("up") or love.keyboard.isDown("z") then
      vy = -1   -- vers le haut
  end
  -- Met à jour la position du joueur en fonction de la direction et de la vitesse
  player.x = player.x + vx * player.speed * dt
  player.y = player.y + vy * player.speed * dt
  -- Empêche le joueur de sortir de la fenêtre (on borne sa position aux limites de l'écran)
  local screen_w = love.graphics.getWidth()
  local screen_h = love.graphics.getHeight()
  if player.x < 0 then player.x = 0 end
  if player.x + player.width > screen_w then 
      player.x = screen_w - player.width 
  end
  if player.y < 0 then player.y = 0 end
  if player.y + player.height > screen_h then 
      player.y = screen_h - player.height 
  end
end

-- love.draw() s'exécute à chaque frame juste après love.update, pour dessiner à l'écran.
function love.draw()
  -- Affichons un message de bienvenue en blanc.
  love.graphics.setColor(1, 1, 1)        -- Couleur blanche (1,1,1)
  love.graphics.print("Bienvenue dans mon petit RPG en Lua!", 50, 50)
  --              ^ texte à afficher                       ^ coordonnées X, Y à l'écran
  -- Dessin du joueur sous forme d'un rectangle rouge
  love.graphics.setColor(1, 0, 0)  -- définit la couleur courante en rouge (RGB: 1,0,0)
  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end