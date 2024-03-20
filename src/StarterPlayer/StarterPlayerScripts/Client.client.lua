local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerModule = require(script.Parent.PlayerModule)

local Remotes = ReplicatedStorage.Remotes
Remotes.LoadCharacter.OnClientEvent:Connect(function(characterType: string, character: Model)
    PlayerModule:LoadCharacter(characterType, character)
end)