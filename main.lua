local SimonCharacterMod = RegisterMod("Simon Character Mod",1)

local simonPlayerType = Isaac.GetPlayerTypeByName("Simon", false)
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/simon_hair.anm2")

---Add costumes on init for Simon
---@param player EntityPlayer
function SimonCharacterMod:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= simonPlayerType then
        return
    end

    player:AddNullCostume(hairCostume)
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, SimonCharacterMod.GiveCostumesOnInit)