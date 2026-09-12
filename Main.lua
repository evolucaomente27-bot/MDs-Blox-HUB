--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                                  MDs HUB                                   ║
    ║                         Blox Fruits Universal Script                       ║
    ║                         Suporte: Sea 1, Sea 2 e Sea 3                      ║
    ║             Edição Vermelha All-in-One Multi-Hub | By GoltolaMD            ║
    ║                             Versão: 6.0 Crimson Edition                    ║
    ╚════════════════════════════════════════════════════════════════════════════╝
]]

-- Inicialização de Serviços
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuração padrão de Equipe (Piratas)
local Settings = {
    JoinTeam = "Pirates",
    Translator = true
}

-- Auto Join Team
task.spawn(function()
    pcall(function()
        if Settings.JoinTeam and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Settings.JoinTeam)
        end
    end)
end)

-- Anti-AFK Integrado
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end)

----------------------------------------------------------------------
-- TABELA GLOBAL DE CONFIGURAÇÕES (_G.MDsHub)
----------------------------------------------------------------------

_G.MDsHub = {
    -- Auto Farm
    AutoFarm = false,
    AutoFarmNearest = false,
    AutoChests = false,
    SelectedWeapon = "Melee", -- Melee, Sword, Gun, Blox Fruit, Any Item
    SelectedItem = "Auto",
    FarmDistance = 25,
    BringMobs = true,
    BringMobsRadius = 280,
    AutoBeli = false,
    
    -- Ultra Fast Attack
    FastAttack = true,
    MultiHitCount = 4,
    DamageAssist = false,
    DamageAssistHits = 2,
    
    -- Hakis
    AutoBusoHaki = true,
    AutoKenHaki = false,
    
    -- Sea 3 Bosses & Eventos
    AutoEliteHunter = false,
    AutoCakePrince = false,
    AutoDoughKing = false,
    
    -- Frutas
    AutoStoreFruits = true,
    AutoCollectFruits = false,
    AutoBuyRandomFruit = false,
    FruitBuyInterval = 300,

    -- PvP
    AutoPVPCombo = false,
    PVPComboStyle = "Sword",
    PVPTargetRange = 250,

    -- ESP Local
    ESPPlayers = false,
    ESPFruits = false,
    ESPChests = false,
    ESPEnemies = false,
    ESPDistance = 1500,
    
    -- Status (Stats)
    AutoMelee = false,
    AutoDefense = false,
    AutoSword = false,
    AutoGun = false,
    AutoFruit = false,
    StatPoints = 3,

    -- Raças (V1 a V4)
    AutoRaceV2 = false,
    AutoRaceV3 = false,
    AutoMirageNotifier = true,
    AutoTeleportMiragePeak = false,
    AutoLookAtMoon = false,
    AutoFindBlueGear = false,
    AutoCompleteTrial = false,
    AutoTrainV4 = false,
    AutoTempleV4 = false,

    -- Espadas Lendárias
    AutoTTKMastery = false,
    AutoCDKMastery = false,
    PreferredSword = "Auto",

    -- Multi-Hubs
    AutoLoadQuantum = false,
    AutoLoadBacon = false,
    AutoLoadRedz = false,

    -- Jogador & Visuais
    WalkSpeed = 16,
    JumpPower = 50,
    CustomSpeed = false,
    CustomJump = false,
    InfiniteJump = false,
    NoClip = false,
    FullBright = false,
    
    -- Teleporte & Movimento
    TweenSpeed = 280,
    TravelStepDistance = 350,
    TravelStepDelay = 0.12,
    TeleportX = 0,
    TeleportY = 0,
    TeleportZ = 0,
    IsTweening = false,
    BlackScreenAFK = false,
    FPSBoost = false
}

local CurrentTween = nil
local BodyVelocityHolder = nil
local IsTraveling = false
local TravelId = 0
local SavedTeleportCFrame = nil
local ConfigFileName = "MDs_Hub_Config.json"

local DefaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

----------------------------------------------------------------------
-- SISTEMA DE CONFIGURAÇÃO (SAVE & LOAD JSON)
----------------------------------------------------------------------

local function SaveConfig()
    pcall(function()
        if writefile then
            local toSave = {}
            for k, v in pairs(_G.MDsHub) do
                if k ~= "IsTweening" and type(v) ~= "function" and type(v) ~= "thread" then
                    toSave[k] = v
                end
            end
            local json = HttpService:JSONEncode(toSave)
            writefile(ConfigFileName, json)
        end
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(ConfigFileName) and readfile then
            local content = readfile(ConfigFileName)
            if content and content ~= "" then
                local data = HttpService:JSONDecode(content)
                if type(data) == "table" then
                    for k, v in pairs(data) do
                        if _G.MDsHub[k] ~= nil then
                            _G.MDsHub[k] = v
                        end
                    end
                end
            end
        end
    end)
end

-- Carrega configurações salvas previamente
LoadConfig()

----------------------------------------------------------------------
-- FUNÇÕES AUXILIARES & UTILITÁRIOS
----------------------------------------------------------------------

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "MDs HUB | " .. (title or "Aviso"),
            Text = text or "",
            Duration = duration or 3,
            Icon = "rbxassetid://4483345998"
        })
    end)
end

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:WaitForChild("HumanoidRootPart", 5)
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:WaitForChild("Humanoid", 5)
end

local function IsAlive(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        return 1
    elseif placeId == 4442272183 then
        return 2
    elseif placeId == 7449423635 then
        return 3
    else
        return 1
    end
end

local function GetPlayerRace()
    local success, race = pcall(function()
        return LocalPlayer.Data.Race.Value
    end)
    return success and race or "Humano"
end

----------------------------------------------------------------------
-- SISTEMA SEGURO DE MOVIMENTO & TWEEN ENGINE (ANTI-ÁGUA & ANTI-FALL)
----------------------------------------------------------------------

local function StopTween()
    TravelId = TravelId + 1
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    if BodyVelocityHolder then
        BodyVelocityHolder:Destroy()
        BodyVelocityHolder = nil
    end
    _G.MDsHub.IsTweening = false
    IsTraveling = false
end

local function TweenTo(targetCFrame, isTravelSegment)
    if IsTraveling and not isTravelSegment then return end

    local root = GetRootPart()
    local char = GetCharacter()
    if not root or not char then return end
    
    -- Garante altitude mínima de segurança (35 studs) para evitar contato com a água
    local safeY = math.max(targetCFrame.Y, 35)
    local safeTargetCFrame = targetCFrame
    if (root.Position - targetCFrame.Position).Magnitude > 60 and targetCFrame.Y < 35 then
        safeTargetCFrame = CFrame.new(targetCFrame.X, safeY, targetCFrame.Z)
    end

    local distance = (root.Position - safeTargetCFrame.Position).Magnitude
    local time = math.max(0.1, distance / (_G.MDsHub.TweenSpeed or 280))
    
    if CurrentTween then
        CurrentTween:Cancel()
    end
    
    if not BodyVelocityHolder or not BodyVelocityHolder.Parent then
        BodyVelocityHolder = Instance.new("BodyVelocity")
        BodyVelocityHolder.Name = "MDs_AntiFall"
        BodyVelocityHolder.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocityHolder.Velocity = Vector3.new(0, 0, 0)
        BodyVelocityHolder.Parent = root
    end
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = safeTargetCFrame})
    CurrentTween = tween
    _G.MDsHub.IsTweening = true
    
    CurrentTween.Completed:Connect(function()
        if CurrentTween == tween then
            CurrentTween = nil
        end
        if not IsTraveling then
            _G.MDsHub.IsTweening = false
            if BodyVelocityHolder then
                BodyVelocityHolder:Destroy()
                BodyVelocityHolder = nil
            end
        end
    end)
    
    tween:Play()
    return tween
end

local function TravelTo(targetCFrame)
    if IsTraveling then return false end

    local root = GetRootPart()
    if not root or not targetCFrame then return false end

    IsTraveling = true
    TravelId = TravelId + 1
    local travelId = TravelId
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local stepDistance = math.max(100, _G.MDsHub.TravelStepDistance or 350)
    local steps = math.max(1, math.ceil(distance / stepDistance))
    local completed = true

    for step = 1, steps do
        if travelId ~= TravelId then
            completed = false
            break
        end

        local currentRoot = GetRootPart()
        if not currentRoot then
            completed = false
            break
        end
        local remainingSteps = steps - step + 1
        local segmentCFrame = currentRoot.CFrame:Lerp(targetCFrame, 1 / remainingSteps)
        local tween = TweenTo(segmentCFrame, true)
        if not tween then
            completed = false
            break
        end

        local playbackState = tween.Completed:Wait()
        if playbackState ~= Enum.PlaybackState.Completed or travelId ~= TravelId then
            completed = false
            break
        end
        task.wait(_G.MDsHub.TravelStepDelay or 0.12)
    end

    if travelId == TravelId then
        IsTraveling = false
        _G.MDsHub.IsTweening = false
        if BodyVelocityHolder then
            BodyVelocityHolder:Destroy()
            BodyVelocityHolder = nil
        end
    end
    return completed
end

local function StopAllAutomations()
    local settings = _G.MDsHub
    for _, option in ipairs({
        "AutoFarm", "AutoFarmNearest", "AutoChests", "AutoEliteHunter",
        "AutoCakePrince", "AutoDoughKing", "AutoRaceV2", "AutoRaceV3",
        "AutoLookAtMoon", "AutoFindBlueGear", "AutoCompleteTrial", "AutoTrainV4",
        "AutoMelee", "AutoDefense", "AutoSword", "AutoGun", "AutoFruit",
        "AutoBusoHaki", "AutoKenHaki", "AutoStoreFruits", "FastAttack", "AutoMirageNotifier",
        "AutoTeleportMiragePeak", "AutoTempleV4", "AutoTTKMastery", "AutoCDKMastery", "AutoBeli",
        "AutoCollectFruits", "AutoBuyRandomFruit", "AutoPVPCombo", "DamageAssist",
        "ESPPlayers", "ESPFruits", "ESPChests", "ESPEnemies"
    }) do
        settings[option] = false
    end
    StopTween()
    SaveConfig()
end

local function SetFullBright(enabled)
    _G.MDsHub.FullBright = enabled
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        for property, value in pairs(DefaultLighting) do
            Lighting[property] = value
        end
    end
end

-- NoClip contínuo
RunService.Stepped:Connect(function()
    if (_G.MDsHub.NoClip or _G.MDsHub.IsTweening or _G.MDsHub.AutoFarm or _G.MDsHub.AutoChests or _G.MDsHub.AutoFarmNearest) and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if _G.MDsHub.InfiniteJump then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Bloqueio de WalkSpeed e JumpPower personalizados contra resets locais
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if _G.MDsHub.CustomSpeed and hum.WalkSpeed ~= _G.MDsHub.WalkSpeed then
            hum.WalkSpeed = _G.MDsHub.WalkSpeed
        end
        if _G.MDsHub.CustomJump and hum.JumpPower ~= _G.MDsHub.JumpPower then
            hum.JumpPower = _G.MDsHub.JumpPower
        end
    end
end)

----------------------------------------------------------------------
-- GERENCIAMENTO DE ARMAS & FERRAMENTAS
----------------------------------------------------------------------

local function GetOwnedToolNames()
    local names, seen = {"Auto"}, {Auto = true}
    for _, container in ipairs({LocalPlayer.Character, LocalPlayer.Backpack}) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and not seen[item.Name] then
                    seen[item.Name] = true
                    table.insert(names, item.Name)
                end
            end
        end
    end
    return names
end

local function GetToolByName(toolName)
    for _, container in ipairs({LocalPlayer.Character, LocalPlayer.Backpack}) do
        if container then
            local tool = container:FindFirstChild(toolName)
            if tool and tool:IsA("Tool") then
                return tool
            end
        end
    end
end

local function GetToolMastery(toolName)
    local tool = GetToolByName(toolName)
    local level = tool and tool:FindFirstChild("Level")
    return level and tonumber(level.Value) or 0
end

