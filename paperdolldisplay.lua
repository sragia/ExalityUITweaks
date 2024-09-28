---@class UITweaks
local UI = select(2, ...)

---@class Paperdoll
local paperdoll = UI:GetModule('paperdoll')

paperdoll.gearMap = {
    {
        -- Head
        frameName = 'CharacterHeadSlot',
        slotId = 1,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        gemAlign = 'LEFT',
        maxWidth = 100,
        offsetX = 10,
        offsetY = 8
    },
    {
        -- Neck
        frameName = 'CharacterNeckSlot',
        slotId = 2,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        gemAlign = 'LEFT',
        maxWidth = 100,
        offsetX = 10,
        offsetY = 8
    },
    {
        -- Shoulders
        frameName = 'CharacterShoulderSlot',
        slotId = 3,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        gemAlign = 'LEFT',
        offsetX = 10,
        maxWidth = 100,
        offsetY = 8
    },
    {
        -- Cloak
        frameName = 'CharacterBackSlot',
        slotId = 15,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        gemAlign = 'LEFT',
        maxWidth = 100,
        offsetX = 10,
        offsetY = 8
    },
    {
        -- Chest
        frameName = 'CharacterChestSlot',
        slotId = 5,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        gemAlign = 'LEFT',
        maxWidth = 100,
        offsetX = 10,
        offsetY = 8
    },
    {
        -- Wrist
        frameName = 'CharacterWristSlot',
        slotId = 9,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        gemAlign = 'LEFT',
        maxWidth = 100,
        offsetX = 10,
        offsetY = 8
    },
    {
        -- Hands
        frameName = 'CharacterHandsSlot',
        slotId = 10,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Waist
        frameName = 'CharacterWaistSlot',
        slotId = 6,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Legs
        frameName = 'CharacterLegsSlot',
        slotId = 7,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Feet
        frameName = 'CharacterFeetSlot',
        slotId = 8,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Ring 1
        frameName = 'CharacterFinger0Slot',
        slotId = 11,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Ring 2
        frameName = 'CharacterFinger1Slot',
        slotId = 12,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Trinket 1
        frameName = 'CharacterTrinket0Slot',
        slotId = 13,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Trinket 2
        frameName = 'CharacterTrinket1Slot',
        slotId = 14,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        textAlign = 'RIGHT',
        maxWidth = 100,
        gemAlign = 'RIGHT',
        offsetX = -10,
        offsetY = 8
    },
    {
        -- Weapon 1
        frameName = 'CharacterMainHandSlot',
        slotId = 16,
        point = 'BOTTOMRIGHT',
        relativePoint = 'BOTTOMLEFT',
        gemAlign = 'RIGHT',
        textAlign = 'RIGHT',
        maxWidth = 150,
        offsetX = -10,
        offsetY = 4
    },
    {
        -- Weapon 2
        frameName = 'CharacterSecondaryHandSlot',
        slotId = 17,
        point = 'BOTTOMLEFT',
        relativePoint = 'BOTTOMRIGHT',
        maxWidth = 150,
        gemAlign = 'LEFT',
        offsetX = 10,
        offsetY = 4
    },
}

local replacements = {
    ['Critical Strike'] = 'Crit',
    ["Agility"] = 'Agi',
    ['Stamina'] = 'Stam',
    ['Strength'] = 'Str',
    ['Versatility'] = 'Vers',
    ['Waking Stats'] = 'Stats',
    ['Armor'] = 'Arm',
    ['Avoidance'] = 'Avoid',
    ['Shadowflame Wreathe'] = 'Shadowflame',
    ['Regenerative Leech'] = 'Leech',
    ['Authority of the Depths'] = 'Depths',
    ["Scout's March"] = 'Speed',
    ['Chant of Winged Grace'] = 'Avoid',
    ['Crystalline Radiance'] = 'Primary Stat'
}

paperdoll.Init = function(self)
    self:Refresh()
    UI.handler:RegisterCallback({ 'PLAYER_EQUIPMENT_CHANGED', 'PLAYER_ENTERING_WORLD', 'ENCHANT_SPELL_COMPLETED' },
        'paperdoll', function()
            C_Timer.After(1, function() paperdoll:Refresh() end)
            paperdoll:Refresh()
        end)
    hooksecurefunc(CharacterFrame, 'Show', function() paperdoll:Refresh() end)
    hooksecurefunc("PaperDollFrame_SetItemLevel", function() paperdoll:Refresh() end)
end

