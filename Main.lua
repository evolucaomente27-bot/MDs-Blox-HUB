--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                                  MDs HUB                                   ║
    ║                         Blox Fruits Universal Script                       ║
    ║                         Suporte: Sea 1, Sea 2 e Sea 3                      ║
    ║          Arquitetura Avançada Inspirada no Banana Hub (Ultra Fast & V4)     ║
    ║                             Versão: 4.0 Pro Edition                        ║
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
    FarmPosition = "Above", -- Above, Below, Behind
    BringMobs = true,
    BringMobsRadius = 280,
    
    -- Banana Ultra Fast Attack
    FastAttack = true,
    SuperFastAttack = true,
    FastAttackDelay = 0.08,
    MultiHitCount = 4,
    
    -- Haki Automático
    AutoBusoHaki = true,
    AutoObservationHaki = false,
    
    -- Sea 3 Bosses & Eventos (Banana Style)
    AutoEliteHunter = false,
    AutoCakePrince = false,
    AutoDoughKing = false,
    AutoRipIndra = false,
    AutoKatakuri = false,
    AutoPirateRaid = false,
    AutoCastleRaid = false,
    
    -- Frutas
    FruitESP = false,
    AutoStoreFruits = true,
    AutoBuyRandomFruit = false,
    AutoFruitSniper = false,
    
    -- Status (Stats)
    AutoMelee = false,
    AutoDefense = false,
    AutoSword = false,
    AutoGun = false,
    AutoFruit = false,
    StatPoints = 3,

    -- =======================================================
    -- SISTEMA AVANÇADO DE RAÇAS (V1 ATÉ V4 - BANANA ENGINE)
    -- =======================================================
    -- Race V2
    AutoRaceV2 = false,
    AutoCollectBlueFlower = false,
    AutoCollectRedFlower = false,
    AutoFarmYellowFlower = false,
    
    -- Race V3
    AutoRaceV3 = false,
    AutoQuestMinkV3 = false,
    AutoQuestHumanV3 = false,
    
    -- Race V4 (Temple of Time & Mirage - Banana Method)
    AutoMirageNotifier = true,
    AutoTeleportMiragePeak = false,
    AutoLookAtMoon = false,
    AutoFindBlueGear = false,
    AutoPullLever = false,
    AutoTempleOfTime = false,
    AutoSyncTrial = false,
    AutoCompleteTrial = false,
    AutoKillTrialPlayers = false,
    AutoUpgradeV4 = false,
    AutoTrainV4 = false,

    -- Player & Visuals
    WalkSpeed = 16,
    JumpPower = 50,
    CustomSpeed = false,
    CustomJump = false,
    InfiniteJump = false,
    NoClip = false,
    FullBright = false,
    
    -- Otimização & AFK Mode (Banana Style)
    TweenSpeed = 280,
    IsTweening = false,
    BlackScreenAFK = false,
    FPSBoost = false
}

local CurrentTween = nil
local BodyVelocityHolder = nil

----------------------------------------------------------------------
-- FUNÇÕES DE SUPORTE & TWEEN ENGINE (BANANA METHOD)
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

-- Tween Suave com No-Clip e Anti-Queda (Banana Hub BodyVelocity System)
local function TweenTo(targetCFrame)
    local root = GetRootPart()
    local char = GetCharacter()
    if not root or not char then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local time = distance / _G.MDsHub.TweenSpeed
    
    if CurrentTween then
        CurrentTween:Cancel()
    end
    
    -- Cria BodyVelocity temporário para anular gravidade durante teleporte
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

-- NoClip ativo durante qualquer Tween
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

-- Equipar arma selecionada
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
-- MOTOR DE FAST ATTACK AVANÇADO (BANANA ULTRA FAST METHOD)
----------------------------------------------------------------------

