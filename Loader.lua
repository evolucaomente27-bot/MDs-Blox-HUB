--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                           MDs HUB                               ║
    ║             Official Blox Fruits All-in-One Loader               ║
    ║                      🔥 By GoltolaMD 🔥                         ║
    ║                   Versão: 6.0 Crimson Edition                   ║
    ║               GitHub: evolucaomente27-bot/MDs-Blox-HUB           ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- Configurações globais de inicialização
local Settings = {
    JoinTeam = "Pirates",
    Translator = true
}

-- Proteção Anti-AFK integrada de alta confiabilidade
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Notificação de inicialização com tema Crimson
local StarterGui = game:GetService("StarterGui")
local function SendLoaderNotification(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "MDs HUB | " .. title,
            Text = message,
            Duration = duration or 4,
            Icon = "rbxassetid://4483345998"
        })
    end)
end

SendLoaderNotification("By GoltolaMD", "Carregando a Red Edition v6.0... Aguarde!", 4)

-- Carregador Principal do GitHub com Sistema de Tentativas (Retry Fallback)
local function LoadMDsHub()
    local maxRetries = 3
    local loaded = false

    -- 1. Verifica arquivo local em cache do executor
    if isfile and isfile("MDs_Hub_Main.lua") then
        local success, result = pcall(function()
            loadstring(readfile("MDs_Hub_Main.lua"))()
        end)
        if success then
            return
        end
    end

    -- 2. Carregamento direto via GitHub Oficial
    local scriptUrl = "https://raw.githubusercontent.com/evolucaomente27-bot/MDs-Blox-HUB/main/Main.lua"
    for attempt = 1, maxRetries do
        local success, err = pcall(function()
            local code = game:HttpGet(scriptUrl, true)
            if code and #code > 1000 then
                loadstring(code)()
                loaded = true
            else
                error("Código recebido está incompleto ou vazio")
            end
        end)

        if success and loaded then
            break
        else
            warn(string.format("[MDs HUB - Tentativa %d/%d falhou]: %s", attempt, maxRetries, tostring(err)))
            if attempt < maxRetries then
                task.wait(2)
            else
                SendLoaderNotification("Erro de Conexão", "Falha ao baixar script do GitHub. Verifique sua conexão ou executor.", 8)
            end
        end
    end
end

task.spawn(LoadMDsHub)
