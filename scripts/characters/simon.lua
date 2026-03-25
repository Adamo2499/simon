local Enums = require("scripts.enums")
local SIMON_PLAYER_TYPE = Enums.Characters.SIMON
local game = Game()
local persistentGameData = Isaac.GetPersistentGameData()

local SHOULD_BLOCK_POPUP = false

local SIMON_ACHIEVEMENT = Isaac.GetAchievementIdByName("Simon")

---Unlock Simon as playable character
---@param player EntityPlayer
function SimonCharacterMod:UnlockSimon(player)
    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        if not persistentGameData:Unlocked(SIMON_ACHIEVEMENT) then
            persistentGameData:TryUnlock(SIMON_ACHIEVEMENT, SHOULD_BLOCK_POPUP)
        end
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES, SimonCharacterMod.UnlockSimon)

--------------------------------------------------------------------------------------------------

local SIMON_HOLDS_LOST_CORK_ACHIEVEMENT = Isaac.GetAchievementIdByName("Simon holds Lost Cork")
local SIMON_LOST_CORK_GREED_DONATION_MACHINE_REQUIREMENT = 705

--- Unlock Lost Cork for Simon
function SimonCharacterMod:UnlockLostCorkForSimon()
    if persistentGameData:GetEventCounter(EventCounter.GREED_DONATION_MACHINE_COUNTER) >= SIMON_LOST_CORK_GREED_DONATION_MACHINE_REQUIREMENT then
        if not persistentGameData:Unlocked(SIMON_HOLDS_LOST_CORK_ACHIEVEMENT) then
            persistentGameData:TryUnlock(SIMON_HOLDS_LOST_CORK_ACHIEVEMENT, SHOULD_BLOCK_POPUP)
        end
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, SimonCharacterMod.UnlockLostCorkForSimon)
SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, SimonCharacterMod.UnlockLostCorkForSimon,
    SlotVariant.GREED_DONATION_MACHINE)

--------------------------------------------------------------------------------------------------

local simonHairCostume = Isaac.GetCostumeIdByPath("gfx/characters/simon_hair.anm2")

---Give starting stuff to Simon
---@param player EntityPlayer
function SimonCharacterMod:InitSimon(player)
    if player:GetPlayerType() ~= SIMON_PLAYER_TYPE then
        return
    end

    -- Give hair to Simon
    if simonHairCostume ~= nil then
        player:AddNullCostume(simonHairCostume)
    end

    -- Add Leprosy as Simon's innate item
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LEPROSY)

    -- Give Lost Cork to Simon, if it's unlocked
    if not persistentGameData:Unlocked(SIMON_HOLDS_LOST_CORK_ACHIEVEMENT) then
        return
    end

    player:AddSmeltedTrinket(TrinketType.TRINKET_LOST_CORK)

    -- Add Unique Progress Bar compability
    uniqueprogressbar = true
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, SimonCharacterMod.InitSimon)

--------------------------------------------------------------------------------------------------

---TODO: Describe me!
---@param player EntityPlayer
function SimonCharacterMod:HandleSimonCreep(player)
    if player:GetPlayerType() ~= SIMON_PLAYER_TYPE then
        return
    end

    if game:GetFrameCount() % 10 == 0 then
        local redCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position,
            Vector.Zero, player):ToEffect()
        local soulCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0,
            player.Position, Vector.Zero, player):ToEffect()
        local blackCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, player.Position,
            Vector.Zero, player):ToEffect()
        local whiteCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, player.Position,
            Vector.Zero, player):ToEffect()
        --local yellowCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 0, player.Position, Vector.Zero, player):ToEffect()
        local greenCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, player.Position,
            Vector.Zero, player):ToEffect()
        local creepVariants = { redCreep, soulCreep, blackCreep, whiteCreep, greenCreep }
        local currentCreepVariant = creepVariants[math.random(#creepVariants)]
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            currentCreepVariant.SpriteScale = Vector(1, 1)
        else
            currentCreepVariant.SpriteScale = Vector(0.5, 0.5)
        end
        currentCreepVariant:Update()
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SimonCharacterMod.HandleSimonCreep)

--------------------------------------------------------------------------------------------------

---Code resonsible for Birthright effect for Simon
---@param player EntityPlayer
function SimonCharacterMod:HandleSimonBirthright(player)
    if player:GetPlayerType() ~= SIMON_PLAYER_TYPE or not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        return
    end

    player:SetD8DamageModifier(1.5)
    player:SetD8SpeedModifier(0.8)
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SimonCharacterMod.HandleSimonBirthright)


--------------------------------------------------------------------------------------------------
---@param player EntityPlayer
function SimonCharacterMod:ReAddInnateLeprosy(player)
    if player:GetPlayerType() ~= SIMON_PLAYER_TYPE then
        return
    end
    local playerWisps = player:GetWispCollectiblesList()
    for _, value in ipairs(playerWisps) do
        if value == CollectibleType.COLLECTIBLE_LEPROSY then
            return
        end
    end
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LEPROSY)
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, SimonCharacterMod.ReAddInnateLeprosy)

--------------------------------------------------------------------------------------------------

SimonCharacterMod:AddCallback(ModCallbacks.MC_PRE_COMPLETION_EVENT, function(_, mark)
    local players = PlayerManager.GetPlayers()
    for _, player in ipairs(players) do
        if player:GetPlayerType() == SIMON_PLAYER_TYPE and not player.Parent then
            local marks = {
                [CompletionType.MOMS_HEART] = Enums.Achievements.COOTIES,
                [CompletionType.ULTRA_GREED] = Enums.Achievements.LIGMA,
                [CompletionType.ULTRA_GREEDIER] = Enums.Achievements.SLEEPING_BAG,
                [CompletionType.BOSS_RUSH] = Enums.Achievements.DOPAMINE,
                [CompletionType.HUSH] = Enums.Achievements.FLEX_SEAL,
                [CompletionType.ISAAC] = Enums.Achievements.GOSPEL_OF_JOHN,
                [CompletionType.BLUE_BABY] = Enums.Achievements.BARMBRACK,
                [CompletionType.SATAN] = Enums.Achievements.FALSE_IDOL,
                [CompletionType.LAMB] = Enums.Achievements.SCRATCHING_POLE,
                [CompletionType.MEGA_SATAN] = Enums.Achievements.GOAT_MILK,
                [CompletionType.DELIRIUM] = Enums.Achievements.IV_POLE,
                [CompletionType.MOTHER] = Enums.Achievements.ISOPROPANOL,
                [CompletionType.BEAST] = Enums.Achievements.HANAHAKI,
            }
            if mark == CompletionType.ULTRA_GREEDIER then -- make damn sure greedier unlocks greed too
                SimonCharacterMod.UnlockAchievement(marks[CompletionType.ULTRA_GREED])
            end
            if marks[mark] then
                SimonCharacterMod.UnlockAchievement(marks[mark])
            end
            if Isaac.AllMarksFilled(player:GetPlayerType()) == 2 then
                SimonCharacterMod.UnlockAchievement(Enums.Achievements.BISHOPS_ROBES)
            end
        end
    end
end)

function SimonCharacterMod.UnlockAchievement(unlock)
    local pgd = Isaac.GetPersistentGameData()
    if not game:AchievementUnlocksDisallowed() then
        if not pgd:Unlocked(unlock) then
            pgd:TryUnlock(unlock)
        end
    end
end
