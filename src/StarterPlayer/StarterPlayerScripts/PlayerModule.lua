local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedFirst.Types)
type Controller = Types.Controller
type ControllerType = Types.ControllerType

local InputService = require(ReplicatedStorage.InputService)

local Controllers = ReplicatedStorage.Controllers

local PlayerModule = {}
PlayerModule.__index = PlayerModule

type self = Types.PlayerModule & {
    _controller: Controller,
}

function PlayerModule.new(): self
    local self = setmetatable({}, PlayerModule) :: self

    self.Player = Players.LocalPlayer

    InputService:ChangeInputType("Keyboard")

    return self
end

function PlayerModule.ChangeControllerType(self: self, controllerType: ControllerType, ...): nil
    if self._controller then
        self._controller:Destroy()
    end

    self._controller = require(Controllers:FindFirstChild(controllerType .. "Controller")).new(...)
end
function PlayerModule.GetControllerType(self: self): ControllerType
    return self._controller.ControllerType
end

return PlayerModule.new()