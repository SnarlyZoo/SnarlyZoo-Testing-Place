local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Types = ReplicatedStorage.Types

local InputService = require(ReplicatedStorage.InputService)

local FPLooker = {}
FPLooker.__index = FPLooker

type self = Types.Looker & {
    _camera: Camera,

    _humanoid: Humanoid,
    _character: Model,

    _angles: {
        X: number,
        Y: number,
    },

    _connection: RBXScriptConnection,

    _Update: (self) -> nil,
}

local FIELD_OF_VIEW = 90
local CAMERA_OFFSET = Vector3.new(0, 1.5, 0)

local MAX_ANGLE = math.rad(89)

local function SetLocalTransparency(instance: Instance, value: number): nil
    if instance:IsA("BasePart") or instance:IsA("Decal") then
        instance.LocalTransparencyModifier = value
    end
end

function FPLooker.new(humanoid: Humanoid): self
    local self = setmetatable({}, FPLooker) :: self

    self.Enabled = true

    self._camera = Workspace.CurrentCamera
    self._humanoid = humanoid
    self._character = humanoid.Parent

    self._angles = {
        X = 0,
        Y = 0,
    }

    self._camera.FieldOfView = FIELD_OF_VIEW
    self._humanoid.CameraOffset = CAMERA_OFFSET

    for _, descendant in ipairs(self._character:GetDescendants()) do
        SetLocalTransparency(descendant, 1)
    end
    self.connection = self._character.DescendantAdded:Connect(function(descendant)
        SetLocalTransparency(descendant, 1)
    end)

    RunService:BindToRenderStep("FPLooker", Enum.RenderPriority.Camera.Value, function()
        if self.Enabled then
            self:_Update()
        end
    end)

    return self
end
function FPLooker.Destroy(self: self): nil
    RunService:UnbindFromRenderStep("FPLooker")

    self.connection:Disconnect()
    for _, descendant in ipairs(self._character:GetDescendants()) do
        SetLocalTransparency(descendant, 0)
    end
end

function FPLooker._Update(self: self)
    if not UserInputService:GetFocusedTextBox() then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false

        self._angles.X = (self._angles.X - InputService:GetAxis("LookHorizontal")) % (2*math.pi)
        self._angles.Y = math.clamp(self._angles.Y - InputService:GetAxis("LookVertical"), -MAX_ANGLE, MAX_ANGLE)

        local rotCFrame = CFrame.Angles(0, self._angles.X, 0) * CFrame.Angles(self._angles.Y, 0, 0)
        self._camera.CFrame = CFrame.new(self._humanoid.RootPart.Position + self._humanoid.CameraOffset) * rotCFrame
        self._camera.Focus = self._camera.CFrame
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end

return FPLooker