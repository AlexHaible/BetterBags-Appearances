-- Variables --
---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

---@class Categories: AceModule
local categories = addon:GetModule('Categories')

---@class Localization: AceModule
local L = addon:GetModule('Localization')

-- Get the player's class
local className, classFilename, classId = UnitClass("player")
-- End of Variables --

-- Functions --
-- Function to check if the item is transmoggable
local function IsItemTransmoggable(itemData)
    if not itemData or not itemData.itemID then
        return false
    end

    -- Use the C_Transmog.CanTransmogItem API to check if the item can be transmogged.
    local canBeTransmogged = C_Transmog.CanTransmogItem(itemData.itemID)

    return canBeTransmogged
end

-- Function to check if the item is for the player's class
local function IsItemForMyClass(itemData)
    if not itemData or not itemData.itemLink then
        return false
    end

    -- Get the sourceID from the item link
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemData.itemLink))

    -- Check if the player can collect this item's appearance
    local hasItemData, canCollect = C_TransmogCollection.PlayerCanCollectSource(sourceID)
    return hasItemData and canCollect
end

-- Function to check if the item's appearance is unknown
local function IsAppearanceUnknown(itemData)
    if not itemData or not itemData.itemLink then
        return false
    end

    -- Get the sourceID from the item link
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemData.itemLink))

    -- Check if the player has the transmog for this item
    local hasTransmog = C_TransmogCollection.PlayerHasTransmogItem(sourceID)

    -- Return true if the appearance is unknown, false otherwise
    return not hasTransmog
end

-- Function to generate category name for items suitable for the player's class
local function GetMyClassCategoryName()
    return L:G(className .. " Items")
end

-- Function to check if the item is equippable
local function IsItemEquippable(itemData)
    -- Check if itemEquipLoc is present and non-empty
    if itemData and itemData.itemEquipLoc and itemData.itemEquipLoc ~= "" then
        return true
    end
    return false
end
-- End of Functions --

-- Category Functions --
-- First Category: Suitable for my class and appearance unknown
categories:RegisterCategoryFunction("ItemsForMyClass", function (data)
    -- Output to console the item data
    print("Item Data: " .. data.itemLink .. " " .. data.itemEquipLoc)

    if IsItemEquippable(data) and IsItemTransmoggable(data) and IsItemForMyClass(data) and IsAppearanceUnknown(data) then
        return GetMyClassCategoryName()
    end
    return nil
end)

-- Second Category: Not suitable for my class but appearance unknown
categories:RegisterCategoryFunction("ItemsForOtherClasses", function (data)
    -- Output to console the item data
    print("Item Data: " .. data.itemLink .. " " .. data.itemEquipLoc)
    if IsItemEquippable(data) and IsItemTransmoggable(data) and not IsItemForMyClass(data) and IsAppearanceUnknown(data) then
        return L:G("Items for Other Classes")
    end
    return nil
end)

-- Third Category: Appearance already known
categories:RegisterCategoryFunction("SafeForSelling", function (data)
    -- Output to console the item data
    print("Item Data: " .. data.itemLink .. " " .. data.itemEquipLoc)
    if IsItemEquippable(data) and IsItemTransmoggable(data) and not IsAppearanceUnknown(data) then
        return L:G("Safe for Selling")
    end
    return nil
end)
-- End of Category Functions --

-- Debugging --
categories:AddItemToCategory(54441, L:G("Debugging"))