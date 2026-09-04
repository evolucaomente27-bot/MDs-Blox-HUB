--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                                  MDs HUB                                   ║
    ║                         Blox Fruits Universal Script                       ║
    ║                         Suporte: Sea 1, Sea 2 e Sea 3                      ║
    ║             Edição Vermelha All-in-One Multi-Hub | By GoltolaMD            ║
    ║                             Versão: 5.0 Red Edition                        ║
    ╚════════════════════════════════════════════════════════════════════════════╝
]]

-- Configurações de Inicialização Automática (Settings)
local Settings = {
    JoinTeam = "Pirates",
    Translator = true
}

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

-- Auto Join Team (Pirates)
task.spawn(function()
    pcall(function()
        if Settings.JoinTeam and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Settings.JoinTeam)
        end
    end)
end)

-- Anti-AFK integrado
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- Tabela Global de Configurações do MDs HUB
_G.MDsHub = {
    -- Auto Farm
    AutoFarm = false,
    AutoFarmNearest = false,
    AutoChests = false,
    SelectedWeapon = "Melee", -- Melee, Sword, Gun, Blox Fruit
    SelectedItem = "Auto",
    FarmDistance = 25,
    BringMobs = true,
    BringMobsRadius = 280,
    AutoBeli = false,
    
    -- Ultra Fast Attack
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
    AutoCollectFruits = false,
    AutoBuyRandomFruit = false,
    FruitBuyInterval = 300,

    -- PvP (opt-in)
    AutoPVPCombo = false,
    PVPComboStyle = "Sword",
    PVPTargetRange = 250,
    
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
    AutoTempleV4 = false,

    -- Espadas lendárias
    AutoTTKMastery = false,
    AutoCDKMastery = false,
    PreferredSword = "Auto",

    -- Multi-Hubs Integrados
    AutoLoadQuantum = false,
    AutoLoadBacon = false,
    AutoLoadRedz = false,

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
    TravelStepDistance = 350,
    TravelStepDelay = 0.12,
    IsTweening = false,
    BlackScreenAFK = false,
    FPSBoost = false
}

local CurrentTween = nil
local BodyVelocityHolder = nil
local IsTraveling = false
local DefaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

----------------------------------------------------------------------
-- FUNÇÕES DE SUPORTE & TWEEN ENGINE
----------------------------------------------------------------------

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "MDs HUB (By GoltolaMD) | " .. (title or "Aviso"),
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

-- Movimento em etapas: reduz saltos longos e permite cancelar a viagem com segurança.
local function TravelTo(targetCFrame)
    if IsTraveling then return false end

    local root = GetRootPart()
    if not root or not targetCFrame then return false end

    IsTraveling = true
    local startedAt = root.CFrame
    local distance = (startedAt.Position - targetCFrame.Position).Magnitude
    local stepDistance = math.max(100, _G.MDsHub.TravelStepDistance or 350)
    local steps = math.max(1, math.ceil(distance / stepDistance))
    local completed = true

    for step = 1, steps do
        local segmentCFrame = startedAt:Lerp(targetCFrame, step / steps)
        local tween = TweenTo(segmentCFrame)
        if not tween then
            completed = false
            break
        end

        local playbackState = tween.Completed:Wait()
        if playbackState ~= Enum.PlaybackState.Completed then
            completed = false
            break
        end
        task.wait(_G.MDsHub.TravelStepDelay or 0.12)
    end

    IsTraveling = false
    return completed
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
    IsTraveling = false
end

local function StopAllAutomations()
    local settings = _G.MDsHub
    for _, option in ipairs({
        "AutoFarm", "AutoFarmNearest", "AutoChests", "AutoEliteHunter",
        "AutoCakePrince", "AutoDoughKing", "AutoRaceV2", "AutoRaceV3",
        "AutoCollectBlueFlower", "AutoCollectRedFlower", "AutoFarmYellowFlower",
        "AutoLookAtMoon", "AutoFindBlueGear", "AutoCompleteTrial", "AutoTrainV4",
        "AutoMelee", "AutoDefense", "AutoSword", "AutoGun", "AutoFruit",
        "AutoBusoHaki", "AutoStoreFruits", "FastAttack", "AutoMirageNotifier",
        "AutoTeleportMiragePeak", "AutoTempleV4", "AutoCompleteTrial",
        "AutoTrainV4", "AutoTTKMastery", "AutoCDKMastery", "AutoBeli",
        "AutoCollectFruits", "AutoBuyRandomFruit", "AutoPVPCombo"
    }) do
        settings[option] = false
    end
    StopTween()
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

