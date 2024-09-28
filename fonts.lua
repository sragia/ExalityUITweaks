---@class UITweaks
local UI = select(2, ...)

---@class Fonts
local fonts = UI:GetModule('fonts')

fonts.replace = {
    ['SystemFont_NamePlate'] = {
        size = 8,
        colors = { 1, 1, 1 }
    },
    ['Game15Font_o1'] = {
        size = 18,
    }
}

fonts.Init = function(self)
    self:UpdateFonts()
end

fonts.UpdateFonts = function(self)
    for fontName, override in pairs(self.replace) do
        if (_G[fontName]) then
            local _, size, style = _G[fontName]:GetFont()
            _G[fontName]:SetFont(UI.media.font.base, override.size or size, override.style or style)
            if (override.colors) then
                _G[fontName]:SetTextColor(unpack(override.colors))
            end
        end
    end
end
