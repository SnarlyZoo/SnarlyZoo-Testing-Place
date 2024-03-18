local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Types = ReplicatedFirst.Types
type CharacterController = Types.CharacterController
type FirstPersonCamera = Types.FirstPersonCamera

local InputService = require(ReplicatedStorage.InputService)

local FirstPersonCamera = require(ReplicatedStorage.FirstPersonCamera)
local CharacterController = require(ReplicatedStorage.CharacterController)

local PlayerModule = {}
PlayerModule.__index = PlayerModule

type self = Types.PlayerModule & {
    _camera: FirstPersonCamera,
    _controller: CharacterController,

    _onCharacterAdded: (self, character: Model) -> nil,
    _onCharacterRemoving: (self) -> nil,

    _Update: (self) -> nil,
}

local PLAYER = Players.LocalPlayer
local CAMERA = Workspace.CurrentCamera

function PlayerModule.new(): self
    local self = setmetatable({}, PlayerModule) :: self

    PLAYER.CharacterAdded:Connect(function(character)
        self:_onCharacterAdded(character)
    end)
    PLAYER.CharacterRemoving:Connect(function()
        self:_onCharacterRemoving()
    end)

    RunService:BindToRenderStep("PlayerModule", Enum.RenderPriority.Character.Value, function()
        self:_Update()
    end)

    InputService.ActionChanged:Connect(function(actionName: string, value: boolean)
        if self._controller then
            if actionName == "Jump" then
                self._controller:QueueJump(value)
            end
        end
    end)

    return self
end

function PlayerModule.GetController(self: self): CharacterController
    return self._controller
end

function PlayerModule._onCharacterAdded(self: self, character: Model): nil
    local humanoid = character:WaitForChild("Humanoid")
    self._camera = FirstPersonCamera.new(humanoid)
    self._controller = CharacterController.new(humanoid)
end
function PlayerModule._onCharacterRemoving(self: self): nil
    self._camera:Destroy()
    self._camera = nil

    self._controller:Destroy()
    self._controller = nil
end

function PlayerModule._Update(self: self): nil
    if self._camera then
        self._camera:Look(Vector2.new(InputService:GetAxis("LookHorizontal"), InputService:GetAxis("LookVertical")))
    end

    if self._controller then
        self._controller:Move(Vector3.new(InputService:GetAxis("MoveHorizontal"), 0, -InputService:GetAxis("MoveVertical")), true)
    end
end

return PlayerModule.new()