UserInputService.JumpRequest:Connect(function()
    if _G.MDsHub.InfiniteJump then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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

local function EquipAnyItem()
    local selectedItem = _G.MDsHub.SelectedItem
    for _, container in ipairs({LocalPlayer.Character, LocalPlayer.Backpack}) do
        if container and selectedItem ~= "Auto" then
            local item = container:FindFirstChild(selectedItem)
            if item and item:IsA("Tool") then
                if item.Parent == LocalPlayer.Backpack then
                    GetHumanoid():EquipTool(item)
                end
                return item
            end
        end
    end

    for _, container in ipairs({LocalPlayer.Character, LocalPlayer.Backpack}) do
        if container then
            local item = container:FindFirstChildOfClass("Tool")
            if item then
                if item.Parent == LocalPlayer.Backpack then
                    GetHumanoid():EquipTool(item)
                end
                return item
            end
        end
    end
end

local function EquipWeapon(weaponType)
    local char = GetCharacter()
    local backpack = LocalPlayer.Backpack
    local preferredSword = _G.MDsHub.PreferredSword

    if weaponType == "Any Item" then
        return EquipAnyItem()
    end

    if weaponType == "Sword" and preferredSword and preferredSword ~= "Auto" then
        for _, container in ipairs({char, backpack}) do
            local preferredTool = container:FindFirstChild(preferredSword)
            if preferredTool and preferredTool:IsA("Tool") then
                if preferredTool.Parent == backpack then
                    GetHumanoid():EquipTool(preferredTool)
                end
                return preferredTool
            end
        end
    end
    
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
        GetHumanoid():EquipTool(tool)
    end
    return tool
end

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

local function ActivateRaceV4()
    pcall(function()
        local virtualInput = game:GetService("VirtualInputManager")
        virtualInput:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
        task.wait(0.08)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
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
-- INTEGRAÇÃO DOS MULTI-HUBS SOLICITADOS
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
        loadstring(game:HttpGet('https://raw.githubusercontent.com/BaconScriptHub/BaconHub/main/New-BaconHub.lua.txt'))()
    end)
end

local function ExecuteNewRedz()
    pcall(function()
        Notify("Multi-Hub", "Carregando Redz Hub (NewRedz)...", 3)
        local redzSettings = {
            JoinTeam = "Pirates",
            Translator = true
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realreduz999/NewRedz/main/main.lua"))(redzSettings)
    end)
end

local function ExecuteAllHubs()
    Notify("Multi-Hub", "⚡ Carregando Quantum Onyx, Bacon Hub e Redz simultaneamente...", 4)
    task.spawn(ExecuteQuantumOnyx)
    task.spawn(ExecuteBaconHub)
    task.spawn(ExecuteNewRedz)
end


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

-- Preparação e treino da Raça V4. A conclusão do Trial ainda depende dos
-- requisitos do servidor (lua cheia, jogadores elegíveis e Trial aberto).
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

-- Seleciona a espada com menor maestria para que o Auto Farm existente possa
-- evoluir TTK ou CDK sem trocar de hub.
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

-- O Cursed Skeleton Boss só recebe dano de Yama ou Tushita. Quando o chefe
-- existir, usa uma das duas espadas e o sistema de ataque nativo.
task.spawn(function()
    while task.wait(0.5) do
        if _G.MDsHub.AutoCDKMastery and GetCurrentSea() == 3 then
            pcall(function()
                local enemies = Workspace:FindFirstChild("Enemies")
                local boss = enemies and (enemies:FindFirstChild("Cursed Skeleton Boss") or enemies:FindFirstChild("Cursed Skeleton"))
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
                    local sword = SelectLowestMasterySword({"Yama", "Tushita"})
                    if sword then
                        _G.MDsHub.PreferredSword = sword
                        TravelTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 22, 0))
                        EquipNamedSword(sword)
                        ExecuteFastAttack()
                    end
                end
            end)
        end
    end
end)

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