paperdoll.Refresh = function(self)
    C_Timer.After(0.1, function() paperdoll:ModifyLayout() end)
    for _, gearSlot in ipairs(self.gearMap) do
        if (not gearSlot.frame) then
            local baseFrame = CreateFrame('Frame', nil, _G[gearSlot.frameName])
            baseFrame:SetSize(1, 1)
            baseFrame:SetPoint(
                gearSlot.point,
                _G[gearSlot.frameName],
                gearSlot.relativePoint,
                gearSlot.offsetX,
                gearSlot.offsetY
            )
            local ilvlText = UI.util.createSimpleText('', 12, 'CENTER', baseFrame)
            local enchantText = UI.util.createSimpleText('', 10, gearSlot.textAlign, baseFrame, gearSlot.maxWidth)
            local gemText = UI.util.createSimpleText('', 12, gearSlot.textAlign, baseFrame)
            ilvlText:SetPoint('BOTTOM', _G[gearSlot.frameName], 0, 3)
            enchantText:SetPoint('BOTTOMLEFT')
            gemText:SetPoint(
                gearSlot.gemAlign == 'LEFT' and 'BOTTOMLEFT' or 'BOTTOMRIGHT',
                enchantText,
                gearSlot.gemAlign == 'LEFT' and 'TOPLEFT' or 'TOPRIGHT',
                0,
                12
            )

            baseFrame.SetIlvlText = function(self, ilvl)
                if (not ilvl) then
                    ilvlText:SetText('')
                    return
                end
                ilvlText:SetText(WrapTextInColorCode(ilvl, UI.util.getIlvlColor(ilvl)))
            end
            baseFrame.SetEnchant = function(self, enchant)
                if (not enchant) then
                    enchantText:SetText('')
                    return
                end
                enchantText:SetText(WrapTextInColorCode(enchant, 'ff98f907'))
            end
            baseFrame.SetGem = function(self, gem)
                gemText:SetText(gem or '')
            end

            gearSlot.frame = baseFrame
        end

        local iLink = GetInventoryItemLink("player", gearSlot.slotId)
        if iLink then
            local ilvl = C_Item.GetDetailedItemLevelInfo(iLink)
            gearSlot.frame:SetIlvlText(ilvl)
            local enchant = UI.util.GetItemEnchant(iLink)
            if (enchant) then
                for pattern, replacement in pairs(replacements) do
                    enchant = string.gsub(enchant, pattern, replacement)
                end
            end
            gearSlot.frame:SetEnchant(enchant and string.gsub(enchant, '|A.-|a', ''))
            gearSlot.frame:SetGem(self:GetGemString(iLink))
        else
            gearSlot.frame:SetIlvlText()
            gearSlot.frame:SetEnchant()
            gearSlot.frame:SetGem()
        end
    end

    local avgIlvl, avgEquipped = GetAverageItemLevel()
    local ilvlString = string.format('%.2f', avgEquipped)
    if (avgIlvl ~= avgEquipped) then
        ilvlString = string.format('%.2f / %.2f', avgEquipped, avgIlvl)
    end
    PaperDollFrame_SetLabelAndText(CharacterStatsPane.ItemLevelFrame, STAT_AVERAGE_ITEM_LEVEL, ilvlString, false, avgIlvl)
end

paperdoll.ModifyLayout = function(self)
    CharacterFrame:SetWidth(700)
    CharacterFrameInset:SetPoint('BOTTOMRIGHT', CharacterFrame, 'BOTTOMLEFT', 498, 4)
    CharacterModelScene:SetWidth(439)
    CharacterModelFrameBackgroundTopLeft:SetWidth(396)
    CharacterModelFrameBackgroundTopLeft:SetHeight(320)
    CharacterModelFrameBackgroundTopLeft:SetTexture(UI.const.texture.charBg)
    CharacterModelFrameBackgroundTopLeft:SetDesaturation(0)
    CharacterModelFrameBackgroundBotLeft:Hide()
    CharacterModelFrameBackgroundOverlay:Hide()
    CharacterModelFrameBackgroundBotRight:Hide()
    if (CharacterModelScene and CharacterModelScene:GetActiveCamera()) then
        CharacterModelScene:GetActiveCamera():SetMaxZoomDistance(5.5)
    end
    CharacterMainHandSlot:SetPoint('BOTTOMLEFT', 234, 16)
end

paperdoll.GetGemString = function(self, itemLink)
    local gems = UI.util.GetItemGems(itemLink)
    local s = ''
    if (gems) then
        for _, gem in ipairs(gems) do
            s = s .. string.format('|T%s:0|t ', gem.icon)
        end
    end
    return s
end
