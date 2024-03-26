local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Types = ReplicatedStorage.Types
type DebugGizmo = Types.DebugGizmo
type MoverState = Types.MoverState

local DebugService = require(ReplicatedStorage.DebugService)

local PhysicsMover = {}
PhysicsMover.__index = PhysicsMover

type self = Types.Mover & {
    _humanoid: Humanoid,
    _rootPart: BasePart,

    _alignOri: AlignOrientation,
    _vectorForce: VectorForce,

    _states: {[string]: MoverState},
    _curState: MoverState,

    _connection: RBXScriptConnection,

    _debugGizmos: {[string]: DebugGizmo},

    _Update: (self, deltaTime: number) -> nil,
}

local CreateForces = require(script.CreateForces)

function PhysicsMover.new(humanoid: Humanoid): self
    local self = setmetatable({}, PhysicsMover) :: self

    self.Enabled = true

    self._humanoid = humanoid
    self._rootPart = humanoid.RootPart

    self._alignOri, self._vectorForce = CreateForces(self._rootPart)

    self._states = {}
    for _, state in ipairs(script.MoverStates:GetChildren()) do
        self._states[state.Name] = require(state).new(self)
    end
    self:ChangeState("Walking")

    self._connection = RunService.Heartbeat:Connect(function(deltaTime)
        if self.Enabled then
            self:_Update(deltaTime)
        end
    end)

    self._debugGizmos = {}
    self._debugGizmos["InputVector"] = DebugService:CreateGizmo("Arrow", "PhysicsMover: InputVector")
    self._debugGizmos["VectorForce"] = DebugService:CreateGizmo("Arrow", "PhysicsMover: VectorForce")

    return self
end
function PhysicsMover.Destroy(self: self): nil
    for _, gizmo in pairs(self._debugGizmos) do
        gizmo:Destroy()
    end

    self._connection:Disconnect()

    self._alignOri:Destroy()
    self._vectorForce:Destroy()
end

function PhysicsMover.ChangeState(self: self, stateName: string): nil
    if self._curState then
        self._curState:Exit()
    end

    self._curState = self._states[stateName]
    self._curState:Enter()
end

function PhysicsMover._Update(self: self, deltaTime: number): nil
    self._curState:Update(deltaTime)

    self._debugGizmos["VectorForce"]:Update({
        Position = self._rootPart.Position,
        Direction = self._vectorForce.Force,
        Length = self._vectorForce.Force.Magnitude,
    })
end

function PhysicsMover.Setup(character: Model)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    character.Humanoid.EvaluateStateMachine = false

    local collider = script.Collider:Clone()
    collider.Parent = character

    local joint = Instance.new("Motor6D")
    joint.Name = "ColliderJoint"
    joint.Part0 = character.PrimaryPart
    joint.Part1 = collider.PrimaryPart
    joint.Parent = character.PrimaryPart
end

return PhysicsMover