local Enums = require("scripts.enums")

if EID then
    EID:addBirthright(Enums.Characters.SIMON, "Increases health limit to 12#Creeps now have buffed effect", "Simon")
    -- local simonIcons = Sprite():Load("gfx/eid_player_icons.anm2", true)
    -- EID:addIcon("Player" .. Enums.Characters.SIMON, "Players", 0, 16, 16, 0, 0, simonIcons)

    EID:addCollectible(Enums.Items.GOSPEL_OF_JOHN,
        "Turns Isaac into {{Player8}} Lazarus for the room. #If Isaac is killed in this state, he becomes {{Player11}} Lazarus Risen without switching back to the previous character.", "Gospel of John", "en_us")
    EID:AddPlayerConditional(Enums.Items.GOSPEL_OF_JOHN, 8, "Grants a stat major stat boost for current room", nil, false)
    EID:AddPlayerConditional(Enums.Items.GOSPEL_OF_JOHN, 11, "Switch back to normal Lazarus and regain his extra life", nil, false)
    EID:AddPlayerConditional(Enums.Items.GOSPEL_OF_JOHN, 29, "Grants a stat major stat boost for current room #Tainted Revive", nil, false)
end
