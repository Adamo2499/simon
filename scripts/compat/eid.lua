if EID then
    local Enums = include("scripts.compat.enums")

    EID:addBirthright(Enums.Characters.SIMON, "Increases health limit to 12#Creeps now have buffed effect", "Simon")
    local simonIcons = Sprite():Load("gfx/eid_player_icons.anm2", true)
    -- EID:addIcon("Player" .. Enums.Characters.SIMON, "Players", 0, 16, 16, 0, 0, simonIcons)
end