-- Beli vem da derrota de NPCs; este modo prioriza o inimigo vivo mais próximo.
task.spawn(function()
    while task.wait(0.4) do
        if _G.MDsHub.AutoBeli and not _G.MDsHub.AutoFarm and not IsTraveling then
            pcall(function()
                local mob = FindNearestMob()
                local mobRoot = mob and mob:FindFirstChild("HumanoidRootPart")
                if mobRoot then
                    TravelTo(mobRoot.CFrame * CFrame.new(0, _G.MDsHub.FarmDistance, 0))
                    EquipWeapon(_G.MDsHub.SelectedWeapon)
                    if _G.MDsHub.FastAttack then
                        ExecuteFastAttack()
                    end
                end
            end)
        end
    end
end)

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
            local isFruit = object:FindFirstChild("Fruit")
                or object.Name:lower():find("fruit")
                or object.ToolTip == "Blox Fruit"
            if isFruit and not heldByPlayer then
                return object:FindFirstChild("Handle") or object:FindFirstChildWhichIsA("BasePart")
            end
        elseif object:IsA("BasePart") and object.Name:lower():find("fruit") then
            return object
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        if _G.MDsHub.AutoCollectFruits and not IsTraveling then
            pcall(function()
                local fruitPart = GetWorldFruitPart()
                if fruitPart and TravelTo(fruitPart.CFrame) then
                    local root = GetRootPart()
                    firetouchinterest(root, fruitPart, 0)
                    firetouchinterest(root, fruitPart, 1)
                    Notify("Frutas", "Fruta encontrada: tentando coletar.", 3)
                end
            end)
        end
    end
end)

task.spawn(function()
    local lastPurchase = 0
    while task.wait(1) do
        if _G.MDsHub.AutoBuyRandomFruit and os.clock() - lastPurchase >= _G.MDsHub.FruitBuyInterval then
            lastPurchase = os.clock()
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
                Notify("Frutas", "Tentativa de compra aleatória realizada.", 3)
            end)
        end
    end
end)

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

    local comboStyle = _G.MDsHub.PVPComboStyle
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

    local virtualInput = game:GetService("VirtualInputManager")
    for _, keyName in ipairs(keys) do
        local keyCode = Enum.KeyCode[keyName]
        virtualInput:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.1)
        virtualInput:SendKeyEvent(false, keyCode, false, game)
        task.wait(0.2)
    end
    return true
end

task.spawn(function()
    while task.wait(3.5) do
        if _G.MDsHub.AutoPVPCombo then
            pcall(function()
                local target = FindNearestPVPTarget(_G.MDsHub.PVPTargetRange)
                if target then
                    ExecutePVPCombo(target)
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

-- Distribui os pontos apenas nas categorias habilitadas na aba Status.
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            local stats = {
                {enabled = "AutoMelee", name = "Melee"},
                {enabled = "AutoDefense", name = "Defense"},
                {enabled = "AutoSword", name = "Sword"},
                {enabled = "AutoGun", name = "Gun"},
                {enabled = "AutoFruit", name = "Demon Fruit"}
            }
            for _, stat in ipairs(stats) do
                if _G.MDsHub[stat.enabled] then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat.name, _G.MDsHub.StatPoints)
                end
            end
        end)
    end
end)

