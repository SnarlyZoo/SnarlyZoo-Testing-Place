local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Types = require(ReplicatedFirst.Types)

local TestMovement = {}
TestMovement.__index = TestMovement

type self = Types.TestMovement & {
    _humanoid: Humanoid,
}

function TestMovement.new(humanoid: Humanoid): self
    local self = setmetatable({}, TestMovement) :: self

    self._humanoid = humanoid

    return self
end
function TestMovement.Destroy(self: self): nil

end

function TestMovement.Move(self: self, moveDirection: Vector3, relativeToCamera: boolean?): nil
    self._humanoid:Move(moveDirection, relativeToCamera)
end

function TestMovement:Jump()
    self._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

return TestMovement