local function EquipNamedSword(toolName)
    local tool = GetToolByName(toolName)
    if tool and tool.Parent == LocalPlayer.Backpack then
        local hum = GetHumanoid()
        if hum then hum:EquipTool(tool) end
    end
    return tool
end

local function EquipWeapon(weaponType)
    local char = GetCharacter()
    local backpack = LocalPlayer.Backpack
    local preferredSword = _G.MDsHub.PreferredSword
    local hum = GetHumanoid()
    if not hum then return end

    if weaponType == "Sword" and preferredSword and preferredSword ~= "Auto" then
        return EquipNamedSword(preferredSword)
    end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            if weaponType == "Any Item" then return item end
            if item:FindFirstChild("ToolTip") and item.ToolTip == weaponType then
                return item
            end
        end
    end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if weaponType == "Any Item" then
                hum:EquipTool(item)
                return item
            elseif weaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat" or item.Name:lower():find("combat") or item.Name:lower():find("karate") or item.Name:lower():find("step")) then
                hum:EquipTool(item)
                return item
            elseif weaponType == "Sword" and item.ToolTip == "Sword" then
                hum:EquipTool(item)
                return item
            elseif weaponType == "Blox Fruit" and item.ToolTip == "Blox Fruit" then
                hum:EquipTool(item)
                return item
            elseif weaponType == "Gun" and item.ToolTip == "Gun" then
                hum:EquipTool(item)
                return item
            end
        end
    end
end

----------------------------------------------------------------------
-- FAST ATTACK MULTI-MÉTODO HÍBRIDO (MÁXIMA COMPATIBILIDADE)
----------------------------------------------------------------------

local function ExecuteFastAttack()
    local executed = false

    -- Método 1: CombatFramework hook
    pcall(function()
        local combatFramework = require(LocalPlayer.PlayerScripts.CombatFramework)
        local cameraShaker = require(ReplicatedStorage.Util.CameraShaker)
        cameraShaker:Stop()
        
        local activeController = combatFramework.activeController
        if activeController and activeController.equipped then
            activeController.hitboxMagnitude = 65
            activeController.attacking = false
            activeController.timeToNextAttack = 0
            activeController.increment = 4
            
            local hitCount = _G.MDsHub.MultiHitCount or 4
            if _G.MDsHub.DamageAssist then
                hitCount = math.min(10, hitCount + (_G.MDsHub.DamageAssistHits or 2))
            end
            for _ = 1, hitCount do
                activeController:attack()
            end
            executed = true
        end
    end)

    -- Método 2: Fallback Tool Activate + VirtualUser (para executores como Solara, Wave, Delta Mobile)
    if not executed then
        pcall(function()
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                task.wait(0.01)
                VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
            end
        end)
    end
end

