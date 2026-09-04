--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                                  MDs HUB                                   ║
    ║                         Blox Fruits Universal Script                       ║
    ║                         Suporte: Sea 1, Sea 2 e Sea 3                      ║
    ║           Interface Gráfica Nativa (UI 100% Integrada Mobile e PC)         ║
    ║                             Versão: 4.5 Pro Edition                        ║
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
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-AFK integrado (Banana Method)
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- Tabela Global de Configurações
_G.MDsHub = {
    -- Auto Farm
    AutoFarm = false,
    AutoFarmNearest = false,
    AutoChests = false,
    SelectedWeapon = "Melee", -- Melee, Sword, Gun, Blox Fruit
    FarmDistance = 25,
    BringMobs = true,
    BringMobsRadius = 280,
    
    -- Banana Ultra Fast Attack
    FastAttack = true,
    MultiHitCount = 4,
    
    -- Haki Automático
    AutoBusoHaki = true,
    
    -- Sea 3 Bosses & Eventos
    AutoEliteHunter = false,
    AutoCakePrince = false,
    AutoDoughKing = false,
    
    -- Frutas
    AutoStoreFruits = true,
    
    -- Status (Stats)
    AutoMelee = false,
    AutoDefense = false,
    AutoSword = false,
    AutoGun = false,
    AutoFruit = false,
    StatPoints = 3,

    -- =======================================================
    -- SISTEMA AVANÇADO DE RAÇAS (V1 ATÉ V4)
    -- =======================================================
    AutoRaceV2 = false,
    AutoCollectBlueFlower = false,
    AutoCollectRedFlower = false,
    AutoFarmYellowFlower = false,
    
    AutoRaceV3 = false,
    AutoQuestMinkV3 = false,
    AutoQuestHumanV3 = false,
    
    AutoMirageNotifier = true,
    AutoTeleportMiragePeak = false,
    AutoLookAtMoon = false,
    AutoFindBlueGear = false,
    AutoCompleteTrial = false,
    AutoTrainV4 = false,

    -- Player & Visuals
    WalkSpeed = 16,
    JumpPower = 50,
    CustomSpeed = false,
    CustomJump = false,
    InfiniteJump = false,
    NoClip = false,
    FullBright = false,
    
    -- Teleport & Performance
    TweenSpeed = 280,
    IsTweening = false,
    BlackScreenAFK = false,
    FPSBoost = false
}

local CurrentTween = nil
local BodyVelocityHolder = nil

----------------------------------------------------------------------
-- FUNÇÕES DE SUPORTE & TWEEN ENGINE
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
    return char:WaitForChild("HumanoidRootPart", 5)
end

local function GetHumanoid()
    local char = GetCharacter()
    return char:WaitForChild("Humanoid", 5)
end

local function TweenTo(targetCFrame)
    local root = GetRootPart()
    local char = GetCharacter()
    if not root or not char then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local time = distance / _G.MDsHub.TweenSpeed
    
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
    CurrentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    _G.MDsHub.IsTweening = true
    
    CurrentTween.Completed:Connect(function()
        _G.MDsHub.IsTweening = false
        if BodyVelocityHolder then
            BodyVelocityHolder:Destroy()
            BodyVelocityHolder = nil
        end
    end)
    
    CurrentTween:Play()
    return CurrentTween
end

local function StopTween()
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    if BodyVelocityHolder then
        BodyVelocityHolder:Destroy()
        BodyVelocityHolder = nil
    end
    _G.MDsHub.IsTweening = false
end

