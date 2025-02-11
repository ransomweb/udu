-- slash.lua (rebranded like 4 times)
-- PRIVATE EDITION
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local AutoShootEnabled = false
local LastShootTime = 0
local ShootCooldown = 0.001


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")


local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game:GetService("Lighting")


local SlashFrame = Instance.new("Frame")
SlashFrame.Size = UDim2.new(0.4, 0, 0.2, 0)
SlashFrame.Position = UDim2.new(0.3, 0, 0.4, 0)
SlashFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
SlashFrame.BackgroundTransparency = 1
SlashFrame.BorderSizePixel = 0
SlashFrame.Parent = ScreenGui

local SlashText = Instance.new("TextLabel")
SlashText.Size = UDim2.new(1, 0, 1, 0)
SlashText.Text = "slash.lua - beta"
SlashText.TextColor3 = Color3.new(1, 1, 1)
SlashText.BackgroundTransparency = 1
SlashText.Font = Enum.Font.GothamBold
SlashText.TextSize = 48
SlashText.TextTransparency = 1
SlashText.Parent = SlashFrame


local function TweenSmooth(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end


local function ShowSlashText()
    
    TweenSmooth(Blur, {Size = 24}, 1)

    
    TweenSmooth(SlashText, {TextTransparency = 0}, 1)

    wait(1) 

    
    TweenSmooth(SlashText, {TextTransparency = 1}, 1)
    TweenSmooth(Blur, {Size = 0}, 1)

    wait(1) 
    SlashFrame:Destroy() 
end


local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0.2, 0, 0.05, 0)
StatusFrame.Position = UDim2.new(0.95, 0, 0.95, 0)
StatusFrame.AnchorPoint = Vector2.new(1, 1)
StatusFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
StatusFrame.BackgroundTransparency = 0.5
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = ScreenGui


local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = StatusFrame

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.Text = "AutoShoot: OFF"
StatusText.TextColor3 = Color3.new(1, 1, 1)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 18
StatusText.Parent = StatusFrame


local function UpdateStatus()
    if AutoShootEnabled then
        StatusText.Text = "AutoShoot: ON"
        StatusText.TextColor3 = Color3.new(0, 1, 0) -- Green for ON
        TweenSmooth(StatusFrame, {BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)}, 0.3) -- Smooth color change
        print("slash.lua - Enabled")
    else
        StatusText.Text = "AutoShoot: OFF"
        StatusText.TextColor3 = Color3.new(1, 0, 0) -- Red for OFF
        TweenSmooth(StatusFrame, {BackgroundColor3 = Color3.new(0.5, 0.1, 0.1)}, 0.3) -- Smooth color change
        print("slash.lua - Disabled")
    end
end


local function AutoShoot()
    if not AutoShootEnabled then return end
    if not LocalPlayer or not LocalPlayer.Character then return end

    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool or not tool:IsA("Tool") then return end

    
    if tick() - LastShootTime >= ShootCooldown then
        tool:Activate() 
        LastShootTime = tick()
    end
end


local debounce = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        if debounce then return end
        debounce = true

        AutoShootEnabled = not AutoShootEnabled
        UpdateStatus()

        task.wait(0.2) 
        debounce = false
    end
end)


RunService.RenderStepped:Connect(AutoShoot)


ShowSlashText()