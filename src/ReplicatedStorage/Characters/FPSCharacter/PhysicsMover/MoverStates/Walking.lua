local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = ReplicatedStorage.Types
type Mover = Types.Mover

local InputService = require(ReplicatedStorage.InputService)

local Walking = {}
Walking.__index = Walking

type self = Types.MoverState & {
    _mover: Mover,
}

function Walking.new(mover: Mover): self
    local self = setmetatable({}, Walking) :: self

    self._mover = mover

    return self
end
function Walking.Destroy(self: self): nil

end

function Walking.Enter(self: self): nil

end
function Walking.Exit(self: self): nil

end

function Walking.Update(self: self, deltaTime: number): nil
    local inputVec = Vector3.new(InputService:GetAxis("MoveHorizontal"), 0, InputService:GetAxis("MoveVertical"))
end

return Walking