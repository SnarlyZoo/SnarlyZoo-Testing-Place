local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Types = ReplicatedFirst.Types

local CharacterController = {}
CharacterController.__index = CharacterController

type self = Types.CharacterController & {
    _humanoid: Humanoid,
}

function CharacterController.new(humanoid: Humanoid): self
    local self = setmetatable({}, CharacterController) :: self

    self._humanoid = humanoid

    return self
end
function CharacterController.Destroy(self: self): nil

end

function CharacterController.Move(self: self, moveDirection: Vector3, relativeToCamera: boolean?): nil
    self._humanoid:Move(moveDirection, relativeToCamera)
end

function CharacterController.QueueJump(self: self, toJump: boolean)
    if toJump then
        self._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

return CharacterController