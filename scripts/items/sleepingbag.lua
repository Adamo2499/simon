local Enums = require("scripts.enums")
local SLEEPING_BAG = Enums.Items.SLEEPING_BAG

---@param player EntityPlayer
local function fullHealCurrentPlayer(player)
    if player:GetEffectiveMaxHearts() >= 1 then
        player:AddHearts(player:GetEffectiveMaxHearts())
    else
        player:AddSoulHearts(6)
    end
end

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param useFlag UseFlag
---@param activeSlot ActiveSlot
function SimonCharacterMod:OnUseSleepingBag(item, rng, player, useFlag, activeSlot)
    -- Judas Birthright synergy
    if player:GetPlayerType() == PlayerType.PLAYER_JUDAS or
        player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS and
        player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        if player:GetEffectiveMaxHearts() >= 1 then
            local extraDamage = player:GetEffectiveMaxHearts() - player:GetHearts()
            player.Damage = player.Damage + extraDamage
            player:AddHearts(player:GetEffectiveMaxHearts())
        else
            player:AddBlackHearts(6)
            player.Damage = player.Damage + 6
        end
        -- Bethany synergy
    elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY then
        player:AddSoulCharge(12)
        -- Tainted Bethany synergy
    elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
        player:AddBloodCharge(12)
    end

    -- Only call fullHeal if player doesn't have Birthright OR isn't Judas/Black Judas with Birthright
    if not (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 
            (player:GetPlayerType() == PlayerType.PLAYER_JUDAS or player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS)) then
        fullHealCurrentPlayer(player)
    end
  
    return { Discharge = false, ShowAnim = true, Remove = true }
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_USE_ITEM, SimonCharacterMod.OnUseSleepingBag, SLEEPING_BAG)
-- SimonCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SimonCharacterMod.OnUseSleepingBag, CacheFlag.CACHE_DAMAGE)