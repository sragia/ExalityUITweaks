local name = ...
---@class UITweaks
local UI = select(2, ...)

UI.modules = {}

local initIndx = 0

UI.GetModule = function(self, name)
    if (not self[name]) then
        initIndx = initIndx + 1
        self.modules[name] = {
            _index = initIndx
        }
    end

    return self.modules[name]
end

UI.Init = function(self)
    for _, module in UI.util.spairs(self.modules, function(t, a, b) return t[a]._index < t[b]._index end) do
        if (module.Init) then
            module:Init()
        end
    end
end

UI.handler = CreateFrame('Frame')
UI.handler:RegisterEvent('ADDON_LOADED')

UI.handler.callbacks = {}

---@param self Frame
---@param events string|table
---@param id string
---@param func function
UI.handler.RegisterCallback = function(self, events, id, func)
    if (type(events) == 'string') then
        events = { events }
    end
    for _, e in ipairs(events) do
        if (not self.callbacks[e]) then
            UI.handler:RegisterEvent(e)
        end
        self.callbacks[e] = self.callbacks[e] or {}
        self.callbacks[e][id] = func
    end

    return id
end

UI.handler.UnregisterCallback = function(self, event, id)
    self.callbacks[event][id] = nil
    local hasMore = false
    for _ in pairs(self.callbacks[event]) do
        hasMore = true
    end
    if (not hasMore) then
        UI.handler:UnregisterEvent(event)
        self.callbacks[event] = nil
    end
end

UI.handler:SetScript('OnEvent', function(self, event, ...)
    if (event == 'ADDON_LOADED' and ... == name) then
        UI:Init()
    end

    if self.callbacks[event] then
        for _, func in pairs(self.callbacks[event]) do
            if (func) then
                func(event, ...)
            end
        end
    end
end)
