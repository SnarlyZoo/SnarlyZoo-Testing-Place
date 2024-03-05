local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)
type ControllerType = Types.ControllerType

local PlayerModule = require(script.Parent:WaitForChild("PlayerModule"))

local Remotes = ReplicatedStorage.Remotes

Remotes.SetController.OnClientEvent:Connect(function(controllerType: ControllerType, ...)
    PlayerModule:ChangeControllerType(controllerType, ...)
end)