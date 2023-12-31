-- Variables --
---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

---@class Categories: AceModule
local categories = addon:GetModule('Categories')

---@class Localization: AceModule
local L = addon:GetModule('Localization')

-- Get the player's class
local className, classFilename, classId = UnitClass("player")

local HEAD = "INVTYPE_HEAD"
local SHOULDER = "INVTYPE_SHOULDER"
local BODY = "INVTYPE_BODY"
local CHEST = "INVTYPE_CHEST"
local ROBE = "INVTYPE_ROBE"
local WAIST = "INVTYPE_WAIST"
local LEGS = "INVTYPE_LEGS"
local FEET = "INVTYPE_FEET"
local WRIST = "INVTYPE_WRIST"
local HAND = "INVTYPE_HAND"
local CLOAK = "INVTYPE_CLOAK"
local WEAPON = "INVTYPE_WEAPON"
local SHIELD = "INVTYPE_SHIELD"
local WEAPON_2HAND = "INVTYPE_2HWEAPON"
local WEAPON_MAIN_HAND = "INVTYPE_WEAPONMAINHAND"
local RANGED = "INVTYPE_RANGED"
local RANGED_RIGHT = "INVTYPE_RANGEDRIGHT"
local WEAPON_OFF_HAND = "INVTYPE_WEAPONOFFHAND"
local HOLDABLE = "INVTYPE_HOLDABLE"
local TABARD = "INVTYPE_TABARD"
local BAG = "INVTYPE_BAG"
local PROFESSION_TOOL = "INVTYPE_PROFESSION_TOOL"
local RING = "INVTYPE_FINGER"
local TRINKET = "INVTYPE_TRINKET"
local NECK = "INVTYPE_NECK"

local MISC = "MISCELLANEOUS"
local CLOTH = "CLOTH"
local LEATHER = "LEATHER"
local MAIL = "MAIL"
local PLATE = "PLATE"
local COSMETIC = "COSMETIC"

local classArmorTypeMap = {
    ["DEATHKNIGHT"] = PLATE,
    ["DEMONHUNTER"] = LEATHER,
    ["DRUID"] = LEATHER,
    ["EVOKER"] = MAIL,
    ["HUNTER"] = MAIL,
    ["MAGE"] = CLOTH,
    ["MONK"] = LEATHER,
    ["PALADIN"] = PLATE,
    ["PRIEST"] = CLOTH,
    ["ROGUE"] = LEATHER,
    ["SHAMAN"] = MAIL,
    ["WARLOCK"] = CLOTH,
    ["WARRIOR"] = PLATE,
}

function isKnown(itemID)
    return C_TransmogCollection.PlayerHasTransmog(itemID)
end

function isUsableByCurrentClass(data)
    local itemType = string.upper(data.itemInfo.itemSubType)
    if classArmorTypeMap[classFilename] == itemType or itemType == COSMETIC or itemType == MISC then
        return true
    end
    return false
end

local function printTable(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            printTable(v, indent+1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))      
        else
            print(formatting .. v)
        end
    end
end

categories:RegisterCategoryFunction("SetAppearanceItemCategories", function (data)
    if data.itemInfo.itemEquipLoc ~= "" then
        -- Guard clauses
        if data.itemInfo.itemEquipLoc == PROFESSION_TOOL or data.itemInfo.itemEquipLoc == BAG or data.itemInfo.itemEquipLoc == RING or data.itemInfo.itemEquipLoc == TRINKET or data.itemInfo.itemEquipLoc == NECK then
            return nil
        end

        --printTable(data)
        
        if isKnown(data.itemInfo.itemID) then 
            return L:G("Known Appearances")
        end
        -- End of guard clauses

        if isUsableByCurrentClass(data) then
            return L:G(className .. " Items")
        else
            return L:G("Not Usable by " .. className)
        end
    end
    return nil
end)