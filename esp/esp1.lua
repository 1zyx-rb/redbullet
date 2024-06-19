-- RedBullet's ESP1 Script is new. We've added some notes to let you know how to use them and change them if you want.

-- Function to reset the highlight on a character
local function resetHighlight(character)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part:FindFirstChild("OriginalColor") then
            part.Color = part.OriginalColor.Value -- Reset to original color
            part.Material = Enum.Material[part.OriginalMaterial.Value] -- Reset to original material
            part.Transparency = part.OriginalTransparency.Value -- Reset to original transparency
            part.OriginalColor:Destroy() -- Clean up the OriginalColor value
            part.OriginalMaterial:Destroy() -- Clean up the OriginalMaterial value
            part.OriginalTransparency:Destroy() -- Clean up the OriginalTransparency value
        end
    end

    local head = character:FindFirstChild("Head")
    if head then
        local billboardGui = head:FindFirstChild("NameTag")
        if billboardGui then
            billboardGui:Destroy() -- Remove the name tag
        end
    end
end

-- Function to highlight a character
local function highlightCharacter(character, playerName)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            if not part:FindFirstChild("OriginalColor") then
                local originalColor = Instance.new("Color3Value")
                originalColor.Name = "OriginalColor"
                originalColor.Value = part.Color
                originalColor.Parent = part

                local originalMaterial = Instance.new("StringValue")
                originalMaterial.Name = "OriginalMaterial"
                originalMaterial.Value = part.Material.Name
                originalMaterial.Parent = part

                local originalTransparency = Instance.new("NumberValue")
                originalTransparency.Name = "OriginalTransparency"
                originalTransparency.Value = part.Transparency
                originalTransparency.Parent = part
            end
            part.Color = Color3.new(0, 0, 1) -- Blue color
            part.Material = Enum.Material.ForceField
            part.Transparency = 0.5 -- Semi-transparent
        end
    end

    local head = character:FindFirstChild("Head")
    if head then
        local billboardGui = head:FindFirstChild("NameTag")
        if not billboardGui then
            -- Create a new BillboardGui for the name tag if it doesn't exist
            billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "NameTag"
            billboardGui.Adornee = head
            billboardGui.Size = UDim2.new(4, 0, 1, 0)
            billboardGui.StudsOffset = Vector3.new(0, 2, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = head

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 0, 0) -- Red color
            nameLabel.TextStrokeTransparency = 0.5 -- Semi-transparent text stroke
            nameLabel.TextScaled = true
            nameLabel.Text = playerName
            nameLabel.Parent = billboardGui
        else
            local nameLabel = billboardGui:FindFirstChildOfClass("TextLabel")
            if nameLabel then
                nameLabel.TextColor3 = Color3.new(1, 0, 0) -- Red color
                nameLabel.Text = playerName -- Ensure the name is correctly set
            end
        end
    end
end

-- Function to handle the continuous cycle
local function startCycle(character, playerName)
    coroutine.wrap(function()
        while character.Parent do
            highlightCharacter(character, playerName)
            wait(5)
            resetHighlight(character)
            print("Completed cycle!")
        end
    end)()
end

-- Event listener for new players
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        startCycle(character, player.Name)
    end)
end

-- Connect the PlayerAdded event
game.Players.PlayerAdded:Connect(onPlayerAdded)

-- Start cycle for already present players
for _, player in ipairs(game.Players:GetPlayers()) do
    if player.Character then
        startCycle(player.Character, player.Name)
    end
end
