-- Enhanced scepter.fire (LMB HOLD EDITION) with Faster Auto-Shoot
-- PRIVATE EDITION

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

---------------------
-- GUI & Intro Setup
---------------------

-- Create main ScreenGui for status and intro
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Status Frame Setup (existing UI)
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
StatusText.Text = "scepter.fire: LMB HOLD"
StatusText.TextColor3 = Color3.new(1, 1, 1)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 18
StatusText.Parent = StatusFrame

-- Intro Frame Setup (for scepter.win intro)
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.Position = UDim2.new(0, 0, 0, 0)
IntroFrame.BackgroundTransparency = 1
IntroFrame.Parent = ScreenGui

-- Intro Text Setup
local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0.6, 0, 0.2, 0)
IntroText.Position = UDim2.new(0.2, 0, 0.4, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "scepter.win - rapid edition"
IntroText.TextColor3 = Color3.new(1, 1, 1)
IntroText.Font = Enum.Font.GothamBlack
IntroText.TextScaled = true
IntroText.TextTransparency = 1  -- start hidden
IntroText.Parent = IntroFrame

---------------------
-- Blur Effect Setup
---------------------

-- Create a BlurEffect in Lighting
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

---------------------
-- Intro Animation Function (Looped 3 Times, No Extra Delay)
---------------------

local function playIntro()
    for i = 1, 3 do
        -- Fade in text
        local textFadeIn = TweenService:Create(IntroText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
        textFadeIn:Play()
        textFadeIn.Completed:Wait()
        
        -- Blur in
        local blurIn = TweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24})
        blurIn:Play()
        blurIn.Completed:Wait()
        
        -- Fade out text
        local textFadeOut = TweenService:Create(IntroText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        textFadeOut:Play()
        textFadeOut.Completed:Wait()
        
        -- Blur out
        local blurOut = TweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0})
        blurOut:Play()
        blurOut.Completed:Wait()
    end
    -- Remove the intro GUI after looping
    IntroFrame:Destroy()
end

-- Play the intro animation once on spawn
playIntro()

---------------------
-- Core Variables
---------------------

local IsMouseDown = false

---------------------
-- Input Handlers for Auto-Shoot
---------------------

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsMouseDown = false
    end
end)

---------------------
-- Main Auto-Shoot Function (Faster, Loops 3 Times)
---------------------

local function AutoShoot()
    if not IsMouseDown or not LocalPlayer or not LocalPlayer.Character then return end
    
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        -- Activate the tool 3 times per frame for faster firing
        for i = 1, 3 do
            tool:Activate()
        end
    end
end

---------------------
-- Optimized Main Loop
---------------------

RunService.Heartbeat:Connect(function()
    AutoShoot()
end)

---------------------
-- Death Position Tracking (Optional)
---------------------

local LastDeathPosition = nil

local function TrackDeath()
    LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                LastDeathPosition = root.Position
            end
        end)
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if LastDeathPosition and root then
            root.CFrame = CFrame.new(LastDeathPosition)
        end
    end)
end

TrackDeath()