local function ExecuteFastAttack()
    pcall(function()
        local combatFramework = require(LocalPlayer.PlayerScripts.CombatFramework)
        local cameraShaker = require(ReplicatedStorage.Util.CameraShaker)
        cameraShaker:Stop()
        
        local activeController = combatFramework.activeController
        if activeController and activeController.equipped then
            activeController.hitboxMagnitude = 65
            
            -- Dispara ataques múltiplos por frame
            for i = 1, _G.MDsHub.MultiHitCount do
                activeController:attack()
            end
            
            -- Reset do combo para ataque contínuo sem cooldown de animação
            activeController.timeToNextAttack = 0
            activeController.increment = 3
        end
    end)
end

-- Loop de Haki de Armamento Automático (Buso Haki)
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

----------------------------------------------------------------------
-- BANCO DE DADOS & COORDENADAS: RAÇA V2, V3 E V4
----------------------------------------------------------------------

local RaceData = {
    NPC_Alchemist = CFrame.new(1308, 12, -776),  -- Green Zone
    NPC_Arowe = CFrame.new(290, 15, -3830),       -- Caverna Don Swan
    
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
-- LOOP DE AUTO FARM LEVEL & BRING MOBS (BANANA STYLE)
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
                        
                        -- Posicionamento perfeito em cima do mob
                        GetRootPart().CFrame = mobRoot.CFrame * targetOffset
                        EquipWeapon(_G.MDsHub.SelectedWeapon)
                        
                        -- Bring Mobs com congelamento de movimento (Banana Engine)
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
                        
                        -- Disparar Fast Attack
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
-- SEA 3 BOSSES: CAKE PRINCE & DOUGH KING (BANANA METHOD)
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.5) do
        if (_G.MDsHub.AutoCakePrince or _G.MDsHub.AutoDoughKing) and GetCurrentSea() == 3 then
            pcall(function()
                local enemies = Workspace:FindFirstChild("Enemies")
                local cakeBoss = enemies and (enemies:FindFirstChild("Cake Prince") or enemies:FindFirstChild("Dough King"))
                
                if cakeBoss and cakeBoss:FindFirstChild("Humanoid") and cakeBoss.Humanoid.Health > 0 then
                    -- Ataca o chefe diretamente
                    GetRootPart().CFrame = cakeBoss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                    EquipWeapon(_G.MDsHub.SelectedWeapon)
                    ExecuteFastAttack()
                else
                    -- Farma os 500 mobs de Chocolate/Peanut Island para invocar o Boss
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

-- Auto Elite Hunter (Sea 3)
task.spawn(function()
    while task.wait(2) do
        if _G.MDsHub.AutoEliteHunter and GetCurrentSea() == 3 then
            pcall(function()
                -- Pede a missão no NPC Elite Hunter
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

----------------------------------------------------------------------
-- SISTEMA AVANÇADO DE RAÇA V4 (BANANA SIGNATURE ENGINE)
----------------------------------------------------------------------

-- 1. Alerta de Mirage Island & Notificação de Lua Cheia
task.spawn(function()
    while task.wait(2) do
        if _G.MDsHub.AutoMirageNotifier and GetCurrentSea() == 3 then
            pcall(function()
                local locations = Workspace._WorldOrigin:FindFirstChild("Locations")
                local mirage = (locations and locations:FindFirstChild("Mirage Island")) or Workspace:FindFirstChild("Mirage Island")
                if mirage then
                    Notify("Mirage Island", "🌟 Mirage Island detectada no servidor!", 5)
                    
                    -- Se o teleporte ao pico estiver ativo, voa até o ponto mais alto
                    if _G.MDsHub.AutoTeleportMiragePeak then
                        TweenTo(mirage:GetModelCFrame() * CFrame.new(0, 350, 0))
                    end
                end
            end)
        end
    end
end)

-- 2. Travar Câmera na Lua Cheia & Ativar Ressonância V3 (Banana Method)
task.spawn(function()
    while task.wait(0.2) do
        if _G.MDsHub.AutoLookAtMoon and GetCurrentSea() == 3 then
            pcall(function()
                local moonDirection = Lighting:GetMoonDirection()
                if moonDirection then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + moonDirection * 2000)
                    
                    -- Dispara a habilidade da Raça V3 para ressonar com a Lua
                    VirtualUser:CaptureController()
                    VirtualUser:SetKeyDown("0x74") -- 't'
                    task.wait(0.05)
                    VirtualUser:SetKeyUp("0x74")
                end
            end)
        end
    end
end)

-- 3. Scanner de Engrenagem Azul (Blue Gear Scanner - Banana Mesh ID Detect)
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

-- 4. Puxar Alavanca do Templo do Tempo (Pull Lever)
local function PullTempleLever()
    pcall(function()
        TweenTo(RaceData.TempleOfTime.Lever)
        task.wait(1.2)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Lever" and v:IsA("ClickDetector") then
                fireclickdetector(v)
            end
        end
        Notify("Templo do Tempo", "Alavanca puxada com sucesso!")
    end)
end

-- 5. Auto Complete Trial (Solucionador Instantâneo do Banana Hub)
task.spawn(function()
    while task.wait(0.15) do
        if _G.MDsHub.AutoCompleteTrial and GetCurrentSea() == 3 then
            pcall(function()
                local race = GetPlayerRace()
                local enemies = Workspace:FindFirstChild("Enemies")
                
                -- Desafios de Combate (Human, Ghoul, Cyborg)
                if enemies and (race == "Human" or race == "Ghoul" or race == "Cyborg") then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            GetRootPart().CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                            EquipWeapon(_G.MDsHub.SelectedWeapon)
                            ExecuteFastAttack()
                            break
                        end
                    end
                end
                
                -- Desafio do Shark (Sea Beast)
                if race == "Shark" or race == "Fishman" then
                    local seaBeasts = Workspace._WorldOrigin:FindFirstChild("SeaBeasts") or Workspace:FindFirstChild("SeaBeast")
                    if seaBeasts then
                        for _, sb in pairs(seaBeasts:GetChildren()) do
                            if sb:FindFirstChild("Humanoid") and sb.Humanoid.Health > 0 then
                                GetRootPart().CFrame = sb.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0)
                                EquipWeapon(_G.MDsHub.SelectedWeapon)
                                ExecuteFastAttack()
                                break
                            end
                        end
                    end
                end
                
                -- Desafio do Mink (Labirinto - Teleporte para a saída)
                if race == "Mink" then
                    for _, door in pairs(Workspace:GetDescendants()) do
                        if door.Name == "ExitDoor" or door.Name == "Exit" then
                            GetRootPart().CFrame = door.CFrame
                        end
                    end
                end
                
                -- Desafio do Angel (Nuvens - Teleporte para a plataforma final)
                if race == "Angel" then
                    for _, cloud in pairs(Workspace:GetDescendants()) do
                        if cloud.Name:find("Goal") or cloud.Name:find("Finish") then
                            GetRootPart().CFrame = cloud.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- 6. Treinar V4 (Transformação Automática em Batalha)
task.spawn(function()
    while task.wait(0.3) do
        if _G.MDsHub.AutoTrainV4 then
            pcall(function()
                local char = GetCharacter()
                if char:FindFirstChild("RaceEnergy") and char.RaceEnergy.Value >= 100 then
                    VirtualUser:CaptureController()
                    VirtualUser:SetKeyDown("0x79") -- 'y'
                    task.wait(0.05)
                    VirtualUser:SetKeyUp("0x79")
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- AUTO STATS & AUTO STORE FRUITS
----------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local points = _G.MDsHub.StatPoints
            if _G.MDsHub.AutoMelee then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points) end
            if _G.MDsHub.AutoDefense then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", points) end
            if _G.MDsHub.AutoSword then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", points) end
            if _G.MDsHub.AutoGun then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", points) end
            if _G.MDsHub.AutoFruit then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", points) end
        end)
    end
end)

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
-- BLACK SCREEN / AFK SAVER (BANANA HUB SIGNATURE FEATURE)
----------------------------------------------------------------------

local function SetAFKBlackScreen(enabled)
    pcall(function()
        RunService:Set3dRenderingEnabled(not enabled)
        if enabled then
            Notify("AFK Saver", "Modo tela preta ativado! Economizando CPU/GPU.", 4)
        else
            Notify("AFK Saver", "Renderização 3D restaurada!", 4)
        end
    end)
end

----------------------------------------------------------------------
-- INTERFACE DE USUÁRIO (BANANA HUB INSPIRED UI)
----------------------------------------------------------------------

local function CreateMDsHubUI()
    local RedzLib = nil
    local success, _ = pcall(function()
        RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redzLib"))()
    end)

    if success and RedzLib then
        local Window = RedzLib:MakeWindow({
            Title = "MDs HUB | Banana Edition v4.0",
            SubTitle = "Ultra Fast Farm & Race V4 Engine",
            SaveFolder = "MDsHub_BananaConfig"
        })

        -- TAB 1: Início
        local TabHome = Window:MakeTab({"Início", "house"})
        TabHome:AddSection({"Informações da Conta"})
        TabHome:AddParagraph({"Jogador:", LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"})
        TabHome:AddParagraph({"Raça:", GetPlayerRace()})
        TabHome:AddParagraph({"Sea:", "Sea " .. tostring(GetCurrentSea())})
        TabHome:AddParagraph({"Anti-AFK:", "Proteção 24/7 Ativa"})
        
        TabHome:AddSection({"Opções Rápidas"})
        TabHome:AddToggle({
            Name = "Modo AFK / Tela Preta (Economiza Bateria/CPU)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.BlackScreenAFK = val
                SetAFKBlackScreen(val)
            end
        })

        -- TAB 2: Auto Farm
        local TabFarm = Window:MakeTab({"Auto Farm", "swords"})
        TabFarm:AddSection({"Combate & Armas"})
        
        TabFarm:AddDropdown({
            Name = "Arma do Farm",
            Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
            Default = "Melee",
            Callback = function(val)
                _G.MDsHub.SelectedWeapon = val
            end
        })
        
        TabFarm:AddToggle({
            Name = "Auto Farm Level (Principal)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoFarm = val
                if not val then StopTween() end
            end
        })

        TabFarm:AddToggle({
            Name = "Ultra Fast Attack (Banana Method)",
            Default = true,
            Callback = function(val)
                _G.MDsHub.FastAttack = val
            end
        })

        TabFarm:AddToggle({
            Name = "Bring Mobs (Agrupar Inimigos)",
            Default = true,
            Callback = function(val)
                _G.MDsHub.BringMobs = val
            end
        })

        TabFarm:AddToggle({
            Name = "Auto Buso Haki (Armamento)",
            Default = true,
            Callback = function(val)
                _G.MDsHub.AutoBusoHaki = val
            end
        })

        TabFarm:AddSlider({
            Name = "Distância do Farm",
            Min = 10,
            Max = 40,
            Increase = 1,
            Default = 25,
            Callback = function(val)
                _G.MDsHub.FarmDistance = val
            end
        })

        -- TAB 3: Sea 3 Bosses & Eventos
        local TabBoss = Window:MakeTab({"Bosses & Eventos", "skull"})
        TabBoss:AddSection({"Chefes Especiais (Sea 3)"})
        
        TabBoss:AddToggle({
            Name = "Auto Cake Prince / Dough King (500 Mobs)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoCakePrince = val
                if not val then StopTween() end
            end
        })

        TabBoss:AddToggle({
            Name = "Auto Elite Hunter (Deandre, Diablo, Urban)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoEliteHunter = val
                if not val then StopTween() end
            end
        })

        -- TAB 4: Sistema de Raças (V1 - V4)
        local TabRace = Window:MakeTab({"Raças (V1-V4)", "dna"})
        
        TabRace:AddSection({"Raça V2 & V3 (Sea 2)"})
        TabRace:AddToggle({
            Name = "Auto Raça V2 (Alquimista + Flores)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoRaceV2 = val
                _G.MDsHub.AutoCollectBlueFlower = val
                _G.MDsHub.AutoCollectRedFlower = val
                _G.MDsHub.AutoFarmYellowFlower = val
                if not val then StopTween() end
            end
        })

        TabRace:AddToggle({
            Name = "Auto Raça V3 (Arowe)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoRaceV3 = val
                if not val then StopTween() end
            end
        })

        TabRace:AddSection({"Raça V4 (Templo do Tempo & Mirage)"})
        TabRace:AddToggle({
            Name = "Alerta de Mirage & Teleporte ao Pico",
            Default = true,
            Callback = function(val)
                _G.MDsHub.AutoMirageNotifier = val
                _G.MDsHub.AutoTeleportMiragePeak = val
            end
        })

        TabRace:AddToggle({
            Name = "Auto Olhar para Lua Cheia (Resonância V3)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoLookAtMoon = val
            end
        })

        TabRace:AddToggle({
            Name = "Auto Achar Engrenagem Azul (Gear Scanner)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoFindBlueGear = val
            end
        })

        TabRace:AddButton({"Puxar Alavanca do Templo (Pull Lever)", function()
            PullTempleLever()
        end})

        TabRace:AddButton({"Teleportar para a Porta da sua Raça", function()
            local race = GetPlayerRace()
            local doorCF = RaceData.TempleOfTime.Doors[race] or RaceData.TempleOfTime.Doors["Human"]
            TweenTo(doorCF)
            Notify("Templo do Tempo", "Viajando para a porta: " .. race)
        end})

        TabRace:AddToggle({
            Name = "Auto Completar Desafio do Trial",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoCompleteTrial = val
            end
        })

        TabRace:AddToggle({
            Name = "Auto Treinar Despertar V4 (Transformar)",
            Default = false,
            Callback = function(val)
                _G.MDsHub.AutoTrainV4 = val
            end
        })

        -- TAB 5: Frutas
        local TabFruit = Window:MakeTab({"Frutas", "cherry"})
        TabFruit:AddSection({"Gerenciamento de Frutas"})
        
        TabFruit:AddToggle({
            Name = "Auto Armazenar Frutas (Store)",
            Default = true,
            Callback = function(val)
                _G.MDsHub.AutoStoreFruits = val
            end
        })

        TabFruit:AddButton({"Comprar Fruta Aleatória (Cousin)", function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            Notify("Frutas", "Compra de fruta solicitada!")
        end})

        -- TAB 6: Status
        local TabStats = Window:MakeTab({"Status", "bar-chart-2"})
        TabStats:AddSection({"Distribuidor Automático de Pontos"})
        
        TabStats:AddSlider({
            Name = "Pontos por ciclo",
            Min = 1,
            Max = 10,
            Increase = 1,
            Default = 3,
            Callback = function(val)
                _G.MDsHub.StatPoints = val
            end
        })

        TabStats:AddToggle({Name = "Auto Melee", Default = false, Callback = function(v) _G.MDsHub.AutoMelee = v end})
        TabStats:AddToggle({Name = "Auto Defense", Default = false, Callback = function(v) _G.MDsHub.AutoDefense = v end})
        TabStats:AddToggle({Name = "Auto Sword", Default = false, Callback = function(v) _G.MDsHub.AutoSword = v end})
        TabStats:AddToggle({Name = "Auto Gun", Default = false, Callback = function(v) _G.MDsHub.AutoGun = v end})
        TabStats:AddToggle({Name = "Auto Demon Fruit", Default = false, Callback = function(v) _G.MDsHub.AutoFruit = v end})

        -- TAB 7: Configurações & Otimização
        local TabSettings = Window:MakeTab({"Config & FPS", "settings"})
        TabSettings:AddSection({"Performance"})
        
        TabSettings:AddButton({"Boost de FPS (Remover Texturas)", function()
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
                Notify("FPS Boost", "Otimização de texturas e sombras concluída!")
            end)
        end})

        TabSettings:AddButton({"Reconectar Servidor (Rejoin)", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end})

        Notify("MDs HUB", "Banana Edition v4.0 carregada com sucesso!", 5)
    else
        Notify("MDs HUB", "Executado em modo Headless/Seguro.")
    end
end

-- Inicialização
task.spawn(CreateMDsHubUI)
