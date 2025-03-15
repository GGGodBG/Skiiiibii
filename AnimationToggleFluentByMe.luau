local TweenService = game:GetService("TweenService");
local CoreGui = game:GetService("CoreGui");
local animationGui = {};

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))();
end);

if success and Fluent then
    print("Fluent UI loaded successfully!");
    if not CoreGui:FindFirstChild("FluentUI") then
        local FluentUI = Instance.new("ScreenGui");
        FluentUI.Name = "FluentUI";
        FluentUI.Parent = CoreGui;
    end;
else
    warn("Failed to load Fluent UI!");
end;

function animationGui.PlayAnimation(toggle, dropdown, state)
    if not (toggle or dropdown) then return end;

    if toggle then
        local colorGoal = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 255, 255);
        local sizeGoal = state and UDim2.new(0, 110, 0, 55) or UDim2.new(0, 100, 0, 50);
        
        local colorTween = TweenService:Create(
            toggle,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = colorGoal}
        );
        
        local sizeTween = TweenService:Create(
            toggle,
            TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
            {Size = sizeGoal}
        );

        colorTween:Play();
        sizeTween:Play();
    end;

    if dropdown then
        local posGoal = state and UDim2.new(0, 0, 0, 50) or UDim2.new(0, 0, -0.5, 0);
        local opacityGoal = state and 1 or 0;

        local posTween = TweenService:Create(
            dropdown,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = posGoal}
        );

        local opacityTween = TweenService:Create(
            dropdown,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = opacityGoal}
        );

        posTween:Play();
        opacityTween:Play();
    end;
end;

return animationGui;
