local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local DebugService = require(ReplicatedStorage.DebugService)
if RunService:IsStudio() then
    DebugService:Enable()
end

local PlayerModule = require(script.Parent:WaitForChild("PlayerModule"))

local Remotes = ReplicatedStorage.Remotes
Remotes.LoadCharacter.OnClientEvent:Connect(function(characterType: string, character: Model)
    PlayerModule:LoadCharacter(characterType, character)
end)