----------------------------------------------------------------------
-- INTERFACE GRÁFICA VERMELHA NATIVA (RED EDITION BY GOLTOLAMD)
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

    -- Paleta de Cores Vermelha (Crimson / Neon Red Theme)
    local Theme = {
        Background = Color3.fromRGB(15, 12, 14),
        Header = Color3.fromRGB(24, 16, 19),
        Sidebar = Color3.fromRGB(18, 14, 16),
        PrimaryRed = Color3.fromRGB(255, 35, 60),    -- Vermelho Neon Vibrante
        DarkRed = Color3.fromRGB(180, 20, 40),
        ButtonBg = Color3.fromRGB(32, 20, 24),
        CardBg = Color3.fromRGB(24, 18, 22),
        TextLight = Color3.fromRGB(255, 240, 245),
        TextDim = Color3.fromRGB(170, 150, 160)
    }

    -- Botão Flutuante (Floating Red Icon)
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

    -- Janela Principal Vermelha
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 610, 0, 365)
    MainFrame.Position = UDim2.new(0.5, -305, 0.5, -182)
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

    -- Cabeçalho Vermelho (Header)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 46)
    Header.BackgroundColor3 = Theme.Header
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 220, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "🔥 MDs HUB"
    TitleLabel.TextColor3 = Theme.PrimaryRed
    TitleLabel.TextSize = 19
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Size = UDim2.new(0, 240, 1, 0)
    SubTitleLabel.Position = UDim2.new(0, 145, 0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = "• By GoltolaMD (Red Edition)"
    SubTitleLabel.TextColor3 = Color3.fromRGB(255, 120, 140)
    SubTitleLabel.TextSize = 13
    SubTitleLabel.Font = Enum.Font.GothamSemibold
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 8)
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
        PagePadding.PaddingBottom = UDim.new(0, 10)
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
                ToggleFrame.Size = UDim2.new(0.94, 0, 0, 36)
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
                Switch.Size = UDim2.new(0, 44, 0, 22)
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
                end)
            end,

            AddChoice = function(self, labelText, choices, defaultValue, callback)
                local ChoiceFrame = Instance.new("Frame")
                ChoiceFrame.Size = UDim2.new(0.94, 0, 0, 36)
                ChoiceFrame.BackgroundColor3 = Theme.CardBg
                ChoiceFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = ChoiceFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Theme.TextLight
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ChoiceFrame

                local ChoiceButton = Instance.new("TextButton")
                ChoiceButton.Size = UDim2.new(0.34, 0, 0, 24)
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
                    ChoiceButton.Text = choices[index]
                    if callback then callback(choices[index]) end
                end
                UpdateChoice()

                ChoiceButton.MouseButton1Click:Connect(function()
                    index = (index % #choices) + 1
                    UpdateChoice()
                end)
            end,

            AddStepper = function(self, labelText, minimum, maximum, increment, defaultValue, callback)
                local StepperFrame = Instance.new("Frame")
                StepperFrame.Size = UDim2.new(0.94, 0, 0, 36)
                StepperFrame.BackgroundColor3 = Theme.CardBg
                StepperFrame.Parent = TabPage

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = StepperFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.54, 0, 1, 0)
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
                ValueLabel.Size = UDim2.new(0, 42, 0, 24)
                ValueLabel.Position = UDim2.new(1, -64, 0.5, -12)
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

                local Minus = CreateStepButton("−", -96)
                local Plus = CreateStepButton("+", -32)
                local function UpdateValue()
                    value = math.max(minimum, math.min(maximum, value))
                    ValueLabel.Text = tostring(value)
                    if callback then callback(value) end
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

            AddButton = function(self, labelText, callback)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0.94, 0, 0, 34)
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
                SectionLabel.Size = UDim2.new(0.94, 0, 0, 24)
                SectionLabel.BackgroundTransparency = 1
                SectionLabel.Text = "── " .. sectionText .. " ──"
                SectionLabel.TextColor3 = Theme.PrimaryRed
                SectionLabel.TextSize = 12
                SectionLabel.Font = Enum.Font.GothamBold
                SectionLabel.Parent = TabPage
            end,

            AddParagraph = function(self, title, desc)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(0.94, 0, 0, 36)
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
    -- CRIAÇÃO DAS ABAS DA UI VERMELHA
    ------------------------------------------------------------------

    -- 1. TAB INÍCIO
    local TabHome = CreateTab("Início", "🏠")
    TabHome:AddSection("Criador & Informações")
    TabHome:AddParagraph("Criador:", "By GoltolaMD")
    TabHome:AddParagraph("Jogador:", LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")")
    TabHome:AddParagraph("Time Atual:", "Piratas (Auto-Joined)")
    TabHome:AddParagraph("Raça Atual:", GetPlayerRace())
    TabHome:AddParagraph("Sea Atual:", "Sea " .. tostring(GetCurrentSea()))
    TabHome:AddSection("Economia de Recursos")
    TabHome:AddToggle("Modo AFK / Black Screen (Economiza CPU/Bateria)", false, function(v)
        _G.MDsHub.BlackScreenAFK = v
        RunService:Set3dRenderingEnabled(not v)
    end)
    TabHome:AddButton("Copiar Link do Repositório GitHub", function()
        if setclipboard then
            setclipboard("https://github.com/evolucaomente27-bot/MDs-Blox-HUB")
            Notify("MDs HUB", "Link copiado com sucesso!")
        end
    end)

    -- 2. TAB MULTI-HUBS INTEGRADOS (TODOS OS SCRIPTS SOLICITADOS)
    local TabMulti = CreateTab("Multi-Hubs", "🚀")
    TabMulti:AddSection("Hubs Integrados no MDs")
    TabMulti:AddButton("🟣 Executar Quantum Onyx Hub", function()
        ExecuteQuantumOnyx()
    end)
    TabMulti:AddButton("🥓 Executar Bacon Hub", function()
        ExecuteBaconHub()
    end)
    TabMulti:AddButton("🔴 Executar Redz Hub (NewRedz - Pirates)", function()
        ExecuteNewRedz()
    end)
    TabMulti:AddSection("Auto-Execução em Segundo Plano")
    TabMulti:AddToggle("Auto Iniciar Quantum Onyx ao Abrir", false, function(v)
        _G.MDsHub.AutoLoadQuantum = v
        if v then ExecuteQuantumOnyx() end
    end)
    TabMulti:AddToggle("Auto Iniciar Bacon Hub ao Abrir", false, function(v)
        _G.MDsHub.AutoLoadBacon = v
        if v then ExecuteBaconHub() end
    end)
    TabMulti:AddToggle("Auto Iniciar Redz Hub ao Abrir", false, function(v)
        _G.MDsHub.AutoLoadRedz = v
        if v then ExecuteNewRedz() end
    end)

    -- 3. TAB AUTO FARM
    local TabFarm = CreateTab("Auto Farm", "⚔️")
    TabFarm:AddSection("Configuração do Farm")
    TabFarm:AddToggle("Auto Farm Level (Principal)", false, function(v)
        _G.MDsHub.AutoFarm = v
        if not v then StopTween() end
    end)
    TabFarm:AddChoice("Arma para o Farm", {"Melee", "Sword", "Gun", "Blox Fruit", "Any Item"}, _G.MDsHub.SelectedWeapon, function(value)
        _G.MDsHub.SelectedWeapon = value
    end)
    TabFarm:AddChoice("Item personalizado", GetOwnedToolNames(), _G.MDsHub.SelectedItem, function(value)
        _G.MDsHub.SelectedItem = value
    end)
    TabFarm:AddButton("Atualizar lista de itens", function()
        BuildMDsHubScreenGUI()
    end)
    TabFarm:AddStepper("Distância do alvo", 10, 60, 5, _G.MDsHub.FarmDistance, function(value)
        _G.MDsHub.FarmDistance = value
    end)
    TabFarm:AddToggle("Ultra Fast Attack (Banana Method)", true, function(v)
        _G.MDsHub.FastAttack = v
    end)
    TabFarm:AddStepper("Ataques por ciclo", 1, 8, 1, _G.MDsHub.MultiHitCount, function(value)
        _G.MDsHub.MultiHitCount = value
    end)
    TabFarm:AddToggle("Bring Mobs (Agrupar Inimigos)", true, function(v)
        _G.MDsHub.BringMobs = v
    end)
    TabFarm:AddStepper("Raio do Bring Mobs", 50, 350, 25, _G.MDsHub.BringMobsRadius, function(value)
        _G.MDsHub.BringMobsRadius = value
    end)
    TabFarm:AddToggle("Auto Buso Haki (Armamento)", true, function(v)
        _G.MDsHub.AutoBusoHaki = v
    end)
    TabFarm:AddToggle("Auto Beli (NPC mais próximo)", false, function(v)
        _G.MDsHub.AutoBeli = v
    end)

    -- 4. TAB BOSSES (SEA 3)
    local TabBoss = CreateTab("Bosses", "👑")
    TabBoss:AddSection("Eventos & Chefes Especiais")
    TabBoss:AddToggle("Auto Cake Prince (500 Mobs)", false, function(v)
        _G.MDsHub.AutoCakePrince = v
        if not v then StopTween() end
    end)
    TabBoss:AddToggle("Auto Dough King (500 Mobs)", false, function(v)
        _G.MDsHub.AutoDoughKing = v
        if not v then StopTween() end
    end)
    TabBoss:AddToggle("Auto Elite Hunter (Sea 3)", false, function(v)
        _G.MDsHub.AutoEliteHunter = v
        if not v then StopTween() end
    end)

    -- 5. TAB RAÇAS (V1 - V4)
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
        TravelTo(RaceData.TempleOfTime.Lever)
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
        TravelTo(cf)
        Notify("Templo", "Viajando para porta: " .. r)
    end)
    TabRace:AddToggle("Preparar Trial V4 (Templo + Porta)", false, function(v)
        _G.MDsHub.AutoCompleteTrial = v
    end)
    TabRace:AddToggle("Auto Treinar Despertar V4 (Transformar)", false, function(v)
        _G.MDsHub.AutoTrainV4 = v
    end)
    TabRace:AddToggle("Auto Ir ao Templo do Tempo", false, function(v)
        _G.MDsHub.AutoTempleV4 = v
    end)
    TabRace:AddButton("Ir para a porta do Trial da raça", function()
        if TravelToRaceTrialDoor() then
            Notify("Raça V4", "Porta do Trial preparada para " .. GetPlayerRace())
        else
            Notify("Raça V4", "Não foi possível iniciar a viagem ao Trial.")
        end
    end)

    -- 6. TAB ESPADAS
    local TabSword = CreateTab("Espadas", "⚔")
    TabSword:AddSection("Maestria e objetivos")
    TabSword:AddParagraph("TTK:", "Saddi, Shisui e Wando com maestria 300; depois fale com o Mysterious Man.")
    TabSword:AddParagraph("CDK:", "Yama e Tushita com maestria 350, nível 2200+ e os Trials concluídos.")
    TabSword:AddChoice("Espada preferida", {"Auto", "Saddi", "Shisui", "Wando", "Yama", "Tushita", "True Triple Katana", "Cursed Dual Katana"}, _G.MDsHub.PreferredSword, function(value)
        _G.MDsHub.PreferredSword = value
        if value ~= "Auto" then
            _G.MDsHub.SelectedWeapon = "Sword"
        end
    end)
    TabSword:AddToggle("Auto maestria TTK", false, function(v)
        _G.MDsHub.AutoTTKMastery = v
        if v then _G.MDsHub.AutoCDKMastery = false end
    end)
    TabSword:AddToggle("Auto maestria CDK", false, function(v)
        _G.MDsHub.AutoCDKMastery = v
        if v then _G.MDsHub.AutoTTKMastery = false end
    end)
    TabSword:AddButton("Equipar espada selecionada", function()
        local sword = _G.MDsHub.PreferredSword
        if sword == "Auto" or not EquipNamedSword(sword) then
            Notify("Espadas", "A espada selecionada não está no inventário.")
        else
            Notify("Espadas", sword .. " equipada.")
        end
    end)

    -- 7. TAB PVP
    local TabPVP = CreateTab("PvP", "⚡")
    TabPVP:AddSection("Combo automático")
    TabPVP:AddParagraph("Alvo:", "Somente jogador inimigo mais próximo dentro do alcance definido.")
    TabPVP:AddChoice("Estilo de combo", {"Melee", "Sword", "Blox Fruit"}, _G.MDsHub.PVPComboStyle, function(value)
        _G.MDsHub.PVPComboStyle = value
    end)
    TabPVP:AddStepper("Alcance máximo do alvo", 50, 500, 25, _G.MDsHub.PVPTargetRange, function(value)
        _G.MDsHub.PVPTargetRange = value
    end)
    TabPVP:AddToggle("Auto PvP Combo", false, function(v)
        _G.MDsHub.AutoPVPCombo = v
    end)
    TabPVP:AddButton("Executar combo no alvo próximo", function()
        local target = FindNearestPVPTarget(_G.MDsHub.PVPTargetRange)
        if target and ExecutePVPCombo(target) then
            Notify("PvP", "Combo aplicado em " .. target.DisplayName)
        else
            Notify("PvP", "Nenhum alvo inimigo dentro do alcance.")
        end
    end)

    -- 8. TAB FRUTAS
    local TabFruit = CreateTab("Frutas", "🍎")
    TabFruit:AddSection("Gerenciamento de Frutas")
    TabFruit:AddToggle("Auto Armazenar Frutas (Store)", true, function(v)
        _G.MDsHub.AutoStoreFruits = v
    end)
    TabFruit:AddToggle("Auto Coletar Frutas do mapa", false, function(v)
        _G.MDsHub.AutoCollectFruits = v
    end)
    TabFruit:AddStepper("Intervalo compra aleatória (seg.)", 60, 900, 60, _G.MDsHub.FruitBuyInterval, function(value)
        _G.MDsHub.FruitBuyInterval = value
    end)
    TabFruit:AddToggle("Auto comprar Fruta Aleatória", false, function(v)
        _G.MDsHub.AutoBuyRandomFruit = v
    end)
    TabFruit:AddButton("Comprar Fruta Aleatória (Cousin)", function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        Notify("Frutas", "Tentativa de compra realizada!")
    end)

    -- 7. TAB STATUS
    local TabStats = CreateTab("Status", "📊")
    TabStats:AddSection("Distribuição Automática")
    TabStats:AddToggle("Auto Melee", false, function(v) _G.MDsHub.AutoMelee = v end)
    TabStats:AddToggle("Auto Defense", false, function(v) _G.MDsHub.AutoDefense = v end)
    TabStats:AddToggle("Auto Sword", false, function(v) _G.MDsHub.AutoSword = v end)
    TabStats:AddToggle("Auto Gun", false, function(v) _G.MDsHub.AutoGun = v end)
    TabStats:AddToggle("Auto Demon Fruit", false, function(v) _G.MDsHub.AutoFruit = v end)
    TabStats:AddStepper("Pontos por distribuição", 1, 10, 1, _G.MDsHub.StatPoints, function(value)
        _G.MDsHub.StatPoints = value
    end)

    -- 8. TAB JOGADOR & MISC
    local TabPlayer = CreateTab("Jogador", "🏃")
    TabPlayer:AddSection("Habilidades do Jogador")
    TabPlayer:AddToggle("NoClip (Atravessar Paredes)", false, function(v) _G.MDsHub.NoClip = v end)
    TabPlayer:AddToggle("Pulo Infinito", false, function(v) _G.MDsHub.InfiniteJump = v end)
    TabPlayer:AddStepper("WalkSpeed", 16, 100, 4, _G.MDsHub.WalkSpeed, function(value)
        _G.MDsHub.WalkSpeed = value
        if _G.MDsHub.CustomSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
    TabPlayer:AddToggle("Velocidade personalizada", false, function(v)
        _G.MDsHub.CustomSpeed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v and _G.MDsHub.WalkSpeed or 16
        end
    end)
    TabPlayer:AddStepper("JumpPower", 50, 150, 10, _G.MDsHub.JumpPower, function(value)
        _G.MDsHub.JumpPower = value
        if _G.MDsHub.CustomJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
    TabPlayer:AddToggle("Pulo personalizado", false, function(v)
        _G.MDsHub.CustomJump = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v and _G.MDsHub.JumpPower or 50
        end
    end)
    TabPlayer:AddToggle("Full Bright", false, SetFullBright)

    -- 9. TAB CONFIG & OTIMIZAÇÃO
    local TabConfig = CreateTab("Config", "⚙️")
    TabConfig:AddSection("Otimização & Servidor")
    TabConfig:AddStepper("Distância por etapa de viagem", 100, 600, 50, _G.MDsHub.TravelStepDistance, function(value)
        _G.MDsHub.TravelStepDistance = value
    end)
    TabConfig:AddButton("Parar todas as automações", function()
        StopAllAutomations()
        Notify("Config", "Todas as automações nativas foram interrompidas.")
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
    TabConfig:AddButton("Reconectar ao Servidor (Rejoin)", function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)

    if Tabs[1] then
        Tabs[1].Page.Visible = true
        Tabs[1].Button.BackgroundColor3 = Theme.PrimaryRed
        Tabs[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    Notify("MDs HUB", "🔥 Red Edition By GoltolaMD carregada com sucesso!", 5)
end

-- Inicia a Interface Vermelha
task.spawn(BuildMDsHubScreenGUI)
