local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedFirst.Types)
type ControllerType = Types.ControllerType

local PlayerModule = require(script.Parent:WaitForChild("PlayerModule"))

local Remotes = ReplicatedStorage.Remotes

Remotes.SetController.OnClientEvent:Connect(function(controllerType: ControllerType, ...)
    PlayerModule:ChangeControllerType(controllerType, ...)
end)