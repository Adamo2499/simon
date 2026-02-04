local SimonCharacterMod = RegisterMod("Simon Character Mod",1)

local simonPlayerType = Isaac.GetPlayerTypeByName("Simon", false)

local SIMON_ACHIEVEMENT = Isaac.GetAchievementIdByName("Simon")
local persistGameData = Isaac.GetPersistentGameData()
local SHOULD_BLOCK_POPUP = false

---@param player EntityPlayer
function SimonCharacterMod:UnlockSimon(player)
    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        if not persistGameData:Unlocked(SIMON_ACHIEVEMENT) then
            persistGameData:TryUnlock(SIMON_ACHIEVEMENT, SHOULD_BLOCK_POPUP)
        end
    end
end
SimonCharacterMod:AddCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES, SimonCharacterMod.UnlockSimon)