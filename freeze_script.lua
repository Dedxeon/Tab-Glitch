local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 45)
button.Position = UDim2.new(0.5, -90, 0.9, -50)
button.Text = "FREEZE (Заморозить)"
button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = gui

local isFrozen = false

local function freezeCharacter(enable)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    if enable then
        
        isFrozen = true
        
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
                part.CanCollide = false
            end
        end
        
        button.Text = "UNFREEZE (Разморозить)"
        button.BackgroundColor3 = Color3.fromRGB(215, 0, 0)
    else
        
        isFrozen = false
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
                part.CanCollide = true
            end
        end
        
        button.Text = "FREEZE (Заморозить)"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end

button.MouseButton1Click:Connect(function()
    freezeCharacter(not isFrozen)
end)


player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        if isFrozen then
            freezeCharacter(false)
        end
    end)
end)
