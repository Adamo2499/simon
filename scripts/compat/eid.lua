local Enums = require("scripts.enums")

if EID then
    EID:addBirthright(Enums.Characters.SIMON, "Increases health limit to 12#Creeps now have buffed effect", "Simon")
    -- local simonIcons = Sprite():Load("gfx/eid_player_icons.anm2", true)
    -- EID:addIcon("Player" .. Enums.Characters.SIMON, "Players", 0, 16, 16, 0, 0, simonIcons)

    EID:addCollectible(Enums.Items.GOSPEL_OF_JOHN,
        "Turns Isaac into {{Player8}} Lazarus for the room. #If Isaac is killed in this state, he becomes {{Player11}} Lazarus Risen without switching back to the previous character.", "Gospel of John", "en_us")
    EID:AddPlayerConditional(Enums.Items.GOSPEL_OF_JOHN, PlayerType.PLAYER_LAZARUS, "Grants a stat major stat boost for current room", nil, false)
    EID:AddPlayerConditional(Enums.Items.GOSPEL_OF_JOHN, PlayerType.PLAYER_LAZARUS2, "Switch back to normal Lazarus and regain his extra life", nil, false)
    EID:AddPlayerConditional(Enums.Items.GOSPEL_OF_JOHN, PlayerType.PLAYER_LAZARUS_B, "Grants a stat major stat boost for current room #Tainted Revive", nil, false)
    EID:addCollectible(Enums.Items.BARMBRACK, "↑ {{Heart}} +1 Health#{{HealingRed}} Heals 1 heart# When picked up, a trinket, a coin, a bomb, a key, a battery, a heart or nothing spawns near Isaac's vicinity.#{{AngelChance}} +5%  Room chance")
    EID:addCollectible(Enums.Items.COOTIES, "Inflicts fear on all enemies in a radius around Isaac, similar to {{Collectible421}} Kidney Bean.")
end
