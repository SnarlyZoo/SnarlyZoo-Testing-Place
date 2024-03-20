local ServerScriptService = game:GetService("ServerScriptService")

local ClientHandler = require(ServerScriptService.ClientHandler)

--[[
    character.PrimaryPart = character:WaitForChild("HumanoidRootPart")
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local humanoid = character:WaitForChild("Humanoid")
        humanoid.BreakJointsOnDeath = false
        humanoid.EvaluateStateMachine = false

        local collider = Collider:Clone()
        collider.Parent = character

        local joint = Instance.new("Motor6D")
        joint.Name = "ColliderJoint"
        joint.Part0 = character.PrimaryPart
        joint.Part1 = collider.PrimaryPart
        joint.Parent = character.PrimaryPart

        player.CharacterAppearanceLoaded:Wait()
        for _, accessory in ipairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle then
                    handle.CollisionGroup = "No Collision"
                end
            end
        end
]]