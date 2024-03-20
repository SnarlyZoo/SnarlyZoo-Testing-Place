local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Types = ReplicatedFirst.Types

local PhysicsMover = {}
PhysicsMover.__index = PhysicsMover

type self = Types.PhysicsMover & {

}

function PhysicsMover.new(humanoid: Humanoid): self
    local self = setmetatable({}, PhysicsMover) :: self

    self._humanoid = humanoid

    return self
end
function PhysicsMover.Destroy(self: self): nil

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