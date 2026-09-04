--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                           MDs HUB                               ║
    ║               Official Blox Fruits Script Loader                 ║
    ║               GitHub: evolucaomente27-bot/MDs-Blox-HUB           ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- Proteção Anti-AFK integrada
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Notificação de inicialização
local StarterGui = game:GetService("StarterGui")
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "MDs HUB",
        Text = "Carregando o Hub oficial... Aguarde!",
        Duration = 5,
        Icon = "rbxassetid://4483345998"
    })
end)

-- Carregador Principal do GitHub Oficial
local function LoadMDsHub()
    local success, err = pcall(function()
        if isfile and isfile("MDs_Hub_Main.lua") then
            loadstring(readfile("MDs_Hub_Main.lua"))()
        else
            -- Executa o script principal diretamente do repositório oficial
            loadstring(game:HttpGet("https://raw.githubusercontent.com/evolucaomente27-bot/MDs-Blox-HUB/main/Main.lua", true))()
        end
    end)

    if not success then
        warn("[MDs HUB - Error ao carregar]:", err)
    end
end

task.spawn(LoadMDsHub)
