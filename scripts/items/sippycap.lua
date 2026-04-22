local Enums = require("scripts.enums")
local SIPPY_CAP = Enums.Items.SIPPY_CAP
local sippyCapUsed = false
local SOY_MILK_ID = CollectibleType.COLLECTIBLE_SOY_MILK
local ALMOND_MILK_ID = CollectibleType.COLLECTIBLE_ALMOND_MILK
local CHOCOLATE_MILK_ID = CollectibleType.COLLECTIBLE_CHOCOLATE_MILK
local milkVariants = { SOY_MILK_ID, ALMOND_MILK_ID, CHOCOLATE_MILK_ID }
local alreadyHaveMilkCollectibles = {
    [SOY_MILK_ID] = false,
    [ALMOND_MILK_ID] = false,
    [CHOCOLATE_MILK_ID] = false
}

---comment
---@param itemType CollectibleType
---@param charge integer
---@param firstTime boolean
---@param slot SlotVariant
---@param varData integer
---@param player EntityPlayer
function SimonCharacterMod:OnPreUseSippyCap(itemType, charge, firstTime, slot, varData, player)
    -- Check if player already have Soy / Almond / Chocolate Milk before it was added by Sippy Cap
    alreadyHaveMilkCollectibles[SOY_MILK_ID] = player:HasCollectible(SOY_MILK_ID)
    alreadyHaveMilkCollectibles[ALMOND_MILK_ID] = player:HasCollectible(ALMOND_MILK_ID)
    alreadyHaveMilkCollectibles[CHOCOLATE_MILK_ID] = player:HasCollectible(CHOCOLATE_MILK_ID)
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, SimonCharacterMod.OnPreUseSippyCap, SIPPY_CAP)

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param useFlag UseFlag
---@param activeSlot ActiveSlot
function SimonCharacterMod:OnUseSippyCap(item, rng, player, useFlag, activeSlot)
    sippyCapUsed = true
    for id, value in ipairs(alreadyHaveMilkCollectibles) do
        print("Already had item with ID: " .. tostring(id) .. "?: " .. tostring(value))
    end
    -- Add randomly chosen milk item
    local selectedMilkVariant = milkVariants[rng:RandomInt(1, #milkVariants)]
    player:AddCollectible(selectedMilkVariant)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

SimonCharacterMod:AddCallback(ModCallbacks.MC_USE_ITEM, SimonCharacterMod.OnUseSippyCap, SIPPY_CAP)

SimonCharacterMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    if sippyCapUsed then
        for _, milkID in pairs(milkVariants) do
            local milkCount = player:GetCollectibleNum(milkID)
            for i = 1, milkCount, 1 do
                player:RemoveCollectible(milkID)
            end
            if alreadyHaveMilkCollectibles[milkID] then
                player:AddCollectible(milkID)
            end
        end
        sippyCapUsed = false
    end
end)
