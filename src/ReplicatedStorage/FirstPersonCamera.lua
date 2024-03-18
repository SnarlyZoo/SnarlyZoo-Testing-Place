local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Types = ReplicatedFirst.Types

local FirstPersonCamera = {}
FirstPersonCamera.__index = FirstPersonCamera

type self = Types.FirstPersonCamera & {
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

function FirstPersonCamera.new(humaniod: Humanoid): self
    local self = setmetatable({}, FirstPersonCamera) :: self

    self._camera = Workspace.CurrentCamera
    self._humanoid = humaniod
    self._character = humaniod.Parent

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

    RunService:BindToRenderStep("FirstPersonCamera", Enum.RenderPriority.Camera.Value, function()
        self:_Update()
    end)

    return self
end
function FirstPersonCamera.Destroy(self: self): nil
    RunService:UnbindFromRenderStep("FirstPersonCamera")

    self.connection:Disconnect()
    for _, descendant in ipairs(self._character:GetDescendants()) do
        SetLocalTransparency(descendant, 0)
    end
end

function FirstPersonCamera.Look(self: self, lookVector: Vector2): nil
    self._angles.X = (self._angles.X - lookVector.X) % (2*math.pi)
    self._angles.Y = math.clamp(self._angles.Y - lookVector.Y, -MAX_ANGLE, MAX_ANGLE)
end

function FirstPersonCamera._Update(self: self)
    if not UserInputService:GetFocusedTextBox() then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false

        local rotCFrame = CFrame.Angles(0, self._angles.X, 0) * CFrame.Angles(self._angles.Y, 0, 0)
        self._camera.CFrame = CFrame.new(self._humanoid.RootPart.Position + self._humanoid.CameraOffset) * rotCFrame
        self._camera.Focus = self._camera.CFrame
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end

return FirstPersonCamera