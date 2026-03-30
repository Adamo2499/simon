local Enums = require("scripts.enums")
local COOTIES = Enums.Items.COOTIES
local SFXManager = SFXManager()

local FEAR_FART_COLOR = Color(1, 1, 1, 1, 0.4, 0.0, 0.9)

function SimonCharacterMod:OnUseCooties(item, rng, player, useFlag, activeSlot)
    local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, 34, 0, player.Position, player.Velocity * 0, player):ToEffect()
    fart.Color = FEAR_FART_COLOR

    local radius = 96
    if player:HasTrinket(TrinketType.TRINKET_GIGANTE_BEAN) then
        radius = radius * 2
        SFXManager:Stop(SoundEffect.SOUND_FART)
        SFXManager:Play(SoundEffect.SOUND_FART, 1, 0, false, 0.5, 0)
        fart.SpriteScale = fart.SpriteScale * 2
    end

    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Position:Distance(player.Position) <= radius and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and entity:IsEnemy() then
            entity:AddFear(EntityRef(player), 83)
        end
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_USE_ITEM, SimonCharacterMod.OnUseCooties, COOTIES)
