local angelicRobes = Isaac.GetItemIdByName("Angelic Robes")

local damageMult = 1.5

---Calculate Angelic Robes damage multiplayer based of number of copies in Isaac's inventory
---@param player EntityPlayer
---@param cacheFlags any
function SimonCharacterMod:EvaluateDamageCache(player, cacheFlags)
    if player:HasCollectible(angelicRobes) then
        local itemCount = player:GetCollectibleNum(angelicRobes)
        local stackedDamageMult = damageMult * itemCount

        player.Damage = player.Damage * stackedDamageMult
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,SimonCharacterMod.EvaluateDamageCache,CacheFlag.CACHE_DAMAGE)

--------------------------------------------------------------------------------------------------

local rangeMult = 1.5

---Calculate Angelic Robes damage multiplayer based of number of copies in Isaac's inventory
---@param player EntityPlayer
---@param cacheFlags any
function SimonCharacterMod:EvaluateRangeCache(player, cacheFlags)
    if player:HasCollectible(angelicRobes) then
        local itemCount = player:GetCollectibleNum(angelicRobes)
        local stackedTearRangeMult = rangeMult * itemCount

        player.TearRange = player.TearRange * stackedTearRangeMult
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,SimonCharacterMod.EvaluateRangeCache,CacheFlag.CACHE_RANGE)

--------------------------------------------------------------------------------------------------

local fireRateMult = 0.7

---Calculate Angelic Robes damage multiplayer based of number of copies in Isaac's inventory
---@param player EntityPlayer
---@param cacheFlags any
function SimonCharacterMod:EvaluateFireRateCache(player, cacheFlags)
    if player:HasCollectible(angelicRobes) then
        local itemCount = player:GetCollectibleNum(angelicRobes)
        local stackedFireRateMult = fireRateMult * itemCount

        player.FireDelay = player.FireDelay * stackedFireRateMult
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,SimonCharacterMod.EvaluateFireRateCache,CacheFlag.CACHE_FIREDELAY)

--------------------------------------------------------------------------------------------------

---Make Isaac's tears spectral
---@param player EntityPlayer
---@param flag TearFlags
function SimonCharacterMod:OnEvaluateTearFlags(player, flag)
    if player:HasCollectible(angelicRobes) then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SimonCharacterMod.OnEvaluateTearFlags, CacheFlag.CACHE_TEARFLAG)

--------------------------------------------------------------------------------------------------

function SimonCharacterMod:GivePentashot(player)
    if REPENTOGON then
        player:GetMultiShotParams():SetNumTears(5)
    end
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SimonCharacterMod.GivePentashot, CacheFlag.CACHE_TEARFLAG)