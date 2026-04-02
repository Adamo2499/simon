local Enums = require("scripts.enums")
local GOSPEL_OF_JOHN = Enums.Items.GOSPEL_OF_JOHN
local isTransformedToLazarus = false
local previousCharacterType = nil

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param useFlag UseFlag
---@param activeSlot ActiveSlot
function SimonCharacterMod:OnUseGospelOfJohn(item, rng, player, useFlag, activeSlot)
    previousCharacterType = player:GetPlayerType()
    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
        player.Damage = player.Damage * 1.5
        player.TearRange = player.TearRange * 1.5
        player.FireDelay = player.FireDelay * 2
        player:EvaluateItems()
    elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        player:ChangePlayerType(PlayerType.PLAYER_LAZARUS)
    elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B then
        player.Damage = player.Damage * 1.5
        player.TearRange = player.TearRange * 1.5
        player.FireDelay = player.FireDelay * 2
        player:EvaluateItems()
    else
        player:ChangePlayerType(PlayerType.PLAYER_LAZARUS)
        isTransformedToLazarus = true
        if player:IsDead() and not player:WillPlayerRevive() then
            player:ChangePlayerType(PlayerType.PLAYER_LAZARUS2)
            player:Revive()
            player:AnimateCollectible(GOSPEL_OF_JOHN)
        end
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_USE_ITEM, SimonCharacterMod.OnUseGospelOfJohn, GOSPEL_OF_JOHN)

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
    local player = Isaac.GetPlayer(0)
    if isTransformedToLazarus and previousCharacterType ~= nil then
        player:ChangePlayerType(previousCharacterType)
        isTransformedToLazarus = false
    end
end)

---Setup max charges for Gospel of John depending of current character
---@param player EntityPlayer
function SimonCharacterMod:SetGospelOfJohnMaxCharges(player)
    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS or player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B then
        Isaac.GetItemConfig():GetCollectible(GOSPEL_OF_JOHN).MaxCharges = 12
    else
        Isaac.GetItemConfig():GetCollectible(GOSPEL_OF_JOHN).MaxCharges = 6
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, SimonCharacterMod.SetGospelOfJohnMaxCharges)
