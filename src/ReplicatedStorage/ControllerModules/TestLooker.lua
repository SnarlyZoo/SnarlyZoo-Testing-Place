local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Types = require(ReplicatedFirst.Types)

local TestLooker = {}
TestLooker.__index = TestLooker

type self = Types.TestLooker & {
    _camera: Camera,
    _humanoid: Humanoid,

    _angles: {
        X: number,
        Y: number,
    },

    _Update: () -> nil,
}

local FIELD_OF_VIEW = 90
local CAMERA_OFFSET = Vector3.new(0, 1.5, 0)

local MAX_ANGLE = math.rad(89)
local MOUSE_SENSITIVITY = Vector2.new(1, 0.77)*math.rad(0.5)

local function SetLocalTransparency(instance: Instance, value: number): nil
    if instance:IsA("BasePart") or instance:IsA("Decal") then
        instance.LocalTransparencyModifier = value
    end
end

function TestLooker.new(humaniod: Humanoid): self
    local self = setmetatable({}, TestLooker) :: self

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

    RunService:BindToRenderStep("TestLooker", Enum.RenderPriority.Camera.Value, function()
        self:_Update()
    end)

    return self
end
function TestLooker.Destroy(self: self): nil
    RunService:UnbindFromRenderStep("TestLooker")

    self.connection:Disconnect()
    for _, descendant in ipairs(self._character:GetDescendants()) do
        SetLocalTransparency(descendant, 0)
    end
end

function TestLooker.ProcessDelta(self: self, delta: Vector3): nil
    self._angles.X = (self._angles.X - delta.X * MOUSE_SENSITIVITY.X) % (2*math.pi)
    self._angles.Y = math.clamp(self._angles.Y - delta.Y * MOUSE_SENSITIVITY.Y, -MAX_ANGLE, MAX_ANGLE)
end

function TestLooker._Update(self: self): nil
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

return TestLooker