-- Auto Haki de Armamento (Buso Haki)
task.spawn(function()
    while task.wait(1.5) do
        if _G.MDsHub.AutoBusoHaki then
            pcall(function()
                local char = GetCharacter()
                if char and not char:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- Auto Haki da Observação (Ken Haki / Instinct)
task.spawn(function()
    while task.wait(3) do
        if _G.MDsHub.AutoKenHaki then
            pcall(function()
                local char = GetCharacter()
                if char and not char:FindFirstChild("KenHaki") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Ken", true)
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- BANCO DE DADOS EXPANDIDO DE MISSÕES & MOBS (SEA 1, 2 E 3 ATÉ 2550+)
----------------------------------------------------------------------

local QuestsData = {
    [1] = {
        {Min = 1, Max = 9, Quest = "BanditQuest1", QuestId = 1, Mon = "Bandit", Level = 1, CFrame = CFrame.new(1059, 16, 1549)},
        {Min = 10, Max = 14, Quest = "JungleQuest", QuestId = 1, Mon = "Monkey", Level = 14, CFrame = CFrame.new(-1601, 36, 153)},
        {Min = 15, Max = 29, Quest = "JungleQuest", QuestId = 2, Mon = "Gorilla", Level = 20, CFrame = CFrame.new(-1601, 36, 153)},
        {Min = 30, Max = 39, Quest = "BuggyQuest1", QuestId = 1, Mon = "Pirate", Level = 35, CFrame = CFrame.new(-1141, 4, 3826)},
        {Min = 40, Max = 59, Quest = "BuggyQuest1", QuestId = 2, Mon = "Brute", Level = 45, CFrame = CFrame.new(-1141, 4, 3826)},
        {Min = 60, Max = 74, Quest = "DesertQuest", QuestId = 1, Mon = "Desert Bandit", Level = 60, CFrame = CFrame.new(896, 6, 4390)},
        {Min = 75, Max = 89, Quest = "DesertQuest", QuestId = 2, Mon = "Desert Officer", Level = 75, CFrame = CFrame.new(896, 6, 4390)},
        {Min = 90, Max = 99, Quest = "SnowQuest", QuestId = 1, Mon = "Snow Bandit", Level = 90, CFrame = CFrame.new(1386, 87, -1298)},
        {Min = 100, Max = 119, Quest = "SnowQuest", QuestId = 2, Mon = "Snowman", Level = 100, CFrame = CFrame.new(1386, 87, -1298)},
        {Min = 120, Max = 149, Quest = "MarineQuest2", QuestId = 1, Mon = "Chief Petty Officer", Level = 120, CFrame = CFrame.new(-5036, 28, 4324)},
        {Min = 150, Max = 174, Quest = "SkyQuest", QuestId = 1, Mon = "Sky Bandit", Level = 150, CFrame = CFrame.new(-4840, 717, -2620)},
        {Min = 175, Max = 189, Quest = "SkyQuest", QuestId = 2, Mon = "Dark Master", Level = 175, CFrame = CFrame.new(-4840, 717, -2620)},
        {Min = 190, Max = 209, Quest = "PrisonerQuest", QuestId = 1, Mon = "Prisoner", Level = 190, CFrame = CFrame.new(4875, 5, 735)},
        {Min = 210, Max = 249, Quest = "PrisonerQuest", QuestId = 2, Mon = "Dangerous Prisoner", Level = 210, CFrame = CFrame.new(4875, 5, 735)},
        {Min = 250, Max = 299, Quest = "ColosseumQuest", QuestId = 1, Mon = "Toga Warrior", Level = 250, CFrame = CFrame.new(-1575, 7, -2983)},
        {Min = 300, Max = 324, Quest = "MagmaQuest", QuestId = 1, Mon = "Military Soldier", Level = 300, CFrame = CFrame.new(-5315, 11, 8516)},
        {Min = 325, Max = 374, Quest = "MagmaQuest", QuestId = 2, Mon = "Military Spy", Level = 325, CFrame = CFrame.new(-5315, 11, 8516)},
        {Min = 375, Max = 399, Quest = "FishmanQuest", QuestId = 1, Mon = "Fishman Warrior", Level = 375, CFrame = CFrame.new(61122, 18, 1566)},
        {Min = 400, Max = 449, Quest = "FishmanQuest", QuestId = 2, Mon = "Fishman Commando", Level = 400, CFrame = CFrame.new(61122, 18, 1566)},
        {Min = 450, Max = 524, Quest = "SkyExp1Quest", QuestId = 1, Mon = "God's Guard", Level = 450, CFrame = CFrame.new(-4721, 845, -1954)},
        {Min = 525, Max = 549, Quest = "SkyExp2Quest", QuestId = 1, Mon = "Shanda", Level = 525, CFrame = CFrame.new(-7895, 5547, -380)},
        {Min = 550, Max = 624, Quest = "SkyExp2Quest", QuestId = 2, Mon = "Royal Squad", Level = 550, CFrame = CFrame.new(-7895, 5547, -380)},
        {Min = 625, Max = 699, Quest = "FountainQuest", QuestId = 1, Mon = "Galley Pirate", Level = 625, CFrame = CFrame.new(5258, 38, 4050)},
        {Min = 700, Max = 750, Quest = "FountainQuest", QuestId = 2, Mon = "Galley Captain", Level = 650, CFrame = CFrame.new(5258, 38, 4050)}
    },
    [2] = {
        {Min = 700, Max = 724, Quest = "Area1Quest", QuestId = 1, Mon = "Raider", Level = 700, CFrame = CFrame.new(-424, 73, 1836)},
        {Min = 725, Max = 774, Quest = "Area1Quest", QuestId = 2, Mon = "Mercenary", Level = 725, CFrame = CFrame.new(-424, 73, 1836)},
        {Min = 775, Max = 799, Quest = "Area2Quest", QuestId = 1, Mon = "Swan Pirate", Level = 775, CFrame = CFrame.new(633, 73, 918)},
        {Min = 800, Max = 874, Quest = "Area2Quest", QuestId = 2, Mon = "Factory Staff", Level = 800, CFrame = CFrame.new(633, 73, 918)},
        {Min = 875, Max = 924, Quest = "MarineQuest", QuestId = 1, Mon = "Marine Lieutenant", Level = 875, CFrame = CFrame.new(-2440, 73, -3217)},
        {Min = 925, Max = 999, Quest = "MarineQuest", QuestId = 2, Mon = "Marine Captain", Level = 925, CFrame = CFrame.new(-2440, 73, -3217)},
        {Min = 1000, Max = 1049, Quest = "ZombieQuest", QuestId = 1, Mon = "Zombie", Level = 1000, CFrame = CFrame.new(-5497, 48, -795)},
        {Min = 1050, Max = 1099, Quest = "ZombieQuest", QuestId = 2, Mon = "Vampire", Level = 1050, CFrame = CFrame.new(-5497, 48, -795)},
        {Min = 1100, Max = 1149, Quest = "SnowMountainQuest", QuestId = 1, Mon = "Snow Trooper", Level = 1100, CFrame = CFrame.new(609, 401, -5372)},
        {Min = 1150, Max = 1199, Quest = "SnowMountainQuest", QuestId = 2, Mon = "Winter Warrior", Level = 1150, CFrame = CFrame.new(609, 401, -5372)},
        {Min = 1200, Max = 1249, Quest = "IceSideQuest", QuestId = 1, Mon = "Lab Subordinate", Level = 1200, CFrame = CFrame.new(-6064, 15, -4902)},
        {Min = 1250, Max = 1299, Quest = "FireSideQuest", QuestId = 1, Mon = "Horned Warrior", Level = 1250, CFrame = CFrame.new(-5430, 15, -5296)},
        {Min = 1300, Max = 1349, Quest = "FireSideQuest", QuestId = 2, Mon = "Magma Ninja", Level = 1300, CFrame = CFrame.new(-5430, 15, -5296)},
        {Min = 1350, Max = 1399, Quest = "ShipQuest1", QuestId = 1, Mon = "Ship Deckhand", Level = 1250, CFrame = CFrame.new(1038, 125, 32911)},
        {Min = 1400, Max = 1424, Quest = "ShipQuest1", QuestId = 2, Mon = "Ship Engineer", Level = 1275, CFrame = CFrame.new(1038, 125, 32911)},
        {Min = 1425, Max = 1449, Quest = "ShipQuest2", QuestId = 1, Mon = "Ship Steward", Level = 1300, CFrame = CFrame.new(969, 125, 33245)},
        {Min = 1450, Max = 1474, Quest = "ShipQuest2", QuestId = 2, Mon = "Ship Officer", Level = 1325, CFrame = CFrame.new(969, 125, 33245)},
        {Min = 1475, Max = 1499, Quest = "FrostQuest", QuestId = 1, Mon = "Arctic Warrior", Level = 1350, CFrame = CFrame.new(5667, 28, -6486)},
        {Min = 1500, Max = 1524, Quest = "FrostQuest", QuestId = 2, Mon = "Snow Lurker", Level = 1400, CFrame = CFrame.new(5667, 28, -6486)},
        {Min = 1525, Max = 1574, Quest = "ForgottenQuest", QuestId = 1, Mon = "Sea Soldier", Level = 1425, CFrame = CFrame.new(-3054, 237, -10148)}
    },
    [3] = {
        {Min = 1500, Max = 1524, Quest = "PiratePortQuest", QuestId = 1, Mon = "Pirate Millionaire", Level = 1500, CFrame = CFrame.new(-290, 44, 5580)},
        {Min = 1525, Max = 1574, Quest = "PiratePortQuest", QuestId = 2, Mon = "Pistol Billionaire", Level = 1525, CFrame = CFrame.new(-290, 44, 5580)},
        {Min = 1575, Max = 1624, Quest = "AmazonQuest", QuestId = 1, Mon = "Dragon Crew Warrior", Level = 1575, CFrame = CFrame.new(5832, 51, -1100)},
        {Min = 1625, Max = 1699, Quest = "AmazonQuest", QuestId = 2, Mon = "Dragon Crew Archer", Level = 1600, CFrame = CFrame.new(5832, 51, -1100)},
        {Min = 1700, Max = 1749, Quest = "AmazonQuest2", QuestId = 1, Mon = "Female Islander", Level = 1625, CFrame = CFrame.new(5446, 602, 749)},
        {Min = 1750, Max = 1774, Quest = "AmazonQuest2", QuestId = 2, Mon = "Giant Islander", Level = 1650, CFrame = CFrame.new(5446, 602, 749)},
        {Min = 1775, Max = 1824, Quest = "MarineTreeIsland", QuestId = 1, Mon = "Marine Commodore", Level = 1700, CFrame = CFrame.new(2180, 29, -6737)},
        {Min = 1825, Max = 1849, Quest = "MarineTreeIsland", QuestId = 2, Mon = "Marine Rear Admiral", Level = 1725, CFrame = CFrame.new(2180, 29, -6737)},
        {Min = 1850, Max = 1899, Quest = "DeepForestIsland", QuestId = 1, Mon = "Fishman Raider", Level = 1750, CFrame = CFrame.new(-10582, 331, -8757)},
        {Min = 1900, Max = 1949, Quest = "DeepForestIsland", QuestId = 2, Mon = "Fishman Captain", Level = 1775, CFrame = CFrame.new(-10582, 331, -8757)},
        {Min = 1950, Max = 1999, Quest = "DeepForestIsland2", QuestId = 1, Mon = "Forest Pirate", Level = 1800, CFrame = CFrame.new(-13233, 332, -7626)},
        {Min = 2000, Max = 2049, Quest = "DeepForestIsland2", QuestId = 2, Mon = "Mythological Pirate", Level = 1850, CFrame = CFrame.new(-13233, 332, -7626)},
        {Min = 2050, Max = 2099, Quest = "HauntedQuest1", QuestId = 1, Mon = "Reborn Skeleton", Level = 1975, CFrame = CFrame.new(-9515, 142, 5520)},
        {Min = 2100, Max = 2149, Quest = "HauntedQuest1", QuestId = 2, Mon = "Living Zombie", Level = 2000, CFrame = CFrame.new(-9515, 142, 5520)},
        {Min = 2150, Max = 2199, Quest = "HauntedQuest2", QuestId = 1, Mon = "Demonic Soul", Level = 2025, CFrame = CFrame.new(-9515, 142, 5520)},
        {Min = 2200, Max = 2249, Quest = "HauntedQuest2", QuestId = 2, Mon = "Posessed Mummy", Level = 2050, CFrame = CFrame.new(-9515, 142, 5520)},
        {Min = 2250, Max = 2274, Quest = "CandyQuest1", QuestId = 1, Mon = "Peanut Scout", Level = 2200, CFrame = CFrame.new(-2104, 38, -10194)},
        {Min = 2275, Max = 2299, Quest = "CandyQuest1", QuestId = 2, Mon = "Peanut President", Level = 2225, CFrame = CFrame.new(-2104, 38, -10194)},
        {Min = 2300, Max = 2324, Quest = "IceCreamIslandQuest", QuestId = 1, Mon = "Ice Cream Chef", Level = 2250, CFrame = CFrame.new(-820, 65, -10965)},
        {Min = 2325, Max = 2349, Quest = "IceCreamIslandQuest", QuestId = 2, Mon = "Ice Cream Commander", Level = 2275, CFrame = CFrame.new(-820, 65, -10965)},
        {Min = 2350, Max = 2374, Quest = "CakeQuest1", QuestId = 1, Mon = "Cookie Crafter", Level = 2300, CFrame = CFrame.new(-2021, 37, -12028)},
        {Min = 2375, Max = 2399, Quest = "CakeQuest1", QuestId = 2, Mon = "Cake Guard", Level = 2325, CFrame = CFrame.new(-2021, 37, -12028)},
        {Min = 2400, Max = 2424, Quest = "CakeQuest2", QuestId = 1, Mon = "Baking Staff", Level = 2350, CFrame = CFrame.new(-1926, 37, -12849)},
        {Min = 2425, Max = 2449, Quest = "CakeQuest2", QuestId = 2, Mon = "Head Baker", Level = 2375, CFrame = CFrame.new(-1926, 37, -12849)},
        {Min = 2450, Max = 2474, Quest = "ChocQuest1", QuestId = 1, Mon = "Cocoa Warrior", Level = 2400, CFrame = CFrame.new(233, 23, -12200)},
        {Min = 2475, Max = 2499, Quest = "ChocQuest1", QuestId = 2, Mon = "Chocolate Bar Battler", Level = 2425, CFrame = CFrame.new(233, 23, -12200)},
        {Min = 2500, Max = 2524, Quest = "ChocQuest2", QuestId = 1, Mon = "Sweet Thief", Level = 2450, CFrame = CFrame.new(151, 23, -12774)},
        {Min = 2525, Max = 2549, Quest = "ChocQuest2", QuestId = 2, Mon = "Candy Rebel", Level = 2475, CFrame = CFrame.new(151, 23, -12774)},
        {Min = 2550, Max = 2574, Quest = "TikiQuest1", QuestId = 1, Mon = "Sun-kissed Warrior", Level = 2550, CFrame = CFrame.new(-16234, 11, 436)},
        {Min = 2575, Max = 3000, Quest = "TikiQuest1", QuestId = 2, Mon = "Isle Champion", Level = 2575, CFrame = CFrame.new(-16234, 11, 436)}
    }
}

local function GetCurrentQuestInfo()
    local level = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
    local sea = GetCurrentSea()
    local quests = QuestsData[sea] or QuestsData[1]
    
    for _, q in ipairs(quests) do
        if level >= q.Min and level <= q.Max then
            return q
        end
    end
    return quests[#quests]
end

----------------------------------------------------------------------
-- LOOP DE AUTO FARM LEVEL & BRING MOBS INTELIGENTE
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.05) do
        if _G.MDsHub.AutoFarm and not IsTraveling then
            pcall(function()
                local questInfo = GetCurrentQuestInfo()
                local hasQuest = false
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                if questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible then
                    hasQuest = true
                end
                
                local root = GetRootPart()
                if not root then return end

                if not hasQuest then
                    if (root.Position - questInfo.CFrame.Position).Magnitude > 60 then
                        TweenTo(questInfo.CFrame)
                    else
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questInfo.Quest, questInfo.QuestId or 1)
                    end
                else
                    local targetMob = nil
                    local enemiesFolder = Workspace:FindFirstChild("Enemies")
                    if enemiesFolder then
                        for _, mob in pairs(enemiesFolder:GetChildren()) do
                            if mob.Name:find(questInfo.Mon) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                                targetMob = mob
                                break
                            end
                        end
                    end
                    
                    if targetMob then
                        local mobRoot = targetMob.HumanoidRootPart
                        local distToMob = (root.Position - mobRoot.Position).Magnitude
                        local targetOffset = CFrame.new(0, _G.MDsHub.FarmDistance or 25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        local attackPosition = mobRoot.CFrame * targetOffset
                        
                        if distToMob > 60 then
                            TweenTo(attackPosition)
                        else
                            root.CFrame = attackPosition
                            EquipWeapon(_G.MDsHub.SelectedWeapon)
                            
                            -- Bring Mobs
                            if _G.MDsHub.BringMobs and enemiesFolder then
                                for _, otherMob in pairs(enemiesFolder:GetChildren()) do
                                    if otherMob.Name:find(questInfo.Mon) and otherMob:FindFirstChild("HumanoidRootPart") and otherMob ~= targetMob and otherMob:FindFirstChild("Humanoid") and otherMob.Humanoid.Health > 0 then
                                        if (otherMob.HumanoidRootPart.Position - mobRoot.Position).Magnitude <= (_G.MDsHub.BringMobsRadius or 280) then
                                            otherMob.HumanoidRootPart.CFrame = mobRoot.CFrame
                                            otherMob.HumanoidRootPart.CanCollide = false
                                            otherMob.Humanoid.WalkSpeed = 0
                                        end
                                    end
                                end
                            end
                            
                            if _G.MDsHub.FastAttack then
                                ExecuteFastAttack()
                            end
                        end
                    else
                        -- Se os mobs ainda não nasceram, espera na área do NPC com segurança
                        if (root.Position - questInfo.CFrame.Position).Magnitude > 70 then
                            TweenTo(questInfo.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- AUTO FARM NEAREST (FARM DE MOBS PRÓXIMOS SEM MISSÃO)
----------------------------------------------------------------------

local function FindNearestMob()
    local root = GetRootPart()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not root or not enemies then return end

    local nearestMob, nearestDistance = nil, math.huge
    for _, mob in ipairs(enemies:GetChildren()) do
        local humanoid = mob:FindFirstChildOfClass("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        if humanoid and humanoid.Health > 0 and mobRoot then
            local distance = (root.Position - mobRoot.Position).Magnitude
            if distance < nearestDistance then
                nearestMob, nearestDistance = mob, distance
            end
        end
    end
    return nearestMob
end

task.spawn(function()
    while task.wait(0.05) do
        if _G.MDsHub.AutoFarmNearest and not _G.MDsHub.AutoFarm and not IsTraveling then
            pcall(function()
                local mob = FindNearestMob()
                local root = GetRootPart()
                if mob and root and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local mobRoot = mob.HumanoidRootPart
                    local dist = (root.Position - mobRoot.Position).Magnitude
                    local targetOffset = CFrame.new(0, _G.MDsHub.FarmDistance or 25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    local attackPos = mobRoot.CFrame * targetOffset
                    
                    if dist > 60 then
                        TweenTo(attackPos)
                    else
                        root.CFrame = attackPos
                        EquipWeapon(_G.MDsHub.SelectedWeapon)
                        if _G.MDsHub.FastAttack then
                            ExecuteFastAttack()
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Beli (ataca mob próximo)
task.spawn(function()
    while task.wait(0.3) do
        if _G.MDsHub.AutoBeli and not _G.MDsHub.AutoFarm and not _G.MDsHub.AutoFarmNearest and not IsTraveling then
            pcall(function()
                local mob = FindNearestMob()
                local root = GetRootPart()
                if mob and root and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local mobRoot = mob.HumanoidRootPart
                    local dist = (root.Position - mobRoot.Position).Magnitude
                    local attackPos = mobRoot.CFrame * CFrame.new(0, _G.MDsHub.FarmDistance or 25, 0)
                    if dist > 60 then
                        TweenTo(attackPos)
                    else
                        root.CFrame = attackPos
                        EquipWeapon(_G.MDsHub.SelectedWeapon)
                        if _G.MDsHub.FastAttack then
                            ExecuteFastAttack()
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- AUTO CHESTS (FARM DE BELI INFINITO POR BAÚS COM NOCLIP)
----------------------------------------------------------------------

local function GetChests()
    local chests = {}
    local root = GetRootPart()
    if not root then return chests end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("chest") and not obj:FindFirstChild("TouchInterest") then
            -- Alguns baús não tem touch se já foram coletados
        elseif obj:IsA("BasePart") and obj.Name:lower():find("chest") then
            table.insert(chests, obj)
        elseif obj:IsA("Model") and (obj.Name:find("Chest1") or obj.Name:find("Chest2") or obj.Name:find("Chest3") or obj.Name:lower():find("chest")) then
            local p = obj:FindFirstChild("RootPart") or obj:FindFirstChildWhichIsA("BasePart")
            if p then table.insert(chests, p) end
        end
    end

    table.sort(chests, function(a, b)
        return (root.Position - a.Position).Magnitude < (root.Position - b.Position).Magnitude
    end)
    return chests
end

task.spawn(function()
    while task.wait(0.2) do
        if _G.MDsHub.AutoChests and not IsTraveling and not _G.MDsHub.AutoFarm then
            pcall(function()
                local chests = GetChests()
                local root = GetRootPart()
                if #chests > 0 and root then
                    local targetChest = chests[1]
                    local targetCF = targetChest.CFrame * CFrame.new(0, 1, 0)
                    local dist = (root.Position - targetChest.Position).Magnitude
                    
                    if dist > 60 then
                        TweenTo(targetCF)
                    else
                        root.CFrame = targetCF
                        firetouchinterest(root, targetChest, 0)
                        task.wait(0.05)
                        firetouchinterest(root, targetChest, 1)
                    end
                else
                    task.wait(2)
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- COORDENADAS E DADOS DE RAÇAS (V1 A V4)
----------------------------------------------------------------------

local RaceData = {
    NPC_Alchemist = CFrame.new(1308, 12, -776),
    NPC_Arowe = CFrame.new(290, 15, -3830),
    
    BlueFlowers = {
        CFrame.new(-3386, 316, -3701),
        CFrame.new(-5414, 50, -747),
        CFrame.new(-5224, 50, -712),
        CFrame.new(1600, 10, -567)
    },
    RedFlowers = {
        CFrame.new(-744, 73, 1515),
        CFrame.new(-457, 73, 1785),
        CFrame.new(633, 73, 918),
        CFrame.new(-2440, 73, -3217)
    },
    
    TempleOfTime = {
        Entrance = CFrame.new(28642, 14897, 107),
        Lever = CFrame.new(28286, 14897, 103),
        AncientClock = CFrame.new(28555, 14897, 423),
        Doors = {
            ["Human"] = CFrame.new(29223, 14890, -213),
            ["Mink"] = CFrame.new(29023, 14890, -381),
            ["Fishman"] = CFrame.new(28231, 14890, -213),
            ["Shark"] = CFrame.new(28231, 14890, -213),
            ["Angel"] = CFrame.new(28430, 14890, -381),
            ["Ghoul"] = CFrame.new(28678, 14890, -429),
            ["Cyborg"] = CFrame.new(28975, 14890, -429)
        }
    }
}

local function HasItem(itemName)
    for _, container in ipairs({LocalPlayer.Character, LocalPlayer.Backpack}) do
        if container and container:FindFirstChild(itemName) then
            return true
        end
    end
    return false
end

-- Rotina de Auto Raça V2
task.spawn(function()
    while task.wait(1.5) do
        if _G.MDsHub.AutoRaceV2 and GetCurrentSea() == 2 and not IsTraveling then
            pcall(function()
                local hasBlue = HasItem("Flower 1") or HasItem("Blue Flower")
                local hasRed = HasItem("Flower 2") or HasItem("Red Flower")
                local hasYellow = HasItem("Flower 3") or HasItem("Yellow Flower")
                
                -- Conversa inicial com o Alquimista
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
                
                if hasBlue and hasRed and hasYellow then
                    -- Todas as flores coletadas: entrega ao Alquimista
                    TravelTo(RaceData.NPC_Alchemist)
                    task.wait(1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "2")
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "3")
                    Notify("Raça V2", "Parabéns! Missão de Raça V2 concluída!")
                    _G.MDsHub.AutoRaceV2 = false
                    return
                end

                -- Busca Flor Azul (apenas à noite)
                if not hasBlue and (Lighting.ClockTime >= 17 or Lighting.ClockTime <= 6) then
                    for _, spot in ipairs(RaceData.BlueFlowers) do
                        if HasItem("Flower 1") then break end
                        TravelTo(spot)
                        task.wait(0.5)
                        local root = GetRootPart()
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj.Name:find("Flower") and obj:IsA("BasePart") and (obj.Position - root.Position).Magnitude < 30 then
                                firetouchinterest(root, obj, 0)
                                firetouchinterest(root, obj, 1)
                            end
                        end
                    end
                end

                -- Busca Flor Vermelha (apenas de dia)
                if not hasRed and (Lighting.ClockTime > 6 and Lighting.ClockTime < 17) then
                    for _, spot in ipairs(RaceData.RedFlowers) do
                        if HasItem("Flower 2") then break end
                        TravelTo(spot)
                        task.wait(0.5)
                        local root = GetRootPart()
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj.Name:find("Flower") and obj:IsA("BasePart") and (obj.Position - root.Position).Magnitude < 30 then
                                firetouchinterest(root, obj, 0)
                                firetouchinterest(root, obj, 1)
                            end
                        end
                    end
                end

                -- Busca Flor Amarela (derrotar NPCs no Sea 2)
                if not hasYellow then
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, mob in pairs(enemies:GetChildren()) do
                            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                                local root = GetRootPart()
                                if (root.Position - mob.HumanoidRootPart.Position).Magnitude > 60 then
                                    TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                                else
                                    root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                                    EquipWeapon(_G.MDsHub.SelectedWeapon)
                                    if _G.MDsHub.FastAttack then ExecuteFastAttack() end
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Rotina de Auto Raça V3 (Arowe Quests)
task.spawn(function()
    while task.wait(2) do
        if _G.MDsHub.AutoRaceV3 and GetCurrentSea() == 2 and not IsTraveling then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "3")
                local race = GetPlayerRace()
                
                -- Inicia diálogo com Arowe
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Arowe", "1")
                
                if race == "Mink" or race == "Rabbit" then
                    -- Mink requer coletar 30 baús: ativa AutoChests
                    _G.MDsHub.AutoChests = true
                elseif race == "Human" then
                    -- Human requer matar 3 bosses: Diamond, Jeremy, Fajita
                    local enemies = Workspace:FindFirstChild("Enemies")
                    local bossNames = {"Diamond", "Jeremy", "Fajita"}
                    if enemies then
                        for _, bName in ipairs(bossNames) do
                            local boss = enemies:FindFirstChild(bName)
                            if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
                                local root = GetRootPart()
                                if (root.Position - boss.HumanoidRootPart.Position).Magnitude > 60 then
                                    TweenTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                                else
                                    root.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                                    EquipWeapon(_G.MDsHub.SelectedWeapon)
                                    if _G.MDsHub.FastAttack then ExecuteFastAttack() end
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- DETECTOR DE MIRAGE ISLAND & RAÇA V4 (SEA 3)
----------------------------------------------------------------------

local MirageNotified = false

task.spawn(function()
    while task.wait(3) do
        if GetCurrentSea() == 3 then
            pcall(function()
                local mirageFound = false
                local mirageObj = nil
                
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:find("Mirage") or obj.Name:find("Mystic") then
                        mirageFound = true
                        mirageObj = obj
                        break
                    end
                end

                if mirageFound and not MirageNotified then
                    MirageNotified = true
                    Notify("🚨 MIRAGE ISLAND", "Uma Ilha da Miragem surgiu no servidor!", 10)
                    
                    if _G.MDsHub.AutoTeleportMiragePeak and mirageObj then
                        -- Procura o ponto mais alto da ilha
                        local highestPart = nil
                        local highestY = -math.huge
                        for _, part in pairs(mirageObj:GetDescendants()) do
                            if part:IsA("BasePart") and part.Position.Y > highestY then
                                highestY = part.Position.Y
                                highestPart = part
                            end
                        end
                        if highestPart then
                            TravelTo(highestPart.CFrame * CFrame.new(0, 5, 0))
                            Notify("Mirage", "Teleportado para o Pico da Ilha da Miragem!")
                        end
                    end
                elseif not mirageFound then
                    MirageNotified = false
                end
            end)
        end
    end
end)

-- Look at Moon Lock
task.spawn(function()
    while task.wait(0.2) do
        if _G.MDsHub.AutoLookAtMoon and GetCurrentSea() == 3 then
            pcall(function()
                local moonDirection = Lighting:GetMoonDirection()
                if moonDirection then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + moonDirection * 2000)
                    VirtualUser:CaptureController()
                    VirtualUser:SetKeyDown("0x74")
                    task.wait(0.05)
                    VirtualUser:SetKeyUp("0x74")
                end
            end)
        end
    end
end)

-- Blue Gear Scanner
task.spawn(function()
    while task.wait(0.5) do
        if _G.MDsHub.AutoFindBlueGear and GetCurrentSea() == 3 then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("MeshPart") and (obj.MeshId:find("10153114918") or obj.Name:find("Gear") or (obj:FindFirstChild("PointLight") and obj.Size.Magnitude < 10)) then
                        TravelTo(obj.CFrame)
                        firetouchinterest(GetRootPart(), obj, 0)
                        Notify("Raça V4", "Engrenagem Azul encontrada e coletada!", 5)
                        _G.MDsHub.AutoFindBlueGear = false
                        break
                    end
                end
            end)
        end
    end
end)

local function ActivateRaceV4()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
    end)
end

local function TravelToRaceTrialDoor()
    local race = GetPlayerRace()
    local door = RaceData.TempleOfTime.Doors[race] or RaceData.TempleOfTime.Doors.Human
    if TravelTo(RaceData.TempleOfTime.Entrance) then
        return TravelTo(door)
    end
    return false
end

-- Treino de Raça V4
task.spawn(function()
    local lastTempleAttempt = 0
    local lastTransformation = 0
    while task.wait(1) do
        if GetCurrentSea() == 3 then
            local now = os.clock()
            if (_G.MDsHub.AutoTempleV4 or _G.MDsHub.AutoCompleteTrial) and now - lastTempleAttempt >= 15 then
                lastTempleAttempt = now
                TravelToRaceTrialDoor()
            end
            if _G.MDsHub.AutoTrainV4 and now - lastTransformation >= 8 then
                lastTransformation = now
                ActivateRaceV4()
            end
        end
    end
end)

----------------------------------------------------------------------
-- BOSSES (SEA 3) & ESPADAS LENDÁRIAS (TTK & CDK)
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.5) do
        if not IsTraveling and (_G.MDsHub.AutoCakePrince or _G.MDsHub.AutoDoughKing) and GetCurrentSea() == 3 then
            pcall(function()
                local enemies = Workspace:FindFirstChild("Enemies")
                local cakeBoss = enemies and (enemies:FindFirstChild("Cake Prince") or enemies:FindFirstChild("Dough King"))
                local root = GetRootPart()
                if not root then return end

                if cakeBoss and cakeBoss:FindFirstChild("Humanoid") and cakeBoss.Humanoid.Health > 0 and cakeBoss:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - cakeBoss.HumanoidRootPart.Position).Magnitude
                    local targetPos = cakeBoss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                    if dist > 60 then
                        TweenTo(targetPos)
                    else
                        root.CFrame = targetPos
                        EquipWeapon(_G.MDsHub.SelectedWeapon)
                        ExecuteFastAttack()
                    end
                else
                    for _, mob in pairs(enemies:GetChildren()) do
                        if (mob.Name:find("Peanut") or mob.Name:find("Cocoa") or mob.Name:find("Cookie")) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude
                            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, 22, 0)
                            if dist > 60 then
                                TweenTo(targetPos)
                            else
                                root.CFrame = targetPos
                                EquipWeapon(_G.MDsHub.SelectedWeapon)
                                ExecuteFastAttack()
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if not IsTraveling and _G.MDsHub.AutoEliteHunter and GetCurrentSea() == 3 then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter")
                local eliteNames = {"Deandre", "Diablo", "Urban"}
                local enemies = Workspace:FindFirstChild("Enemies")
                local root = GetRootPart()
                if enemies and root then
                    for _, eName in ipairs(eliteNames) do
                        local elite = enemies:FindFirstChild(eName)
                        if elite and elite:FindFirstChild("Humanoid") and elite.Humanoid.Health > 0 and elite:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - elite.HumanoidRootPart.Position).Magnitude
                            local targetPos = elite.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                            if dist > 60 then
                                TweenTo(targetPos)
                            else
                                root.CFrame = targetPos
                                EquipWeapon(_G.MDsHub.SelectedWeapon)
                                ExecuteFastAttack()
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

local function SelectLowestMasterySword(swords)
    local selectedSword = nil
    local lowestMastery = math.huge
    for _, swordName in ipairs(swords) do
        if GetToolByName(swordName) then
            local mastery = GetToolMastery(swordName)
            if mastery < lowestMastery then
                selectedSword = swordName
                lowestMastery = mastery
            end
        end
    end
    return selectedSword
end

task.spawn(function()
    local ttkSwords = {"Saddi", "Shisui", "Wando"}
    local cdkSwords = {"Yama", "Tushita"}
    while task.wait(1) do
        if _G.MDsHub.AutoTTKMastery then
            local sword = SelectLowestMasterySword(ttkSwords)
            if sword then
                _G.MDsHub.SelectedWeapon = "Sword"
                _G.MDsHub.PreferredSword = sword
                EquipNamedSword(sword)
            end
        elseif _G.MDsHub.AutoCDKMastery then
            local sword = SelectLowestMasterySword(cdkSwords)
            if sword then
                _G.MDsHub.SelectedWeapon = "Sword"
                _G.MDsHub.PreferredSword = sword
                EquipNamedSword(sword)
            end
        end
    end
end)

----------------------------------------------------------------------
-- GERENCIAMENTO DE FRUTAS & DEALER
----------------------------------------------------------------------

local function GetWorldFruitPart()
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("Tool") then
            local heldByPlayer = false
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and object:IsDescendantOf(player.Character) then
                    heldByPlayer = true
                    break
                end
            end
            local isFruit = object:FindFirstChild("Fruit") or object.Name:lower():find("fruit") or object.ToolTip == "Blox Fruit"
            if isFruit and not heldByPlayer then
                return object:FindFirstChild("Handle") or object:FindFirstChildWhichIsA("BasePart")
            end
        elseif object:IsA("BasePart") and object.Name:lower():find("fruit") then
            return object
        end
    end
end

-- Auto Coletar Frutas do Mapa
task.spawn(function()
    while task.wait(2) do
        if _G.MDsHub.AutoCollectFruits and not IsTraveling then
            pcall(function()
                local fruitPart = GetWorldFruitPart()
                local root = GetRootPart()
                if fruitPart and root then
                    local dist = (root.Position - fruitPart.Position).Magnitude
                    if dist > 60 then
                        TweenTo(fruitPart.CFrame)
                    else
                        root.CFrame = fruitPart.CFrame
                        firetouchinterest(root, fruitPart, 0)
                        task.wait(0.05)
                        firetouchinterest(root, fruitPart, 1)
                        Notify("Frutas", "Fruta encontrada e coletada!", 3)
                    end
                end
            end)
        end
    end
end)

-- Auto Store Fruits
task.spawn(function()
    while task.wait(1.5) do
        if _G.MDsHub.AutoStoreFruits then
            pcall(function()
                for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
                    if container then
                        for _, item in pairs(container:GetChildren()) do
                            if item:IsA("Tool") and item:FindFirstChild("Fruit") then
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item:GetAttribute("OriginalName") or item.Name, item)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Comprar Fruta Aleatória
task.spawn(function()
    local lastPurchase = 0
    while task.wait(1) do
        if _G.MDsHub.AutoBuyRandomFruit and os.clock() - lastPurchase >= (_G.MDsHub.FruitBuyInterval or 300) then
            lastPurchase = os.clock()
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
                Notify("Frutas", "Tentativa de compra aleatória realizada.", 3)
            end)
        end
    end
end)

----------------------------------------------------------------------
-- DISTRIBUIÇÃO AUTOMÁTICA DE STATUS (COM PROTEÇÃO ANTI-SPAM)
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local pointsObj = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Points")
            local points = pointsObj and pointsObj.Value or 0
            local statPoints = _G.MDsHub.StatPoints or 3

            -- Só envia requisição ao servidor se o jogador realmente possuir pontos a distribuir
            if points >= statPoints then
                local stats = {
                    {enabled = "AutoMelee", name = "Melee"},
                    {enabled = "AutoDefense", name = "Defense"},
                    {enabled = "AutoSword", name = "Sword"},
                    {enabled = "AutoGun", name = "Gun"},
                    {enabled = "AutoFruit", name = "Demon Fruit"}
                }
                for _, stat in ipairs(stats) do
                    if _G.MDsHub[stat.enabled] then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat.name, statPoints)
                        break
                    end
                end
            end
        end)
    end
end)

----------------------------------------------------------------------
-- PVP COMBO AUTOMÁTICO
----------------------------------------------------------------------

local function FindNearestPVPTarget(maximumDistance)
    local root = GetRootPart()
    if not root then return end

    local target, nearestDistance = nil, maximumDistance
    for _, player in ipairs(Players:GetPlayers()) do
        local isEnemy = not LocalPlayer.Team or not player.Team or player.Team ~= LocalPlayer.Team
        if player ~= LocalPlayer and player.Character and isEnemy then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and playerRoot then
                local distance = (root.Position - playerRoot.Position).Magnitude
                if distance <= nearestDistance then
                    target, nearestDistance = player, distance
                end
            end
        end
    end
    return target
end

local function ExecutePVPCombo(target)
    local root = GetRootPart()
    local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetRoot then return false end

    local comboStyle = _G.MDsHub.PVPComboStyle or "Sword"
    local keySets = {
        ["Melee"] = {"Z", "X", "C"},
        ["Sword"] = {"Z", "X"},
        ["Blox Fruit"] = {"Z", "X", "C", "V"}
    }
    local keys = keySets[comboStyle]
    if not keys then return false end

    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
    EquipWeapon(comboStyle)
    ExecuteFastAttack()

    for _, keyName in ipairs(keys) do
        local keyCode = Enum.KeyCode[keyName]
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        task.wait(0.2)
    end
    return true
end

task.spawn(function()
    while task.wait(3.5) do
        if _G.MDsHub.AutoPVPCombo and not IsTraveling then
            pcall(function()
                local target = FindNearestPVPTarget(_G.MDsHub.PVPTargetRange or 250)
                if target then
                    ExecutePVPCombo(target)
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- SISTEMA ESP LOCAL (PLAYERS, CHESTS, FRUITS, NPCS)
----------------------------------------------------------------------

local function GetESPFolder()
    local folder = CoreGui:FindFirstChild("MDs_Hub_ESP")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "MDs_Hub_ESP"
        folder.Parent = CoreGui
    end
    return folder
end

local function ClearESP()
    local folder = CoreGui:FindFirstChild("MDs_Hub_ESP")
    if folder then
        folder:ClearAllChildren()
    end
end

local function AddESP(adornee, part, labelText, color)
    if not adornee or not part then return end
    local root = GetRootPart()
    if not root or (root.Position - part.Position).Magnitude > (_G.MDsHub.ESPDistance or 1500) then return end

    local folder = GetESPFolder()
    local highlight = Instance.new("Highlight")
    highlight.Adornee = adornee
    highlight.FillColor = color
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = folder

    local tag = Instance.new("BillboardGui")
    tag.Adornee = part
    tag.Size = UDim2.new(0, 150, 0, 24)
    tag.StudsOffset = Vector3.new(0, 3, 0)
    tag.AlwaysOnTop = true
    tag.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = labelText
    text.TextColor3 = color
    text.TextStrokeTransparency = 0.2
    text.TextSize = 12
    text.Font = Enum.Font.GothamBold
    text.Parent = tag
end

local function RefreshESP()
    ClearESP()

    if _G.MDsHub.ESPPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if root and humanoid and humanoid.Health > 0 then
                    AddESP(player.Character, root, "PLAYER: " .. player.DisplayName, Color3.fromRGB(255, 85, 100))
                end
            end
        end
    end

    if _G.MDsHub.ESPEnemies then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                local root = enemy:FindFirstChild("HumanoidRootPart")
                local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                if root and humanoid and humanoid.Health > 0 then
                    AddESP(enemy, root, "NPC: " .. enemy.Name, Color3.fromRGB(255, 190, 70))
                end
            end
        end
    end

    if _G.MDsHub.ESPFruits then
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object:IsA("Tool") and (object:FindFirstChild("Fruit") or object.Name:lower():find("fruit") or object.ToolTip == "Blox Fruit") then
                local part = object:FindFirstChild("Handle") or object:FindFirstChildWhichIsA("BasePart")
                if part then
                    AddESP(object, part, "FRUTA: " .. object.Name, Color3.fromRGB(70, 255, 130))
                end
            end
        end
    end

    if _G.MDsHub.ESPChests then
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Name:lower():find("chest") then
                AddESP(object, object, "BAÚ", Color3.fromRGB(255, 225, 70))
            end
        end
    end
end

task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            if _G.MDsHub.ESPPlayers or _G.MDsHub.ESPFruits or _G.MDsHub.ESPChests or _G.MDsHub.ESPEnemies then
                RefreshESP()
            else
                ClearESP()
            end
        end)
    end
end)

----------------------------------------------------------------------
-- BANCO DE DADOS DE TELEPORTE POR ILHAS (SEA 1, 2 E 3)
----------------------------------------------------------------------

local IslandTeleports = {
    [1] = {
        {"Pirate Starter", CFrame.new(1059, 16, 1549)},
        {"Marine Starter", CFrame.new(-2568, 6, 2045)},
        {"Jungle", CFrame.new(-1601, 36, 153)},
        {"Pirate Village", CFrame.new(-1141, 4, 3826)},
        {"Desert", CFrame.new(896, 6, 4390)},
        {"Frozen Village", CFrame.new(1386, 87, -1298)},
        {"Marine Fortress", CFrame.new(-5036, 28, 4324)},
        {"Skylands (Lower)", CFrame.new(-4840, 717, -2620)},
        {"Skylands (Upper)", CFrame.new(-7895, 5547, -380)},
        {"Prison", CFrame.new(4875, 5, 735)},
        {"Colosseum", CFrame.new(-1575, 7, -2983)},
        {"Magma Village", CFrame.new(-5315, 11, 8516)},
        {"Underwater City", CFrame.new(61122, 18, 1566)},
        {"Fountain City", CFrame.new(5258, 38, 4050)}
    },
    [2] = {
        {"The Cafe", CFrame.new(-380, 73, 298)},
        {"Kingdom of Rose", CFrame.new(-424, 73, 1836)},
        {"Mansion (Swan)", CFrame.new(-290, 332, 580)},
        {"Green Zone", CFrame.new(-2440, 73, -3217)},
        {"Graveyard", CFrame.new(-5497, 48, -795)},
        {"Snow Mountain", CFrame.new(609, 401, -5372)},
        {"Hot and Cold", CFrame.new(-6064, 15, -4902)},
        {"Cursed Ship", CFrame.new(1038, 125, 32911)},
        {"Ice Castle", CFrame.new(5423, 28, -6226)},
        {"Forgotten Island", CFrame.new(-3054, 237, -10148)},
        {"Dark Arena", CFrame.new(3804, 22, -3669)}
    },
    [3] = {
        {"Port Town", CFrame.new(-290, 44, 5580)},
        {"Hydra Island", CFrame.new(5832, 51, -1100)},
        {"Great Tree", CFrame.new(2180, 29, -6737)},
        {"Floating Turtle (Mansion)", CFrame.new(-12463, 332, -7565)},
        {"Haunted Castle", CFrame.new(-9515, 142, 5520)},
        {"Peanut Island", CFrame.new(-2104, 38, -10194)},
        {"Ice Cream Island", CFrame.new(-820, 65, -10965)},
        {"Cake Island", CFrame.new(-2021, 37, -12028)},
        {"Chocolate Island", CFrame.new(233, 23, -12200)},
        {"Tiki Outpost", CFrame.new(-16234, 11, 436)},
        {"Temple of Time", CFrame.new(28642, 14897, 107)}
    }
}

----------------------------------------------------------------------
-- SERVER HOP & UTILITÁRIOS DE SERVIDOR
----------------------------------------------------------------------

local function ServerHop(lowPlayerOnly)
    Notify("Servidor", lowPlayerOnly and "Buscando servidor com poucos jogadores..." or "Buscando novo servidor...")
    pcall(function()
        local placeId = game.PlaceId
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=" .. (lowPlayerOnly and "Asc" or "Desc") .. "&limit=100"
        local response = game:HttpGet(url)
        local body = HttpService:JSONDecode(response)
        
        if body and body.data then
            for _, s in ipairs(body.data) do
                if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                    if not lowPlayerOnly or (s.playing >= 1 and s.playing <= 5) then
                        TeleportService:TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                        return
                    end
                end
            end
            -- Se não achou low player estrito, pula para o mais vazio disponível
            for _, s in ipairs(body.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                    return
                end
            end
        end
        Notify("Servidor", "Não foi possível encontrar outro servidor no momento.")
    end)
end

----------------------------------------------------------------------
-- INTEGRAÇÃO DOS MULTI-HUBS RENOMADOS
----------------------------------------------------------------------

local function ExecuteQuantumOnyx()
    pcall(function()
        Notify("Multi-Hub", "Carregando Quantum Onyx...", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
    end)
end

local function ExecuteBaconHub()
    pcall(function()
        Notify("Multi-Hub", "Carregando Bacon Hub...", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconScriptHub/BaconHub/main/New-BaconHub.lua.txt"))()
    end)
end

local function ExecuteNewRedz()
    pcall(function()
        Notify("Multi-Hub", "Carregando Redz Hub (NewRedz)...", 3)
        local redzSettings = { JoinTeam = "Pirates", Translator = true }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realreduz999/NewRedz/main/main.lua"))(redzSettings)
    end)
end

local function ExecuteHohoHub()
    pcall(function()
        Notify("Multi-Hub", "Carregando Hoho Hub...", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
    end)
end

local function ExecuteWAzure()
    pcall(function()
        Notify("Multi-Hub", "Carregando W-Azure Hub...", 3)
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()
    end)
end

----------------------------------------------------------------------
-- INTERFACE GRÁFICA CRIMSON NATIVA (RED EDITION V6.0 BY GOLTOLAMD)
----------------------------------------------------------------------

local function BuildMDsHubScreenGUI()
    pcall(function()
        if CoreGui:FindFirstChild("MDs_Hub_RedGui") then
            CoreGui.MDs_Hub_RedGui:Destroy()
        end
        if LocalPlayer.PlayerGui:FindFirstChild("MDs_Hub_RedGui") then
            LocalPlayer.PlayerGui.MDs_Hub_RedGui:Destroy()
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MDs_Hub_RedGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        pcall(function() ScreenGui.Parent = CoreGui end)
        if not ScreenGui.Parent then
            ScreenGui.Parent = LocalPlayer.PlayerGui
        end
    end

    local Theme = {
        Background = Color3.fromRGB(15, 12, 14),
        Header = Color3.fromRGB(24, 16, 19),
        Sidebar = Color3.fromRGB(18, 14, 16),
        PrimaryRed = Color3.fromRGB(255, 35, 60),
        DarkRed = Color3.fromRGB(180, 20, 40),
        ButtonBg = Color3.fromRGB(32, 20, 24),
        CardBg = Color3.fromRGB(24, 18, 22),
        TextLight = Color3.fromRGB(255, 240, 245),
        TextDim = Color3.fromRGB(170, 150, 160)
    }

    -- Botão Flutuante (Floating Icon)
    local OpenCloseButton = Instance.new("ImageButton")
    OpenCloseButton.Name = "MDs_FloatingIcon"
    OpenCloseButton.Size = UDim2.new(0, 52, 0, 52)
    OpenCloseButton.Position = UDim2.new(0.02, 0, 0.45, 0)
    OpenCloseButton.BackgroundColor3 = Theme.Header
    OpenCloseButton.Image = "rbxassetid://4483345998"
    OpenCloseButton.ImageColor3 = Theme.PrimaryRed
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local OpenCloseCorner = Instance.new("UICorner")
    OpenCloseCorner.CornerRadius = UDim.new(1, 0)
    OpenCloseCorner.Parent = OpenCloseButton

    local OpenCloseStroke = Instance.new("UIStroke")
    OpenCloseStroke.Color = Theme.PrimaryRed
    OpenCloseStroke.Thickness = 2.5
    OpenCloseStroke.Parent = OpenCloseButton

    -- Janela Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 630, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -315, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.PrimaryRed
    MainStroke.Thickness = 1.8
    MainStroke.Parent = MainFrame

    -- Cabeçalho (Header)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 46)
    Header.BackgroundColor3 = Theme.Header
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 160, 1, 0)
    TitleLabel.Position = UDim2.new(0, 14, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "🔥 MDs HUB"
    TitleLabel.TextColor3 = Theme.PrimaryRed
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Size = UDim2.new(0, 150, 1, 0)
    SubTitleLabel.Position = UDim2.new(0, 130, 0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = "• v6.0 Crimson Edition"
    SubTitleLabel.TextColor3 = Color3.fromRGB(255, 120, 140)
    SubTitleLabel.TextSize = 12
    SubTitleLabel.Font = Enum.Font.GothamSemibold
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = Header

    -- HUD de Status (FPS & Ping em tempo real)
    local StatusPill = Instance.new("Frame")
    StatusPill.Size = UDim2.new(0, 180, 0, 24)
    StatusPill.Position = UDim2.new(1, -230, 0.5, -12)
    StatusPill.BackgroundColor3 = Color3.fromRGB(35, 20, 26)
    StatusPill.BorderSizePixel = 0
    StatusPill.Parent = Header

    local PillCorner = Instance.new("UICorner")
    PillCorner.CornerRadius = UDim.new(0, 12)
    PillCorner.Parent = StatusPill

    local PillStroke = Instance.new("UIStroke")
    PillStroke.Color = Theme.DarkRed
    PillStroke.Thickness = 1
    PillStroke.Parent = StatusPill

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 1, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "FPS: -- | Ping: --ms"
    StatusText.TextColor3 = Theme.TextLight
    StatusText.TextSize = 11
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Parent = StatusPill

    -- Monitoramento de FPS e Ping
    task.spawn(function()
        local frameCount = 0
        local lastTime = os.clock()
        RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local currentTime = os.clock()
            if currentTime - lastTime >= 1 then
                local fps = frameCount
                frameCount = 0
                lastTime = currentTime
                local ping = 0
                pcall(function()
                    ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                end)
                StatusText.Text = string.format("FPS: %d | Ping: %dms", fps, ping)
            end
        end)
    end)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -38, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
    CloseBtn.Text = "—"
    CloseBtn.TextColor3 = Theme.TextLight
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
    end
    OpenCloseButton.MouseButton1Click:Connect(ToggleUI)
    CloseBtn.MouseButton1Click:Connect(ToggleUI)

    -- Barra Lateral (Sidebar)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 145, 1, -46)
    Sidebar.Position = UDim2.new(0, 0, 0, 46)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Theme.PrimaryRed
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.PaddingBottom = UDim.new(0, 8)
    SidebarPadding.Parent = Sidebar

    -- Container de Conteúdo
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -145, 1, -46)
    ContentContainer.Position = UDim2.new(0, 145, 0, 46)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local Tabs = {}
    local CurrentTab = nil

    local function CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. name
        TabButton.Size = UDim2.new(0, 130, 0, 32)
        TabButton.BackgroundColor3 = Theme.ButtonBg
        TabButton.Text = (icon or "•") .. "  " .. name
        TabButton.TextColor3 = Theme.TextDim
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar

        local TabBtnPadding = Instance.new("UIPadding")
        TabBtnPadding.PaddingLeft = UDim.new(0, 10)
        TabBtnPadding.Parent = TabButton

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = "Page_" .. name
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = Theme.PrimaryRed
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = false
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 12)
        PagePadding.Parent = TabPage

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Theme.ButtonBg
                t.Button.TextColor3 = Theme.TextDim
            end
            TabPage.Visible = true
            TabButton.BackgroundColor3 = Theme.PrimaryRed
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CurrentTab = TabPage
        end)

        local tabObj = {
            Button = TabButton,
            Page = TabPage,
            
            AddToggle = function(self, labelText, defaultState, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(0.95, 0, 0, 36)
                ToggleFrame.BackgroundColor3 = Theme.CardBg
                ToggleFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = ToggleFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.75, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Theme.TextLight
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame

                local Switch = Instance.new("TextButton")
                Switch.Size = UDim2.new(0, 46, 0, 22)
                Switch.Position = UDim2.new(1, -54, 0.5, -11)
                Switch.BackgroundColor3 = defaultState and Theme.PrimaryRed or Color3.fromRGB(45, 35, 40)
                Switch.Text = defaultState and "ON" or "OFF"
                Switch.TextColor3 = Color3.fromRGB(255, 255, 255)
                Switch.TextSize = 10
                Switch.Font = Enum.Font.GothamBold
                Switch.Parent = ToggleFrame

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(0, 11)
                SwitchCorner.Parent = Switch

                local state = defaultState
                Switch.MouseButton1Click:Connect(function()
                    state = not state
                    Switch.BackgroundColor3 = state and Theme.PrimaryRed or Color3.fromRGB(45, 35, 40)
                    Switch.Text = state and "ON" or "OFF"
                    if callback then callback(state) end
                    SaveConfig()
                end)
            end,

            AddChoice = function(self, labelText, choices, defaultValue, callback)
                local ChoiceFrame = Instance.new("Frame")
                ChoiceFrame.Size = UDim2.new(0.95, 0, 0, 36)
                ChoiceFrame.BackgroundColor3 = Theme.CardBg
                ChoiceFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = ChoiceFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.55, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Theme.TextLight
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ChoiceFrame

                local ChoiceButton = Instance.new("TextButton")
                ChoiceButton.Size = UDim2.new(0.4, 0, 0, 24)
                ChoiceButton.Position = UDim2.new(1, -10, 0.5, -12)
                ChoiceButton.AnchorPoint = Vector2.new(1, 0)
                ChoiceButton.BackgroundColor3 = Theme.ButtonBg
                ChoiceButton.TextColor3 = Theme.PrimaryRed
                ChoiceButton.TextSize = 11
                ChoiceButton.Font = Enum.Font.GothamBold
                ChoiceButton.Parent = ChoiceFrame

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 5)
                ButtonCorner.Parent = ChoiceButton

                local index = 1
                for choiceIndex, choice in ipairs(choices) do
                    if choice == defaultValue then
                        index = choiceIndex
                        break
                    end
                end

                local function UpdateChoice()
                    ChoiceButton.Text = choices[index] or "Auto"
                    if callback then callback(choices[index]) end
                    SaveConfig()
                end
                UpdateChoice()

                ChoiceButton.MouseButton1Click:Connect(function()
                    index = (index % #choices) + 1
                    UpdateChoice()
                end)
            end,

            AddStepper = function(self, labelText, minimum, maximum, increment, defaultValue, callback)
                local StepperFrame = Instance.new("Frame")
                StepperFrame.Size = UDim2.new(0.95, 0, 0, 36)
                StepperFrame.BackgroundColor3 = Theme.CardBg
                StepperFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = StepperFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.52, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Theme.TextLight
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = StepperFrame

                local value = defaultValue
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 44, 0, 24)
                ValueLabel.Position = UDim2.new(1, -66, 0.5, -12)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.TextColor3 = Theme.PrimaryRed
                ValueLabel.TextSize = 12
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Parent = StepperFrame

                local function CreateStepButton(textValue, xOffset)
                    local Button = Instance.new("TextButton")
                    Button.Size = UDim2.new(0, 22, 0, 22)
                    Button.Position = UDim2.new(1, xOffset, 0.5, -11)
                    Button.BackgroundColor3 = Theme.ButtonBg
                    Button.Text = textValue
                    Button.TextColor3 = Theme.TextLight
                    Button.TextSize = 14
                    Button.Font = Enum.Font.GothamBold
                    Button.Parent = StepperFrame
                    local ButtonCorner = Instance.new("UICorner")
                    ButtonCorner.CornerRadius = UDim.new(0, 5)
                    ButtonCorner.Parent = Button
                    return Button
                end

                local Minus = CreateStepButton("−", -98)
                local Plus = CreateStepButton("+", -30)
                local function UpdateValue()
                    value = math.max(minimum, math.min(maximum, value))
                    ValueLabel.Text = tostring(value)
                    if callback then callback(value) end
                    SaveConfig()
                end
                UpdateValue()

                Minus.MouseButton1Click:Connect(function()
                    value = value - increment
                    UpdateValue()
                end)
                Plus.MouseButton1Click:Connect(function()
                    value = value + increment
                    UpdateValue()
                end)
            end,

            AddInput = function(self, labelText, defaultValue, callback)
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(0.95, 0, 0, 36)
                InputFrame.BackgroundColor3 = Theme.CardBg
                InputFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = InputFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.56, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Theme.TextLight
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = InputFrame

                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(0.36, 0, 0, 24)
                Input.Position = UDim2.new(1, -10, 0.5, -12)
                Input.AnchorPoint = Vector2.new(1, 0)
                Input.BackgroundColor3 = Theme.ButtonBg
                Input.Text = tostring(defaultValue or "")
                Input.PlaceholderText = "Valor"
                Input.TextColor3 = Theme.PrimaryRed
                Input.PlaceholderColor3 = Theme.TextDim
                Input.TextSize = 12
                Input.Font = Enum.Font.GothamBold
                Input.ClearTextOnFocus = false
                Input.Parent = InputFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 5)
                InputCorner.Parent = Input

                Input.FocusLost:Connect(function(enterPressed)
                    if callback then callback(Input.Text) end
                    SaveConfig()
                end)
            end,

            AddButton = function(self, labelText, callback)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0.95, 0, 0, 34)
                Btn.BackgroundColor3 = Theme.ButtonBg
                Btn.Text = labelText
                Btn.TextColor3 = Theme.PrimaryRed
                Btn.TextSize = 13
                Btn.Font = Enum.Font.GothamSemibold
                Btn.Parent = TabPage

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = Btn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Theme.DarkRed
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn

                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end,

            AddSection = function(self, sectionText)
                local SectionLabel = Instance.new("TextLabel")
                SectionLabel.Size = UDim2.new(0.95, 0, 0, 24)
                SectionLabel.BackgroundTransparency = 1
                SectionLabel.Text = "── " .. sectionText .. " ──"
                SectionLabel.TextColor3 = Theme.PrimaryRed
                SectionLabel.TextSize = 12
                SectionLabel.Font = Enum.Font.GothamBold
                SectionLabel.Parent = TabPage
            end,

            AddParagraph = function(self, title, desc)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(0.95, 0, 0, 36)
                Frame.BackgroundColor3 = Theme.CardBg
                Frame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame

                local T = Instance.new("TextLabel")
                T.Size = UDim2.new(1, -20, 1, 0)
                T.Position = UDim2.new(0, 10, 0, 0)
                T.BackgroundTransparency = 1
                T.Text = title .. "  " .. (desc or "")
                T.TextColor3 = Theme.TextLight
                T.TextSize = 12
                T.Font = Enum.Font.Gotham
                T.TextXAlignment = Enum.TextXAlignment.Left
                T.Parent = Frame
            end
        }

        table.insert(Tabs, tabObj)
        return tabObj
    end

    ------------------------------------------------------------------
    -- CONSTRUÇÃO DAS ABAS DA INTERFACE
    ------------------------------------------------------------------

    -- 1. TAB INÍCIO
    local TabHome = CreateTab("Início", "🏠")
    TabHome:AddSection("Informações Gerais")
    TabHome:AddParagraph("Criador:", "By GoltolaMD (Red Edition v6.0)")
    TabHome:AddParagraph("Jogador:", LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")")
    TabHome:AddParagraph("Time Atual:", "Piratas (Auto-Joined)")
    TabHome:AddParagraph("Raça Atual:", GetPlayerRace())
    TabHome:AddParagraph("Mundo Atual:", "Sea " .. tostring(GetCurrentSea()))
    TabHome:AddSection("Economia & Otimização")
    TabHome:AddToggle("Modo Tela Preta / AFK Saver (Economiza Bateria)", _G.MDsHub.BlackScreenAFK, function(v)
        _G.MDsHub.BlackScreenAFK = v
        RunService:Set3dRenderingEnabled(not v)
    end)
    TabHome:AddButton("Copiar Link do Repositório GitHub", function()
        if setclipboard then
            setclipboard("https://github.com/evolucaomente27-bot/MDs-Blox-HUB")
            Notify("MDs HUB", "Link copiado para a área de transferência!")
        end
    end)

    -- 2. TAB AUTO FARM
    local TabFarm = CreateTab("Auto Farm", "⚔️")
    TabFarm:AddSection("Farm de Nível Principal")
    TabFarm:AddToggle("Auto Farm Level (Principal)", _G.MDsHub.AutoFarm, function(v)
        _G.MDsHub.AutoFarm = v
        if not v then StopTween() end
    end)
    TabFarm:AddChoice("Arma do Farm", {"Melee", "Sword", "Gun", "Blox Fruit", "Any Item"}, _G.MDsHub.SelectedWeapon, function(v)
        _G.MDsHub.SelectedWeapon = v
    end)
    TabFarm:AddChoice("Item personalizado", GetOwnedToolNames(), _G.MDsHub.SelectedItem, function(v)
        _G.MDsHub.SelectedItem = v
    end)
    TabFarm:AddStepper("Distância de Farm", 10, 60, 5, _G.MDsHub.FarmDistance, function(v)
        _G.MDsHub.FarmDistance = v
    end)
    TabFarm:AddSection("Ataque Rápido & Bring Mobs")
    TabFarm:AddToggle("Ultra Fast Attack (Híbrido)", _G.MDsHub.FastAttack, function(v)
        _G.MDsHub.FastAttack = v
    end)
    TabFarm:AddStepper("Ataques por Ciclo", 1, 8, 1, _G.MDsHub.MultiHitCount, function(v)
        _G.MDsHub.MultiHitCount = v
    end)
    TabFarm:AddToggle("Bring Mobs (Agrupar Inimigos)", _G.MDsHub.BringMobs, function(v)
        _G.MDsHub.BringMobs = v
    end)
    TabFarm:AddStepper("Raio do Bring Mobs", 50, 350, 25, _G.MDsHub.BringMobsRadius, function(v)
        _G.MDsHub.BringMobsRadius = v
    end)
    TabFarm:AddSection("Hakis Automáticos")
    TabFarm:AddToggle("Auto Buso Haki (Armamento)", _G.MDsHub.AutoBusoHaki, function(v)
        _G.MDsHub.AutoBusoHaki = v
    end)
    TabFarm:AddToggle("Auto Ken Haki (Observação / Instinct)", _G.MDsHub.AutoKenHaki, function(v)
        _G.MDsHub.AutoKenHaki = v
    end)

    -- 3. TAB BAÚS & MOBS
    local TabMobs = CreateTab("Baús & Mobs", "💰")
    TabMobs:AddSection("Farm de Beli & Maestria")
    TabMobs:AddToggle("Auto Chests (Farm de Beli por Baús)", _G.MDsHub.AutoChests, function(v)
        _G.MDsHub.AutoChests = v
        if not v then StopTween() end
    end)
    TabMobs:AddToggle("Auto Farm Nearest (Mob Mais Próximo)", _G.MDsHub.AutoFarmNearest, function(v)
        _G.MDsHub.AutoFarmNearest = v
        if not v then StopTween() end
    end)
    TabMobs:AddToggle("Auto Beli (Combater Mobs Próximos)", _G.MDsHub.AutoBeli, function(v)
        _G.MDsHub.AutoBeli = v
        if not v then StopTween() end
    end)

    -- 4. TAB BOSSES (SEA 3)
    local TabBoss = CreateTab("Bosses", "👑")
    TabBoss:AddSection("Chefes & Eventos do Sea 3")
    TabBoss:AddToggle("Auto Cake Prince (500 Mobs)", _G.MDsHub.AutoCakePrince, function(v)
        _G.MDsHub.AutoCakePrince = v
        if not v then StopTween() end
    end)
    TabBoss:AddToggle("Auto Dough King (500 Mobs)", _G.MDsHub.AutoDoughKing, function(v)
        _G.MDsHub.AutoDoughKing = v
        if not v then StopTween() end
    end)
    TabBoss:AddToggle("Auto Elite Hunter (Deandre/Diablo/Urban)", _G.MDsHub.AutoEliteHunter, function(v)
        _G.MDsHub.AutoEliteHunter = v
        if not v then StopTween() end
    end)

    -- 5. TAB RAÇAS (V1 A V4)
    local TabRace = CreateTab("Raças V1-V4", "🧬")
    TabRace:AddSection("Raça V2 & V3 (Sea 2)")
    TabRace:AddToggle("Auto Raça V2 (Alquimista + 3 Flores)", _G.MDsHub.AutoRaceV2, function(v)
        _G.MDsHub.AutoRaceV2 = v
        if not v then StopTween() end
    end)
    TabRace:AddToggle("Auto Raça V3 (Arowe Quests)", _G.MDsHub.AutoRaceV3, function(v)
        _G.MDsHub.AutoRaceV3 = v
        if not v then StopTween() end
    end)
    TabRace:AddSection("Raça V4 (Templo do Tempo & Mirage)")
    TabRace:AddToggle("Alerta de Mirage & Teleporte ao Pico", _G.MDsHub.AutoMirageNotifier, function(v)
        _G.MDsHub.AutoMirageNotifier = v
        _G.MDsHub.AutoTeleportMiragePeak = v
    end)
    TabRace:AddToggle("Auto Olhar para Lua Cheia (Ressonância V3)", _G.MDsHub.AutoLookAtMoon, function(v)
        _G.MDsHub.AutoLookAtMoon = v
    end)
    TabRace:AddToggle("Auto Coletar Engrenagem Azul (Blue Gear)", _G.MDsHub.AutoFindBlueGear, function(v)
        _G.MDsHub.AutoFindBlueGear = v
    end)
    TabRace:AddButton("Puxar Alavanca do Templo (Pull Lever)", function()
        TravelTo(RaceData.TempleOfTime.Lever)
        task.wait(1.5)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Lever" and v:IsA("ClickDetector") then
                fireclickdetector(v)
            end
        end
        Notify("Templo do Tempo", "Alavanca acionada!")
    end)
    TabRace:AddButton("Ir para a Porta da sua Raça", function()
        local r = GetPlayerRace()
        local cf = RaceData.TempleOfTime.Doors[r] or RaceData.TempleOfTime.Doors["Human"]
        TravelTo(cf)
        Notify("Templo", "Viajando para porta: " .. r)
    end)
    TabRace:AddToggle("Auto Treinar Despertar V4", _G.MDsHub.AutoTrainV4, function(v)
        _G.MDsHub.AutoTrainV4 = v
    end)

    -- 6. TAB ESPADAS
    local TabSword = CreateTab("Espadas", "⚔")
    TabSword:AddSection("Maestria de Espadas Lendárias")
    TabSword:AddParagraph("TTK:", "Saddi, Shisui e Wando com maestria 300.")
    TabSword:AddParagraph("CDK:", "Yama e Tushita com maestria 350.")
    TabSword:AddChoice("Espada preferida", {"Auto", "Saddi", "Shisui", "Wando", "Yama", "Tushita", "True Triple Katana", "Cursed Dual Katana"}, _G.MDsHub.PreferredSword, function(v)
        _G.MDsHub.PreferredSword = v
        if v ~= "Auto" then _G.MDsHub.SelectedWeapon = "Sword" end
    end)
    TabSword:AddToggle("Auto Maestria TTK", _G.MDsHub.AutoTTKMastery, function(v)
        _G.MDsHub.AutoTTKMastery = v
        if v then _G.MDsHub.AutoCDKMastery = false end
    end)
    TabSword:AddToggle("Auto Maestria CDK", _G.MDsHub.AutoCDKMastery, function(v)
        _G.MDsHub.AutoCDKMastery = v
        if v then _G.MDsHub.AutoTTKMastery = false end
    end)
    TabSword:AddButton("Equipar Espada Selecionada", function()
        local sword = _G.MDsHub.PreferredSword
        if sword == "Auto" or not EquipNamedSword(sword) then
            Notify("Espadas", "A espada selecionada não está no inventário.")
        else
            Notify("Espadas", sword .. " equipada com sucesso.")
        end
    end)

    -- 7. TAB TELEPORTE (ILHAS EM 1 CLIQUE)
    local TabTeleport = CreateTab("Teleporte", "📍")
    TabTeleport:AddSection("Teleporte Direto por Ilhas (Sea " .. tostring(GetCurrentSea()) .. ")")
    local currentSeaIslands = IslandTeleports[GetCurrentSea()] or IslandTeleports[1]
    for _, island in ipairs(currentSeaIslands) do
        local islandName = island[1]
        local islandCF = island[2]
        TabTeleport:AddButton("Teleportar para " .. islandName, function()
            task.spawn(function()
                Notify("Teleporte", "Viajando para " .. islandName .. "...")
                TravelTo(islandCF)
            end)
        end)
    end
    TabTeleport:AddSection("Posição Customizada")
    TabTeleport:AddButton("Salvar Posição Atual", function()
        local root = GetRootPart()
        if root then
            SavedTeleportCFrame = root.CFrame
            Notify("Teleporte", "Posição atual salva com sucesso!")
        end
    end)
    TabTeleport:AddButton("Ir para Posição Salva", function()
        if SavedTeleportCFrame then
            task.spawn(function() TravelTo(SavedTeleportCFrame) end)
        else
            Notify("Teleporte", "Nenhuma posição salva anteriormente.")
        end
    end)
    TabTeleport:AddButton("Parar Viagem / Tween", function()
        StopTween()
        Notify("Teleporte", "Viagem cancelada.")
    end)

    -- 8. TAB FRUTAS
    local TabFruit = CreateTab("Frutas", "🍎")
    TabFruit:AddSection("Gerenciamento de Frutas")
    TabFruit:AddToggle("Auto Armazenar Frutas (Store)", _G.MDsHub.AutoStoreFruits, function(v)
        _G.MDsHub.AutoStoreFruits = v
    end)
    TabFruit:AddToggle("Auto Coletar Frutas do Mapa", _G.MDsHub.AutoCollectFruits, function(v)
        _G.MDsHub.AutoCollectFruits = v
    end)
    TabFruit:AddStepper("Intervalo de Compra (seg.)", 60, 900, 60, _G.MDsHub.FruitBuyInterval, function(v)
        _G.MDsHub.FruitBuyInterval = v
    end)
    TabFruit:AddToggle("Auto Comprar Fruta Aleatória", _G.MDsHub.AutoBuyRandomFruit, function(v)
        _G.MDsHub.AutoBuyRandomFruit = v
    end)
    TabFruit:AddButton("Comprar Fruta Aleatória Agora (Cousin)", function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        Notify("Frutas", "Tentativa de compra de fruta realizada!")
    end)

    -- 9. TAB PVP
    local TabPVP = CreateTab("PvP", "⚡")
    TabPVP:AddSection("Combo Automático")
    TabPVP:AddChoice("Estilo de Combo", {"Melee", "Sword", "Blox Fruit"}, _G.MDsHub.PVPComboStyle, function(v)
        _G.MDsHub.PVPComboStyle = v
    end)
    TabPVP:AddStepper("Alcance Máximo", 50, 500, 25, _G.MDsHub.PVPTargetRange, function(v)
        _G.MDsHub.PVPTargetRange = v
    end)
    TabPVP:AddToggle("Auto PvP Combo", _G.MDsHub.AutoPVPCombo, function(v)
        _G.MDsHub.AutoPVPCombo = v
    end)
    TabPVP:AddButton("Executar Combo no Jogador Mais Próximo", function()
        local target = FindNearestPVPTarget(_G.MDsHub.PVPTargetRange or 250)
        if target and ExecutePVPCombo(target) then
            Notify("PvP", "Combo executado em " .. target.DisplayName)
        else
            Notify("PvP", "Nenhum alvo inimigo dentro do alcance.")
        end
    end)

    -- 10. TAB ESP
    local TabESP = CreateTab("ESP", "👁")
    TabESP:AddSection("Marcadores Visuais no Cliente")
    TabESP:AddStepper("Distância Máxima do ESP", 250, 5000, 250, _G.MDsHub.ESPDistance, function(v)
        _G.MDsHub.ESPDistance = v
    end)
    TabESP:AddToggle("ESP Players", _G.MDsHub.ESPPlayers, function(v)
        _G.MDsHub.ESPPlayers = v
        if not v then RefreshESP() end
    end)
    TabESP:AddToggle("ESP Frutas", _G.MDsHub.ESPFruits, function(v)
        _G.MDsHub.ESPFruits = v
        if not v then RefreshESP() end
    end)
    TabESP:AddToggle("ESP Baús", _G.MDsHub.ESPChests, function(v)
        _G.MDsHub.ESPChests = v
        if not v then RefreshESP() end
    end)
    TabESP:AddToggle("ESP NPCs", _G.MDsHub.ESPEnemies, function(v)
        _G.MDsHub.ESPEnemies = v
        if not v then RefreshESP() end
    end)
    TabESP:AddButton("Limpar Todos os Marcadores", ClearESP)

    -- 11. TAB STATUS
    local TabStats = CreateTab("Status", "📊")
    TabStats:AddSection("Distribuição de Pontos")
    TabStats:AddToggle("Auto Melee", _G.MDsHub.AutoMelee, function(v) _G.MDsHub.AutoMelee = v end)
    TabStats:AddToggle("Auto Defense", _G.MDsHub.AutoDefense, function(v) _G.MDsHub.AutoDefense = v end)
    TabStats:AddToggle("Auto Sword", _G.MDsHub.AutoSword, function(v) _G.MDsHub.AutoSword = v end)
    TabStats:AddToggle("Auto Gun", _G.MDsHub.AutoGun, function(v) _G.MDsHub.AutoGun = v end)
    TabStats:AddToggle("Auto Demon Fruit", _G.MDsHub.AutoFruit, function(v) _G.MDsHub.AutoFruit = v end)
    TabStats:AddStepper("Pontos por Ciclo", 1, 10, 1, _G.MDsHub.StatPoints, function(v)
        _G.MDsHub.StatPoints = v
    end)

    -- 12. TAB JOGADOR
    local TabPlayer = CreateTab("Jogador", "🏃")
    TabPlayer:AddSection("Habilidades & Movimento")
    TabPlayer:AddToggle("NoClip (Atravessar Paredes)", _G.MDsHub.NoClip, function(v) _G.MDsHub.NoClip = v end)
    TabPlayer:AddToggle("Pulo Infinito", _G.MDsHub.InfiniteJump, function(v) _G.MDsHub.InfiniteJump = v end)
    TabPlayer:AddToggle("Velocidade Personalizada", _G.MDsHub.CustomSpeed, function(v)
        _G.MDsHub.CustomSpeed = v
        local hum = GetHumanoid()
        if hum then hum.WalkSpeed = v and _G.MDsHub.WalkSpeed or 16 end
    end)
    TabPlayer:AddStepper("WalkSpeed", 16, 150, 4, _G.MDsHub.WalkSpeed, function(v)
        _G.MDsHub.WalkSpeed = v
        local hum = GetHumanoid()
        if hum and _G.MDsHub.CustomSpeed then hum.WalkSpeed = v end
    end)
    TabPlayer:AddToggle("Pulo Personalizado", _G.MDsHub.CustomJump, function(v)
        _G.MDsHub.CustomJump = v
        local hum = GetHumanoid()
        if hum then hum.JumpPower = v and _G.MDsHub.JumpPower or 50 end
    end)
    TabPlayer:AddStepper("JumpPower", 50, 200, 10, _G.MDsHub.JumpPower, function(v)
        _G.MDsHub.JumpPower = v
        local hum = GetHumanoid()
        if hum and _G.MDsHub.CustomJump then hum.JumpPower = v end
    end)
    TabPlayer:AddToggle("Full Bright", _G.MDsHub.FullBright, SetFullBright)

    -- 13. TAB MULTI-HUBS
    local TabMulti = CreateTab("Multi-Hubs", "🚀")
    TabMulti:AddSection("Execução Rápida 1-Click")
    TabMulti:AddButton("🟣 Executar Quantum Onyx Hub", ExecuteQuantumOnyx)
    TabMulti:AddButton("🥓 Executar Bacon Hub", ExecuteBaconHub)
    TabMulti:AddButton("🔴 Executar Redz Hub (NewRedz)", ExecuteNewRedz)
    TabMulti:AddButton("⚡ Executar Hoho Hub", ExecuteHohoHub)
    TabMulti:AddButton("🌊 Executar W-Azure Hub", ExecuteWAzure)
    TabMulti:AddSection("Auto-Execução ao Inicializar")
    TabMulti:AddToggle("Auto Carregar Quantum Onyx", _G.MDsHub.AutoLoadQuantum, function(v)
        _G.MDsHub.AutoLoadQuantum = v
        if v then ExecuteQuantumOnyx() end
    end)
    TabMulti:AddToggle("Auto Carregar Bacon Hub", _G.MDsHub.AutoLoadBacon, function(v)
        _G.MDsHub.AutoLoadBacon = v
        if v then ExecuteBaconHub() end
    end)
    TabMulti:AddToggle("Auto Carregar Redz Hub", _G.MDsHub.AutoLoadRedz, function(v)
        _G.MDsHub.AutoLoadRedz = v
        if v then ExecuteNewRedz() end
    end)

    -- 14. TAB CONFIG & SERVIDOR
    local TabConfig = CreateTab("Config", "⚙️")
    TabConfig:AddSection("Gerenciamento de Configuração")
    TabConfig:AddButton("Salvar Configurações (Save Config)", function()
        SaveConfig()
        Notify("Config", "Configurações salvas em " .. ConfigFileName)
    end)
    TabConfig:AddButton("Recarregar Configurações (Load Config)", function()
        LoadConfig()
        Notify("Config", "Configurações recarregadas com sucesso!")
    end)
    TabConfig:AddButton("Parar Todas as Automações", function()
        StopAllAutomations()
        Notify("Config", "Todas as automações foram desligadas.")
    end)
    TabConfig:AddSection("Servidor & Otimização")
    TabConfig:AddButton("Server Hop (Próximo Servidor)", function()
        ServerHop(false)
    end)
    TabConfig:AddButton("Server Hop Low Player (Servidor Vazio)", function()
        ServerHop(true)
    end)
    TabConfig:AddButton("Reconectar ao Servidor (Rejoin)", function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
    TabConfig:AddButton("Boost de FPS (Remover Texturas)", function()
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Notify("FPS Boost", "Texturas pesadas removidas com sucesso!")
        end)
    end)

    -- Ativa a primeira aba por padrão
    if Tabs[1] then
        Tabs[1].Page.Visible = true
        Tabs[1].Button.BackgroundColor3 = Theme.PrimaryRed
        Tabs[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    Notify("MDs HUB", "🔥 Red Edition v6.0 carregada com sucesso!", 5)
end

-- Inicializa a Interface
task.spawn(BuildMDsHubScreenGUI)

-- Execuções automáticas de Multi-Hubs salvas
if _G.MDsHub.AutoLoadQuantum then task.spawn(ExecuteQuantumOnyx) end
if _G.MDsHub.AutoLoadBacon then task.spawn(ExecuteBaconHub) end
if _G.MDsHub.AutoLoadRedz then task.spawn(ExecuteNewRedz) end
