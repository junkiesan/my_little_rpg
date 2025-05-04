-- dialogue.lua : affichage et état de dialogue
local dialogue = {}
local questStage = 0  -- 0 = pas commencée, 1 = en cours, 2 = accomplie

dialogue.active = false
dialogue.currentText = ""

function dialogue.load()
    dialogue.active = false
end

function dialogue.keypressed(key, player, npc)
    if key == "space" then
        if dialogue.active then
            dialogue.active = false
            dialogue.currentText = ""
        else
            local n = npc.getNearby()
            if n then
                dialogue.active = true

                if n.role == "questGiver" then
                    if questStage == 0 then
                        dialogue.currentText = "J'ai une mission pour toi : va parler au PNJ vert."
                        questStage = 1
                    elseif questStage == 1 then
                        dialogue.currentText = "Tu n'as pas encore parlé au PNJ vert."
                    elseif questStage == 2 then
                        dialogue.currentText = "Merci d'avoir accompli ta mission !"
                    end

                elseif n.role == "questTarget" then
                    if questStage == 1 then
                        dialogue.currentText = "Merci de venir me voir. Tu peux retourner voir l'autre."
                        questStage = 2
                    else
                        dialogue.currentText = "Salut !"
                    end

                else
                    dialogue.currentText = n.message
                end
            end
        end
    end
end


function dialogue.draw()
    if dialogue.active and dialogue.currentText then
        local w, h = love.graphics.getWidth(), love.graphics.getHeight()
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, h - 60, w, 60)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(dialogue.currentText, 10, h - 50, w - 20, "left")
    end
end

return dialogue
