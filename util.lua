---@class UITweaks
local UI = select(2, ...)

UI.media = {
    font = {
        base = [[Interface\AddOns\ExalityUITweaks\fonts\bahnschrift.ttf]]
    }
}

local MyScanningTooltip = CreateFrame("GameTooltip", "ExalityUIScanningTooltip", UIParent, "GameTooltipTemplate")

function MyScanningTooltip.ClearTooltip(self)
    local TooltipName = self:GetName()
    self:ClearLines()
    for i = 1, 10 do
        _G[TooltipName .. "Texture" .. i]:SetTexture(nil)
        _G[TooltipName .. "Texture" .. i]:ClearAllPoints()
        _G[TooltipName .. "Texture" .. i]:SetPoint("TOPLEFT", self)
    end
end

UI.const = {
    ilvlColors = {
        -- Dragonflight --
        { ilvl = 530, str = "ff26ff3f" },
        { ilvl = 540, str = "ff26ffba" },
        { ilvl = 550, str = "ff26e2ff" },
        { ilvl = 560, str = "ff26a0ff" },
        { ilvl = 570, str = "ff2663ff" },
        { ilvl = 580, str = "ff8e26ff" },
        { ilvl = 590, str = "ffe226ff" },
        { ilvl = 600, str = "ffff2696" },
        { ilvl = 610, str = "ffff2634" },
        { ilvl = 620, str = "ffff7526" },
        { ilvl = 630, str = "ffffc526" }
    },
    texture = {
        charBg = [[Interface\AddOns\ExalityUITweaks\textures\charbg.png]]
    }
}

UI.util = {
    GetItemEnchant = function(itemLink)
        MyScanningTooltip:ClearTooltip()
        MyScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        MyScanningTooltip:SetHyperlink(itemLink)
        local enchantKey = ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)")
        for i = 1, MyScanningTooltip:NumLines() do
            if
                _G["ExalityUIScanningTooltipTextLeft" .. i]:GetText() and
                _G["ExalityUIScanningTooltipTextLeft" .. i]:GetText():match(enchantKey)
            then
                -- name,id
                local name = _G["ExalityUIScanningTooltipTextLeft" .. i]:GetText()
                name = name:match("^%w+: (.*)")
                local _, _, enchantId = strsplit(":", itemLink)
                return name, enchantId
            end
        end
    end,
    GetItemGems = function(itemLink)
        local t = {}
        for i = 1, MAX_NUM_SOCKETS do
            local name, iLink = C_Item.GetItemGem(itemLink, i)
            if iLink then
                local icon = select(10, C_Item.GetItemInfo(iLink))
                table.insert(t, { name = name, icon = icon })
            end
        end
        MyScanningTooltip:ClearTooltip()
        MyScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        MyScanningTooltip:SetHyperlink(itemLink)
        for i = 1, MAX_NUM_SOCKETS do
            local tex = _G["ExalityUIScanningTooltipTexture" .. i]:GetTexture()
            if tex then
                tex = tostring(tex)
                if tex == '458977' then
                    table.insert(
                        t,
                        {
                            name = "Empty Slot",
                            icon = tex
                        }
                    )
                end
            end
        end
        return t
    end,
    isEmpty = function(t)
        for _ in pairs(t) do
            return false
        end
        return true
    end,
    spairs = function(t, order)
        -- collect the keys
        local keys = {}
        for k in pairs(t) do
            keys[#keys + 1] = k
        end

        -- if order function given, sort by it by passing the table and keys a, b,
        -- otherwise just sort the keys
        if order then
            table.sort(
                keys,
                function(a, b)
                    return order(t, a, b)
                end
            )
        else
            table.sort(keys)
        end

        -- return the iterator function
        local i = 0
        return function()
            i = i + 1
            if keys[i] then
                return keys[i], t[keys[i]]
            end
        end
    end,
    addObserver = function(t, force)
        if (t.observable and not force) then
            return t
        end

        t.observable = {}
        t.Observe = function(_, key, onChangeFunc)
            if (type(key) == 'table') then
                for _, k in ipairs(key) do
                    t.observable[k] = t.observable[k] or {}
                    table.insert(t.observable[k], onChangeFunc)
                end
            else
                t.observable[key] = t.observable[key] or {}
                table.insert(t.observable[key], onChangeFunc)
            end
        end
        t.SetValue = function(_, key, value)
            local oldValue = t[key]
            t[key] = value
            if (t.observable[key]) then
                for _, func in ipairs(t.observable[key]) do
                    func(value, oldValue)
                end
            end
        end

        return t
    end,
    createSimpleText = function(textValue, size, textAlign, parent, maxwidth)
        local frame = CreateFrame('Frame')
        frame:SetSize(1, 1)
        local text = frame:CreateFontString(nil, 'OVERLAY')
        text:SetWidth(maxwidth or 0)
        text:SetJustifyH(textAlign or 'LEFT')
        text:SetFont(UI.media.font.base, size or 12, 'OUTLINE')
        text:SetPoint(textAlign or 'LEFT')
        if (textValue) then
            text:SetText(textValue)
        end
        frame.SetText = function(self, value)
            text:SetText(value)
        end
        if (parent) then
            frame:SetParent(parent)
        end
        return frame
    end,
    ---@param frame FRAME
    addDebugTexture = function(frame)
        local tex = frame:CreateTexture(nil, 'OVERLAY')
        tex:SetTexture([[Interface\Buttons\WHITE8x8]])
        tex:SetVertexColor(1, 0, 0, 1)
        tex:SetAllPoints()
    end,
    getIlvlColor = function(ilvl)
        if not ilvl then
            return "ffffffff"
        end
        local colors = UI.const.ilvlColors
        for i = 1, #colors do
            if colors[i].ilvl > ilvl then
                return colors[i].str
            end
        end
        return "fffffb26"
    end
}
