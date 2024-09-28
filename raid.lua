---@class UITweaks
local UI = select(2, ...)

---@class Raid
local raid = UI:GetModule('raid')


raid.Init = function(self)
    hooksecurefunc("CompactRaidGroup_GenerateForGroup", function(groupIndex)
        local frame = _G["CompactRaidGroup" .. groupIndex]
        if frame then
            frame.title:SetText("")
            frame.title:SetHeight(0)
        end
    end)
    print('hook')
    hooksecurefunc("CompactPartyFrame_Generate", function()
        local frame = _G["CompactPartyFrame"]
        if frame then
            frame.title:SetText("")
            frame.title:SetHeight(0)
        end
    end)

    local frame = _G["CompactPartyFrame"]
    if frame then
        frame.title:SetText("")
        frame.title:SetHeight(0)
    end
end
