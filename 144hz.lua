local addonName = "144HzSwitcher"
local lastDisplayMode = nil

-- Функция для изменения частоты обновления
local function UpdateRefreshRate(isFullscreen)
    local targetRate = isFullscreen and "144/1" or "119/1"
    local currentRate = GetCVar("gxRefresh")
    
    -- Проверяем текущее значение
    if currentRate == targetRate then
        return -- Уже установлена нужная частота
    end
    
    -- Устанавливаем новую частоту и перезапускаем графику
    SetCVar("gxRefresh", targetRate)
    RestartGx()
    
    local displayRate = isFullscreen and "144Hz" or "120Hz"
    print("|cFF00FF00[144Hz]|r Частота обновления изменена на " .. displayRate)
end

-- Создаем фрейм для отслеживания событий
local frame = CreateFrame("Frame")

-- Проверка режима отображения
local function CheckDisplayMode()
    local gxWindow = GetCVar("gxWindow")
    local gxMaximize = GetCVar("gxMaximize")
    
    if not gxWindow or not gxMaximize then
        return
    end
    
    -- Полноэкранный режим: gxWindow = 0 и gxMaximize = 0
    local isFullscreen = (gxWindow == "0" and gxMaximize == "0")
    
    -- Проверяем, изменился ли режим
    if lastDisplayMode ~= isFullscreen then
        lastDisplayMode = isFullscreen
        UpdateRefreshRate(isFullscreen)
    end
end

-- Периодическая проверка режима отображения
local elapsed = 0
frame:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + delta
    if elapsed >= 5 then -- Проверяем каждые 5 секунд
        elapsed = 0
        CheckDisplayMode()
    end
end)

-- Обработчик событий при загрузке
frame:RegisterEvent("PLAYER_LOGIN")

local loginFrame = CreateFrame("Frame")
loginFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        CheckDisplayMode()
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)
loginFrame:RegisterEvent("PLAYER_LOGIN")

-- Команда для ручной проверки
SLASH_HZ1441 = "/144hz"
SLASH_HZ1442 = "/hz"
SlashCmdList["HZ144"] = function(msg)
    lastDisplayMode = nil -- Сбрасываем для принудительной проверки
    CheckDisplayMode()
    local gxWindow = GetCVar("gxWindow")
    local gxMaximize = GetCVar("gxMaximize")
    local currentRate = GetCVar("gxRefresh")
    print("|cFF00FF00[144Hz]|r Режим: " .. (gxWindow == "0" and gxMaximize == "0" and "Полноэкранный" or "Оконный"))
    print("|cFF00FF00[144Hz]|r Текущая частота: " .. (currentRate or "неизвестно") .. "Hz")
end
