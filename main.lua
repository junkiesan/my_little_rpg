-- love.load() s'exécute au démarrage du jeu.
function love.load()
  -- On peut définir ici la couleur de fond de la fenêtre, par exemple un gris clair.
  love.graphics.setBackgroundColor(0.1, 0.6, 0.1)  -- RGB entre 0 et 1 (ici ~80% gris bleuté)
  -- Initialisation du joueur
    player = {}                 -- on crée une table Lua pour stocker les infos du joueur (équivalent d'un objet simple)
    player.x = 100              -- position initiale en X (px)
    player.y = 100              -- position initiale en Y (px)
    player.width = 20           -- largeur du joueur (px)
    player.height = 20          -- hauteur du joueur (px)
    player.speed = 100          -- vitesse du joueur (pixels par seconde)
    -- Initialisation d'un PNJ
    npc = {}
    npc.x = 400    -- position X du PNJ
    npc.y = 300    -- position Y du PNJ
    npc.width = 20
    npc.height = 20
    npc.color = {0, 0, 1}   -- bleu (couleur RVB)
    npc.message = "Bonjour, aventurier !"  -- le message que le PNJ dira
    -- Initialisation d'un deuxième PNJ (PNJ2)
    npc2 = {}
    npc2.x = 150
    npc2.y = 400
    npc2.width = 20
    npc2.height = 20
    npc2.color = {0, 1, 0}  -- vert
    npc2.message = "Salut, je suis l'autre PNJ."
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
  -- Détection de la proximité joueur-PNJ
  local dx = (player.x + player.width/2) - (npc.x + npc.width/2)
  local dy = (player.y + player.height/2) - (npc.y + npc.height/2)
  local distance = math.sqrt(dx*dx + dy*dy)
  player.nearNPC = (distance < 30)  -- booléen, true si le joueur est à >30px du PNJ
  -- Détection du PNJ le plus proche
  player.nearNPC = false
  nearbyNPC = nil
  local function checkProximity(px, py, tx, ty)
      local dx = (px - tx)
      local dy = (py - ty)
      return (dx*dx + dy*dy) < (30*30)  -- on compare les distances au carré pour éviter sqrt
  end
  if checkProximity(player.x + player.width/2, player.y + player.height/2,
                    npc.x + npc.width/2, npc.y + npc.height/2) then
    player.nearNPC = true
    nearbyNPC = npc
  end
  if checkProximity(player.x + player.width/2, player.y + player.height/2,
                    npc2.x + npc2.width/2, npc2.y + npc2.height/2) then
    player.nearNPC = true
    nearbyNPC = npc2
  end
end

-- love.draw() s'exécute à chaque frame juste après love.update, pour dessiner à l'écran.
function love.draw()
  -- Affichons un message de bienvenue en blanc.
  love.graphics.setColor(1, 1, 1)        -- Couleur blanche (1,1,1)
  love.graphics.print("Bienvenue dans mon petit RPG en Lua!", 50, 50)
  --              ^ texte à afficher                       ^ coordonnées X, Y à l'écran
  love.graphics.setColor(0.6, 0.3, 0.1)  -- brun
  love.graphics.rectangle("fill", 300, 200, 50, 50)
  -- Dessin du PNJ (carré bleu)
  love.graphics.setColor(npc.color)  -- applique la couleur bleue du PNJ
  love.graphics.rectangle("fill", npc.x, npc.y, npc.width, npc.height)
  -- Dessin du second PNJ (vert)
  love.graphics.setColor(npc2.color)
  love.graphics.rectangle("fill", npc2.x, npc2.y, npc2.width, npc2.height)
  -- Dessin du joueur sous forme d'un rectangle rouge
  love.graphics.setColor(1, 0, 0)  -- définit la couleur courante en rouge (RGB: 1,0,0)
  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    if dialogueActive and currentDialogue then
        -- On dessine une boîte semi-transparente en bas de l'écran
        local w = love.graphics.getWidth()
        local h = love.graphics.getHeight()
        love.graphics.setColor(0, 0, 0, 0.7)  -- noir translucide (alpha 0.7)
        love.graphics.rectangle("fill", 0, h - 60, w, 60)
        -- Texte du dialogue en blanc
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(currentDialogue, 10, h - 50, w - 20, "left")
        -- love.graphics.printf permet d'afficher du texte formaté (ici on spécifie une largeur max et un alignement)
    end
end

function love.keypressed(key)
    if key == "space" then
        if dialogueActive then
            -- Fermer le dialogue
            dialogueActive = false
        else
            if player.nearNPC and nearbyNPC ~= nil then
                dialogueActive = true
                -- Gestion de la quête selon le PNJ et l'état
                if questStage == nil then questStage = 0 end
                if nearbyNPC == npc then
                    -- PNJ donneur de quête
                    if questStage == 0 then
                        currentDialogue = "J'ai une mission pour toi : va parler au personnage en vert, puis reviens me voir."
                        questStage = 1  -- quête démarrée
                    elseif questStage == 1 then
                        currentDialogue = "Dépêche-toi d'aller le voir."
                    elseif questStage == 2 then
                        currentDialogue = "Merci d'avoir fait ce que je t'ai demandé ! (Quête terminée)"
                    end
                elseif nearbyNPC == npc2 then
                    -- Second PNJ (cible de la quête)
                    if questStage == 1 then
                        currentDialogue = "Bonjour. Tu pourras dire à l'autre que tout va bien."
                        questStage = 2  -- on considère la quête accomplie une fois ce PNJ parlé
                    else
                        currentDialogue = "Bonjour."
                    end
                end
            end
        end
    end
end