local Enums = require("scripts.enums")
local BISHOPS_ROBES = Enums.Items.BISHOPS_ROBES

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = PlayerManager.FirstCollectibleOwner(BISHOPS_ROBES, false)
    if player ~= nil then
        local bishopRobesRNG = player:GetCollectibleRNG(BISHOPS_ROBES)
        local roomEntities = Isaac.GetRoomEntities()
        local baitedEnemyID = bishopRobesRNG:RandomInt(1, #roomEntities)
        local enemyToBait = roomEntities[baitedEnemyID]
        if
            enemyToBait:IsActiveEnemy()
            and enemyToBait:IsVulnerableEnemy()
            and enemyToBait:IsEnemy()
            and not enemyToBait:IsBoss()
        then
            enemyToBait:AddBaited(EntityRef(nil), 3000)
        end
    end
end)