-- NoClip ativo durante teleporte e farm
RunService.Stepped:Connect(function()
    if (_G.MDsHub.NoClip or _G.MDsHub.IsTweening or _G.MDsHub.AutoFarm) and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

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
    return success and race or "Desconhecida"
end

local function EquipWeapon(weaponType)
    local char = GetCharacter()
    local backpack = LocalPlayer.Backpack
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("ToolTip") and item.ToolTip == weaponType then
            return item
        end
    end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if weaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat") then
                GetHumanoid():EquipTool(item)
                return item
            elseif weaponType == "Sword" and item.ToolTip == "Sword" then
                GetHumanoid():EquipTool(item)
                return item
            elseif weaponType == "Blox Fruit" and item.ToolTip == "Blox Fruit" then
                GetHumanoid():EquipTool(item)
                return item
            elseif weaponType == "Gun" and item.ToolTip == "Gun" then
                GetHumanoid():EquipTool(item)
                return item
            end
        end
    end
end

----------------------------------------------------------------------
-- FAST ATTACK AVANÇADO (BANANA ULTRA FAST METHOD)
----------------------------------------------------------------------

local function ExecuteFastAttack()
    pcall(function()
        local combatFramework = require(LocalPlayer.PlayerScripts.CombatFramework)
        local cameraShaker = require(ReplicatedStorage.Util.CameraShaker)
        cameraShaker:Stop()
        
        local activeController = combatFramework.activeController
        if activeController and activeController.equipped then
            activeController.hitboxMagnitude = 65
            for i = 1, _G.MDsHub.MultiHitCount do
                activeController:attack()
            end
            activeController.timeToNextAttack = 0
            activeController.increment = 3
        end
    end)
end

-- Auto Haki de Armamento (Buso Haki)
task.spawn(function()
    while task.wait(1) do
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

----------------------------------------------------------------------
-- BANCO DE DADOS DE MISSÕES & MOBS (SEA 1, 2 e 3)
----------------------------------------------------------------------

local QuestsData = {
    [1] = {
        {Min = 1, Max = 9, Quest = "BanditQuest1", Mon = "Bandit", Level = 1, CFrame = CFrame.new(1059, 16, 1549)},
        {Min = 10, Max = 14, Quest = "JungleQuest", Mon = "Monkey", Level = 14, CFrame = CFrame.new(-1601, 36, 153)},
        {Min = 15, Max = 29, Quest = "JungleQuest", Mon = "Gorilla", Level = 20, CFrame = CFrame.new(-1237, 6, -484)},
        {Min = 30, Max = 39, Quest = "BuggyQuest1", Mon = "Pirate", Level = 35, CFrame = CFrame.new(-1141, 4, 3826)},
        {Min = 40, Max = 59, Quest = "BuggyQuest1", Mon = "Brute", Level = 45, CFrame = CFrame.new(-1141, 4, 3826)},
        {Min = 60, Max = 74, Quest = "DesertQuest", Mon = "Desert Bandit", Level = 60, CFrame = CFrame.new(896, 6, 4390)},
        {Min = 75, Max = 89, Quest = "DesertQuest", Mon = "Desert Officer", Level = 75, CFrame = CFrame.new(896, 6, 4390)},
        {Min = 90, Max = 99, Quest = "SnowQuest", Mon = "Snow Bandit", Level = 90, CFrame = CFrame.new(1386, 87, -1298)},
        {Min = 100, Max = 119, Quest = "SnowQuest", Mon = "Snowman", Level = 100, CFrame = CFrame.new(1386, 87, -1298)},
        {Min = 120, Max = 149, Quest = "MarineQuest2", Mon = "Chief Petty Officer", Level = 120, CFrame = CFrame.new(-5036, 28, 4324)},
        {Min = 150, Max = 174, Quest = "SkyQuest", Mon = "Sky Bandit", Level = 150, CFrame = CFrame.new(-4840, 717, -2620)},
        {Min = 175, Max = 189, Quest = "SkyQuest", Mon = "Dark Master", Level = 175, CFrame = CFrame.new(-4840, 717, -2620)},
        {Min = 190, Max = 209, Quest = "PrisonerQuest", Mon = "Prisoner", Level = 190, CFrame = CFrame.new(4875, 5, 735)},
        {Min = 210, Max = 249, Quest = "PrisonerQuest", Mon = "Dangerous Prisoner", Level = 210, CFrame = CFrame.new(4875, 5, 735)},
        {Min = 250, Max = 299, Quest = "ColosseumQuest", Mon = "Toga Warrior", Level = 250, CFrame = CFrame.new(-1575, 7, -2983)},
        {Min = 300, Max = 374, Quest = "MagmaQuest", Mon = "Military Soldier", Level = 300, CFrame = CFrame.new(-5315, 11, 8516)},
        {Min = 375, Max = 449, Quest = "FishmanQuest", Mon = "Fishman Warrior", Level = 375, CFrame = CFrame.new(61122, 18, 1566)},
        {Min = 450, Max = 524, Quest = "SkyExp1Quest", Mon = "God's Guard", Level = 450, CFrame = CFrame.new(-4721, 845, -1954)},
        {Min = 525, Max = 624, Quest = "SkyExp2Quest", Mon = "Shanda", Level = 525, CFrame = CFrame.new(-7895, 5547, -380)},
        {Min = 625, Max = 699, Quest = "FountainQuest", Mon = "Galley Pirate", Level = 625, CFrame = CFrame.new(5258, 38, 4050)},
        {Min = 700, Max = 750, Quest = "FountainQuest", Mon = "Galley Captain", Level = 650, CFrame = CFrame.new(5258, 38, 4050)}
    },
    [2] = {
        {Min = 700, Max = 724, Quest = "Area1Quest", Mon = "Raider [Lv. 700]", Level = 700, CFrame = CFrame.new(-424, 73, 1836)},
        {Min = 725, Max = 774, Quest = "Area1Quest", Mon = "Mercenary [Lv. 725]", Level = 725, CFrame = CFrame.new(-424, 73, 1836)},
        {Min = 775, Max = 799, Quest = "Area2Quest", Mon = "Swan Pirate [Lv. 775]", Level = 775, CFrame = CFrame.new(633, 73, 918)},
        {Min = 800, Max = 874, Quest = "Area2Quest", Mon = "Factory Staff [Lv. 800]", Level = 800, CFrame = CFrame.new(633, 73, 918)},
        {Min = 875, Max = 924, Quest = "MarineQuest", Mon = "Marine Lieutenant [Lv. 875]", Level = 875, CFrame = CFrame.new(-2440, 73, -3217)},
        {Min = 925, Max = 999, Quest = "MarineQuest", Mon = "Marine Captain [Lv. 925]", Level = 925, CFrame = CFrame.new(-2440, 73, -3217)},
        {Min = 1000, Max = 1099, Quest = "ZombieQuest", Mon = "Zombie [Lv. 1000]", Level = 1000, CFrame = CFrame.new(-5497, 48, -795)},
        {Min = 1100, Max = 1199, Quest = "SnowMountainQuest", Mon = "Snow Trooper [Lv. 1100]", Level = 1100, CFrame = CFrame.new(609, 401, -5372)},
        {Min = 1200, Max = 1349, Quest = "IceSideQuest", Mon = "Arctic Warrior [Lv. 1200]", Level = 1200, CFrame = CFrame.new(5423, 28, -6226)},
        {Min = 1350, Max = 1499, Quest = "ShipQuest1", Mon = "Ship Deckhand [Lv. 1250]", Level = 1250, CFrame = CFrame.new(1038, 125, 32911)}
    },
    [3] = {
        {Min = 1500, Max = 1574, Quest = "PiratePortQuest", Mon = "Pirate Millionaire [Lv. 1500]", Level = 1500, CFrame = CFrame.new(-290, 44, 5580)},
        {Min = 1575, Max = 1699, Quest = "AmazonQuest", Mon = "Female Islander [Lv. 1575]", Level = 1575, CFrame = CFrame.new(5832, 51, -1100)},
        {Min = 1700, Max = 1824, Quest = "MarineTreeIsland", Mon = "Marine Commodore [Lv. 1700]", Level = 1700, CFrame = CFrame.new(2180, 29, -6737)},
        {Min = 1825, Max = 1974, Quest = "DeepForestIsland", Mon = "Forest Pirate [Lv. 1825]", Level = 1825, CFrame = CFrame.new(-13233, 332, -7626)},
        {Min = 1975, Max = 2200, Quest = "HauntedQuest1", Mon = "Reborn Skeleton [Lv. 1975]", Level = 1975, CFrame = CFrame.new(-9515, 142, 5520)},
        {Min = 2201, Max = 2550, Quest = "CandyQuest1", Mon = "Peanut Scout [Lv. 2200]", Level = 2200, CFrame = CFrame.new(-2104, 38, -10194)}
    }
}

local function GetCurrentQuestInfo()
    local level = LocalPlayer.Data.Level.Value
    local sea = GetCurrentSea()
    local quests = QuestsData[sea] or QuestsData[1]
    
    for _, q in ipairs(quests) do
        if level >= q.Min and level <= q.Max then
            return q
        end
    end
    return quests[#quests]
end

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

----------------------------------------------------------------------
-- LOOP DE AUTO FARM & BRING MOBS
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.05) do
        if _G.MDsHub.AutoFarm then
            pcall(function()
                local questInfo = GetCurrentQuestInfo()
                local hasQuest = false
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                if questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible then
                    hasQuest = true
                end
                
                if not hasQuest then
                    TweenTo(questInfo.CFrame)
                    task.wait(0.3)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questInfo.Quest, 1)
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
                        local targetOffset = CFrame.new(0, _G.MDsHub.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        
                        GetRootPart().CFrame = mobRoot.CFrame * targetOffset
                        EquipWeapon(_G.MDsHub.SelectedWeapon)
                        
                        if _G.MDsHub.BringMobs and enemiesFolder then
                            for _, otherMob in pairs(enemiesFolder:GetChildren()) do
                                if otherMob.Name:find(questInfo.Mon) and otherMob:FindFirstChild("HumanoidRootPart") and otherMob ~= targetMob then
                                    if (otherMob.HumanoidRootPart.Position - mobRoot.Position).Magnitude <= _G.MDsHub.BringMobsRadius then
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
                    else
                        TweenTo(questInfo.CFrame)
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- SEA 3 BOSSES & RAÇA V4 LOOPS
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.5) do
        if (_G.MDsHub.AutoCakePrince or _G.MDsHub.AutoDoughKing) and GetCurrentSea() == 3 then
            pcall(function()
                local enemies = Workspace:FindFirstChild("Enemies")
                local cakeBoss = enemies and (enemies:FindFirstChild("Cake Prince") or enemies:FindFirstChild("Dough King"))
                
                if cakeBoss and cakeBoss:FindFirstChild("Humanoid") and cakeBoss.Humanoid.Health > 0 then
                    GetRootPart().CFrame = cakeBoss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                    EquipWeapon(_G.MDsHub.SelectedWeapon)
                    ExecuteFastAttack()
                else
                    for _, mob in pairs(enemies:GetChildren()) do
                        if (mob.Name:find("Peanut") or mob.Name:find("Cocoa") or mob.Name:find("Cookie")) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            GetRootPart().CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 22, 0)
                            EquipWeapon(_G.MDsHub.SelectedWeapon)
                            ExecuteFastAttack()
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
        if _G.MDsHub.AutoEliteHunter and GetCurrentSea() == 3 then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter")
                local eliteNames = {"Deandre", "Diablo", "Urban"}
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, eName in ipairs(eliteNames) do
                        local elite = enemies:FindFirstChild(eName)
                        if elite and elite:FindFirstChild("Humanoid") and elite.Humanoid.Health > 0 then
                            GetRootPart().CFrame = elite.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                            EquipWeapon(_G.MDsHub.SelectedWeapon)
                            ExecuteFastAttack()
                            break
                        end
                    end
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
                        TweenTo(obj.CFrame)
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

-- Auto Store Fruits
task.spawn(function()
    while task.wait(1.5) do
        if _G.MDsHub.AutoStoreFruits then
            pcall(function()
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Fruit") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item:GetAttribute("OriginalName") or item.Name, item)
                    end
                end
                if LocalPlayer.Character then
                    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
                        if item:IsA("Tool") and item:FindFirstChild("Fruit") then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item:GetAttribute("OriginalName") or item.Name, item)
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- INTERFACE GRÁFICA NATIVA E COMPLETA (MDs HUB UI ENGINE)
----------------------------------------------------------------------

local function BuildMDsHubScreenGUI()
    -- Destrói instância anterior se existir
    pcall(function()
        if CoreGui:FindFirstChild("MDs_Hub_ScreenGui") then
            CoreGui.MDs_Hub_ScreenGui:Destroy()
        end
        if LocalPlayer.PlayerGui:FindFirstChild("MDs_Hub_ScreenGui") then
            LocalPlayer.PlayerGui.MDs_Hub_ScreenGui:Destroy()
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MDs_Hub_ScreenGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Proteção de Gui (Synapse / Delta / Solara)
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

    -- Botão Flutuante para Abrir/Fechar (Essencial para Mobile)
    local OpenCloseButton = Instance.new("ImageButton")
    OpenCloseButton.Name = "MDs_FloatingIcon"
    OpenCloseButton.Size = UDim2.new(0, 50, 0, 50)
    OpenCloseButton.Position = UDim2.new(0.02, 0, 0.45, 0)
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OpenCloseButton.Image = "rbxassetid://4483345998"
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local OpenCloseCorner = Instance.new("UICorner")
    OpenCloseCorner.CornerRadius = UDim.new(1, 0)
    OpenCloseCorner.Parent = OpenCloseButton

    local OpenCloseStroke = Instance.new("UIStroke")
    OpenCloseStroke.Color = Color3.fromRGB(255, 200, 0) -- Dourado Banana
    OpenCloseStroke.Thickness = 2.5
    OpenCloseStroke.Parent = OpenCloseButton

    -- Janela Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 200, 0)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- Cabeçalho (Header)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "🍌 MDs HUB | v4.5"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Size = UDim2.new(0, 200, 1, 0)
    SubTitleLabel.Position = UDim2.new(0, 160, 0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = "• Banana Pro Edition"
    SubTitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubTitleLabel.TextSize = 13
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = Header

    -- Botão Fechar / Minimizar no Cabeçalho
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    CloseBtn.Text = "—"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    -- Alternar Visibilidade da UI
    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
    end
    OpenCloseButton.MouseButton1Click:Connect(ToggleUI)
    CloseBtn.MouseButton1Click:Connect(ToggleUI)

    -- Barra Lateral de Abas (Sidebar)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.Parent = Sidebar

    -- Área de Conteúdo (Content Container)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -140, 1, -45)
    ContentContainer.Position = UDim2.new(0, 140, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    -- Gerenciador de Abas e Elementos
    local Tabs = {}
    local CurrentTab = nil

    local function CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. name
        TabButton.Size = UDim2.new(0, 125, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        TabButton.Text = (icon or "•") .. "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
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
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)
        TabPage.Visible = false
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = TabPage

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            TabPage.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            TabButton.TextColor3 = Color3.fromRGB(20, 20, 20)
            CurrentTab = TabPage
        end)

        local tabObj = {
            Button = TabButton,
            Page = TabPage,
            
            -- Adicionar Toggle
            AddToggle = function(self, labelText, defaultState, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(0.94, 0, 0, 36)
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                ToggleFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = ToggleFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.75, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Color3.fromRGB(240, 240, 240)
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame

                local Switch = Instance.new("TextButton")
                Switch.Size = UDim2.new(0, 44, 0, 22)
                Switch.Position = UDim2.new(1, -54, 0.5, -11)
                Switch.BackgroundColor3 = defaultState and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(45, 45, 55)
                Switch.Text = defaultState and "ON" or "OFF"
                Switch.TextColor3 = defaultState and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(200, 200, 200)
                Switch.TextSize = 10
                Switch.Font = Enum.Font.GothamBold
                Switch.Parent = ToggleFrame

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(0, 11)
                SwitchCorner.Parent = Switch

                local state = defaultState
                Switch.MouseButton1Click:Connect(function()
                    state = not state
                    Switch.BackgroundColor3 = state and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(45, 45, 55)
                    Switch.Text = state and "ON" or "OFF"
                    Switch.TextColor3 = state and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(200, 200, 200)
                    if callback then callback(state) end
                end)
            end,

            -- Adicionar Botão
            AddButton = function(self, labelText, callback)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0.94, 0, 0, 34)
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                Btn.Text = labelText
                Btn.TextColor3 = Color3.fromRGB(255, 215, 0)
                Btn.TextSize = 13
                Btn.Font = Enum.Font.GothamSemibold
                Btn.Parent = TabPage

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = Btn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Color3.fromRGB(60, 60, 75)
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn

                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end,

            -- Adicionar Seção / Título
            AddSection = function(self, sectionText)
                local SectionLabel = Instance.new("TextLabel")
                SectionLabel.Size = UDim2.new(0.94, 0, 0, 24)
                SectionLabel.BackgroundTransparency = 1
                SectionLabel.Text = "── " .. sectionText .. " ──"
                SectionLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                SectionLabel.TextSize = 12
                SectionLabel.Font = Enum.Font.GothamBold
                SectionLabel.Parent = TabPage
            end,

            -- Adicionar Parágrafo informativo
            AddParagraph = function(self, title, desc)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(0.94, 0, 0, 36)
                Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                Frame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame

                local T = Instance.new("TextLabel")
                T.Size = UDim2.new(1, -20, 1, 0)
                T.Position = UDim2.new(0, 10, 0, 0)
                T.BackgroundTransparency = 1
                T.Text = title .. "  " .. (desc or "")
                T.TextColor3 = Color3.fromRGB(220, 220, 220)
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
    -- CRIAÇÃO DAS ABAS DA UI
    ------------------------------------------------------------------

    -- 1. TAB INÍCIO
    local TabHome = CreateTab("Início", "🏠")
    TabHome:AddSection("Status da Conta")
    TabHome:AddParagraph("Jogador:", LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")")
    TabHome:AddParagraph("Raça Atual:", GetPlayerRace())
    TabHome:AddParagraph("Sea Atual:", "Sea " .. tostring(GetCurrentSea()))
    TabHome:AddParagraph("Anti-AFK:", "Ativo 24/7 (Protegido)")
    TabHome:AddSection("Economia de Recursos")
    TabHome:AddToggle("Modo AFK / Black Screen (Salva CPU/Bateria)", false, function(v)
        _G.MDsHub.BlackScreenAFK = v
        RunService:Set3dRenderingEnabled(not v)
    end)
    TabHome:AddButton("Copiar Link do Repositório GitHub", function()
        if setclipboard then
            setclipboard("https://github.com/evolucaomente27-bot/MDs-Blox-HUB")
            Notify("MDs HUB", "Link copiado com sucesso!")
        end
    end)

    -- 2. TAB AUTO FARM
    local TabFarm = CreateTab("Auto Farm", "⚔️")
    TabFarm:AddSection("Configuração do Farm")
    TabFarm:AddToggle("Auto Farm Level (Principal)", false, function(v)
        _G.MDsHub.AutoFarm = v
        if not v then StopTween() end
    end)
    TabFarm:AddToggle("Ultra Fast Attack (Banana Method)", true, function(v)
        _G.MDsHub.FastAttack = v
    end)
    TabFarm:AddToggle("Bring Mobs (Agrupar Inimigos)", true, function(v)
        _G.MDsHub.BringMobs = v
    end)
    TabFarm:AddToggle("Auto Buso Haki (Armamento)", true, function(v)
        _G.MDsHub.AutoBusoHaki = v
    end)

    -- 3. TAB BOSSES (SEA 3)
    local TabBoss = CreateTab("Bosses", "👑")
    TabBoss:AddSection("Eventos & Chefes Especiais")
    TabBoss:AddToggle("Auto Cake Prince / Dough King (500 Mobs)", false, function(v)
        _G.MDsHub.AutoCakePrince = v
        if not v then StopTween() end
    end)
    TabBoss:AddToggle("Auto Elite Hunter (Sea 3)", false, function(v)
        _G.MDsHub.AutoEliteHunter = v
        if not v then StopTween() end
    end)

    -- 4. TAB RAÇAS (V1 - V4)
    local TabRace = CreateTab("Raças V1-V4", "🧬")
    TabRace:AddSection("Raça V2 & V3 (Sea 2)")
    TabRace:AddToggle("Auto Raça V2 (Alquimista + 3 Flores)", false, function(v)
        _G.MDsHub.AutoRaceV2 = v
        _G.MDsHub.AutoCollectBlueFlower = v
        _G.MDsHub.AutoCollectRedFlower = v
        _G.MDsHub.AutoFarmYellowFlower = v
        if not v then StopTween() end
    end)
    TabRace:AddToggle("Auto Raça V3 (Arowe Quests)", false, function(v)
        _G.MDsHub.AutoRaceV3 = v
        if not v then StopTween() end
    end)
    TabRace:AddSection("Raça V4 (Templo do Tempo & Mirage)")
    TabRace:AddToggle("Alerta de Mirage & Teleporte ao Pico", true, function(v)
        _G.MDsHub.AutoMirageNotifier = v
        _G.MDsHub.AutoTeleportMiragePeak = v
    end)
    TabRace:AddToggle("Auto Olhar para Lua Cheia (Ressonância V3)", false, function(v)
        _G.MDsHub.AutoLookAtMoon = v
    end)
    TabRace:AddToggle("Auto Coletar Engrenagem Azul (Blue Gear)", false, function(v)
        _G.MDsHub.AutoFindBlueGear = v
    end)
    TabRace:AddButton("Puxar Alavanca do Templo (Pull Lever)", function()
        TweenTo(RaceData.TempleOfTime.Lever)
        task.wait(1.5)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Lever" and v:IsA("ClickDetector") then
                fireclickdetector(v)
            end
        end
        Notify("Templo do Tempo", "Alavanca acionada!")
    end)
    TabRace:AddButton("Teleportar para a Porta da sua Raça", function()
        local r = GetPlayerRace()
        local cf = RaceData.TempleOfTime.Doors[r] or RaceData.TempleOfTime.Doors["Human"]
        TweenTo(cf)
        Notify("Templo", "Viajando para porta: " .. r)
    end)
    TabRace:AddToggle("Auto Completar Desafio do Trial", false, function(v)
        _G.MDsHub.AutoCompleteTrial = v
    end)
    TabRace:AddToggle("Auto Treinar Despertar V4 (Transformar)", false, function(v)
        _G.MDsHub.AutoTrainV4 = v
    end)

    -- 5. TAB FRUTAS
    local TabFruit = CreateTab("Frutas", "🍎")
    TabFruit:AddSection("Gerenciamento de Frutas")
    TabFruit:AddToggle("Auto Armazenar Frutas (Store)", true, function(v)
        _G.MDsHub.AutoStoreFruits = v
    end)
    TabFruit:AddButton("Comprar Fruta Aleatória (Cousin)", function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        Notify("Frutas", "Tentativa de compra realizada!")
    end)

    -- 6. TAB STATUS
    local TabStats = CreateTab("Status", "📊")
    TabStats:AddSection("Distribuição Automática")
    TabStats:AddToggle("Auto Melee", false, function(v) _G.MDsHub.AutoMelee = v end)
    TabStats:AddToggle("Auto Defense", false, function(v) _G.MDsHub.AutoDefense = v end)
    TabStats:AddToggle("Auto Sword", false, function(v) _G.MDsHub.AutoSword = v end)
    TabStats:AddToggle("Auto Gun", false, function(v) _G.MDsHub.AutoGun = v end)
    TabStats:AddToggle("Auto Demon Fruit", false, function(v) _G.MDsHub.AutoFruit = v end)

    -- 7. TAB JOGADOR & MISC
    local TabPlayer = CreateTab("Jogador", "🏃")
    TabPlayer:AddSection("Habilidades do Jogador")
    TabPlayer:AddToggle("NoClip (Atravessar Paredes)", false, function(v) _G.MDsHub.NoClip = v end)
    TabPlayer:AddToggle("Pulo Infinito", false, function(v) _G.MDsHub.InfiniteJump = v end)
    TabPlayer:AddToggle("Velocidade 100 (WalkSpeed)", false, function(v)
        _G.MDsHub.CustomSpeed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16
        end
    end)

    -- 8. TAB CONFIG & OTIMIZAÇÃO
    local TabConfig = CreateTab("Config", "⚙️")
    TabConfig:AddSection("Otimização & Servidor")
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
    TabConfig:AddButton("Reconectar ao Servidor (Rejoin)", function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)

    -- Abre a primeira aba por padrão
    if Tabs[1] then
        Tabs[1].Page.Visible = true
        Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        Tabs[1].Button.TextColor3 = Color3.fromRGB(20, 20, 20)
    end

    Notify("MDs HUB", "Interface Gráfica Nativa Carregada! Clique no ícone para abrir/fechar.", 5)
end

-- Inicia a Interface
task.spawn(BuildMDsHubScreenGUI)
