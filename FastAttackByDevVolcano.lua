local skibidi = getgenv and getgenv() or getrenv and getrenv() or getfenv and getfenv()
local replicatedstorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local client = players.LocalPlayer
local modulepath = replicatedstorage:WaitForChild("Modules")
local net = modulepath:WaitForChild("Net")
local characterfolder = workspace:WaitForChild("Characters")
local enemyfolder = workspace:WaitForChild("Enemies")

local Module = { 
    AttackCooldown = 0,
    HitSetting = {
        CanHitPlayer = true,
        CanHitEmmy = true,
        Hit = true
    }
}

local CachedChars = {}

function Module.IsAlive(Char: Model?)
    if not Char then return false end
    if CachedChars[Char] then return CachedChars[Char].Health > 0 end

    local Hum = Char:FindFirstChildOfClass("Humanoid")
    CachedChars[Char] = Hum
    return Hum and Hum.Health > 0 or false
end

local Settings = {
    ClickDelay = 0.01,
    AutoClick = true,
    AttackRepeat = 3,
    LoopDelay = 0.05, 
    ReHitTimes = 2, 
    ReAttackTimes = 2  
}

local PartEnemy = { "Head", "UpperTorso", "HumanoidRootPart", "RightLeg", "LeftLeg" }

Module.FastAttack = (function()
    if skibidi._trash_attack then return skibidi._trash_attack end

    local module = {
        NextAttack = 0,
        Distance = 55,
        FirstAttack = false
    }

    local RegisterAttack = net:WaitForChild("RE/RegisterAttack")
    local RegisterHit = net:WaitForChild("RE/RegisterHit")

    local function GetHitbox(Enemy)
        local hitboxes = {}
        for _, partName in ipairs(PartEnemy) do
            local hitbox = Enemy:FindFirstChild(partName)
            if hitbox then table.insert(hitboxes, hitbox) end
        end
        return hitboxes
    end

    function module:AttackEnemy(Enemy)
        local success, result = pcall(function()
            local Hitboxes = GetHitbox(Enemy)
            if #Hitboxes == 0 then return end
            if client:DistanceFromCharacter(Enemy.HumanoidRootPart.Position) < self.Distance then
                if not self.FirstAttack then
                    RegisterAttack:FireServer(Settings.ClickDelay or 0.125)
                    self.FirstAttack = true
                end
                for _, Hitbox in ipairs(Hitboxes) do
                    for _ = 1, Settings.AttackRepeat do
                        RegisterHit:FireServer(Hitbox, {})
                    end
                end
            end
        end)
        if not success then warn("Error in AttackEnemy: ", result) end
    end

    function module:AttackNearest()
        if not Module.HitSetting.Hit then return end
        
        for _ = 1, Settings.ReAttackTimes do
            if Module.HitSetting.CanHitEmmy then
                for _, Enemy in enemyfolder:GetChildren() do
                    self:AttackEnemy(Enemy)
                end
            end

            if Module.HitSetting.CanHitPlayer then
                for _, Enemy in characterfolder:GetChildren() do
                    if Enemy ~= client.Character then
                        self:AttackEnemy(Enemy)
                    end
                end
            end

            task.wait(Settings.LoopDelay)
        end
    end

    function module:ReHit()
        if not Module.HitSetting.ReHit then return end
        for _ = 1, Settings.ReHitTimes do
            self:AttackNearest()
            task.wait(Settings.LoopDelay)
        end
    end

    function module:ReAttack()
        if not Module.HitSetting.ReAttack then return end
        for _ = 1, Settings.ReAttackTimes do
            self:AttackNearest()
            task.wait(Settings.LoopDelay)
        end
    end

    function module:AttackAll()
        for _, Enemy in enemyfolder:GetChildren() do
            self:AttackEnemy(Enemy)
        end
        for _, Player in characterfolder:GetChildren() do
            if Player ~= client.Character then
                self:AttackEnemy(Player)
            end
        end
    end

    function module:SpamAttack(times)
        for _ = 1, times do
            self:AttackNearest()
            task.wait(Settings.LoopDelay)
        end
    end

    function module:LoopAttack()
        task.defer(function()
            while Module.HitSetting.Hit do
                self:AttackNearest()
                task.wait(Settings.LoopDelay)
            end
        end)
    end

    function module:BladeHits()
        self:AttackNearest()
        self.FirstAttack = false
    end

    function module:True_Attack()
        if (tick() - Module.AttackCooldown) < 0.1 then return end
        if not Module.IsAlive(client.Character) or not client.Character:FindFirstChildOfClass("Tool") then return end

        Module.AttackCooldown = tick()
        self:AttackNearest()
        self.FirstAttack = false
    end

    task.defer(function()
        while Module.HitSetting.Hit do
            module:True_Attack()
            task.wait(Settings.LoopDelay)
        end
    end)

    skibidi._trash_attack = module
    return module
end)()

return Module