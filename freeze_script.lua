
return function()
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    local button = Instance.new("TextButton", gui)

    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0.5, -75, 0.9, -50)
    button.Text = "ЗАМОРОЗИТЬ(freeze)"
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18

    local isFrozen = false
    local freezeConnection = nil

    local function setFrozen(state)
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if not humanoid or not torso then return end
        
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
        
        isFrozen = state
        humanoid.PlatformStand = state
        humanoid.AutoRotate = not state
        
        if state then
            local bodyForce = Instance.new("BodyForce")
            bodyForce.Force = Vector3.new(0, character:GetMass() * workspace.Gravity, 0)
            bodyForce.Parent = torso
            
            freezeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                torso.Velocity = Vector3.new()
                torso.RotVelocity = Vector3.new()
            end)
            
            button.Text = "РАЗМОРОЗИТЬ(unfreeze)"
            button.BackgroundColor3 = Color3.fromRGB(215, 0, 0)
        else
            local force = torso:FindFirstChild("BodyForce")
            if force then force:Destroy() end
            
            button.Text = "ЗАМОРОЗИТЬ"
            button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        end
    end

    button.MouseButton1Click:Connect(function() setFrozen(not isFrozen) end)

    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Died:Connect(function()
            if isFrozen then setFrozen(false) end
        end)
        
        if isFrozen then 
            character:WaitForChild("HumanoidRootPart")
            setFrozen(true) 
        end
    end)
end