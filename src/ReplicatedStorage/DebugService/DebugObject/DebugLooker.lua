local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local InputService = require(ReplicatedStorage.InputService)

local DebugLooker = {
    _angles = {
        X = 0,
        Y = 0,
    },
    _zoom = 0
}
DebugLooker.__index = DebugLooker

local DebugObject = require(script.Parent)
type self = DebugObject.self & {
    _camera: Camera,
    _humanoid: Humanoid,
    _character: Model,

    _angles: {
        X: number,
        Y: number,
    },
    _zoom: number,

    _connection: RBXScriptConnection,

    _Update: () -> nil,
}

local FIELD_OF_VIEW = 90
local CAMERA_OFFSET = Vector3.new(0, 1.5, 0)

local MAX_ANGLE = math.rad(89)
local MAX_ZOOM = 16

local OCCLUSION_SIZE = 0.5
local MAX_TRANSPARENCY_DISTANCE = 3

local function SetLocalTransparency(instance: Instance, value: number): nil
    if instance:IsA("BasePart") or instance:IsA("Decal") then
        instance.LocalTransparencyModifier = value
    end
end

function DebugLooker.new(humanoid: Humanoid): self
    local self = setmetatable(DebugObject.new(), DebugLooker) :: self

    self._camera = Workspace.CurrentCamera
    self._humanoid = humanoid
    self._character = humanoid.Parent

    self._camera.FieldOfView = FIELD_OF_VIEW
    self._humanoid.CameraOffset = CAMERA_OFFSET

    RunService:BindToRenderStep("DebugLooker", Enum.RenderPriority.Camera.Value, function()
        if self.Enabled then
            self:_Update()
        end
    end)

    self._connection = UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent then
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                self._zoom = math.clamp(self._zoom + input.Position.Z, 0, MAX_ZOOM)
            end
        end
    end)

    return self
end
function DebugLooker:Destroy(): nil
    DebugObject.Destroy(self)

    RunService:UnbindFromRenderStep("DebugLooker")

    self._connection:Disconnect()
    for _, descendant in ipairs(self._character:GetDescendants()) do
        SetLocalTransparency(descendant, 0)
    end
end

function DebugLooker:_Update(): nil
    if not UserInputService:GetFocusedTextBox() then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false

        self._angles.X = (self._angles.X - InputService:GetAxis("LookHorizontal")) % (2*math.pi)
        self._angles.Y = math.clamp(self._angles.Y - InputService:GetAxis("LookVertical"), -MAX_ANGLE, MAX_ANGLE)

        local rotCFrame = CFrame.Angles(0, self._angles.X, 0) * CFrame.Angles(self._angles.Y, 0, 0)

        local subjectPos = self._humanoid.RootPart.Position + self._humanoid.CameraOffset
        local targetCFrame = CFrame.new(subjectPos) * rotCFrame * CFrame.new(0, 0, self._zoom)

        local position = targetCFrame.Position
        local vector = position - subjectPos

        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {self._character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

        local raycastResult = Workspace:Raycast(subjectPos, vector.Unit * (vector.Magnitude + OCCLUSION_SIZE), raycastParams)
        if raycastResult then
            position = raycastResult.Position - (vector.Unit * OCCLUSION_SIZE)
        end

        self._camera.CFrame = CFrame.new(position) * rotCFrame
        self._camera.Focus = CFrame.new(subjectPos) * rotCFrame

        local distance = (subjectPos - position).Magnitude
        local transparency = distance < MAX_TRANSPARENCY_DISTANCE and (MAX_TRANSPARENCY_DISTANCE - distance) or 0
        for _, descendant in ipairs(self._character:GetDescendants()) do
            SetLocalTransparency(descendant, transparency)
        end
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end

return DebugLooker