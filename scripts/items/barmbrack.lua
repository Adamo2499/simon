local Enums = require("scripts.enums")
local BARMBRACK = Enums.Items.BARMBRACK
local currentLevel = Game():GetLevel()
local currentRoom = currentLevel:GetCurrentRoom()

---@param collectible CollectibleType
---@param charge integer
---@param firstTime boolean
---@param slot integer
---@param VarData integer
---@param player EntityPlayer
function SimonCharacterMod:SpawnRandomComsumableUponPickup(collectible, charge, firstTime, slot, VarData, player)
    if firstTime and collectible == BARMBRACK then
        local spawningPos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, spawningPos, Vector.Zero, player)

        player:AddMaxHearts(2, true)
        if player:GetEffectiveMaxHearts() >= 1 then
            player:AddHearts(2)
        else
            player:AddSoulHearts(2)
        end
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, SimonCharacterMod.SpawnRandomComsumableUponPickup)

function SimonCharacterMod:AddBonusDevilAngelChance()
    local player = PlayerManager.FirstCollectibleOwner(BARMBRACK, false)
    if player then
        local currentDevilRoomChance = math.min(currentRoom:GetDevilRoomChance(), 1.0)
        local currentAngelRoomChance = currentLevel:GetAngelRoomChance()
        local BARMBRACK_DEAL_CHANCE_BONUS = 0.05 -- 5% deal increase

        if currentDevilRoomChance > 0.0 and currentAngelRoomChance == 0.0 then
            currentDevilRoomChance = currentDevilRoomChance + BARMBRACK_DEAL_CHANCE_BONUS
        elseif currentDevilRoomChance == 0.0 and currentAngelRoomChance > 0.0  then
            currentAngelRoomChance = currentAngelRoomChance + BARMBRACK_DEAL_CHANCE_BONUS
        elseif currentDevilRoomChance > 0.0 and currentAngelRoomChance > 0.0 then
            currentDevilRoomChance = currentDevilRoomChance + (BARMBRACK_DEAL_CHANCE_BONUS / 2)
            currentAngelRoomChance = currentAngelRoomChance + (BARMBRACK_DEAL_CHANCE_BONUS / 2)
        end

        return currentDevilRoomChance
    end

end

SimonCharacterMod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, SimonCharacterMod.AddBonusDevilAngelChance)