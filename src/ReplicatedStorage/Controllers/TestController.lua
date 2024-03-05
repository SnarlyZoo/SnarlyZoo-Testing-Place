local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local TestController = {}
TestController.__index = TestController

type self = Types.TestController & {
    _character: Model,
    _rootPart: BasePart,
    _humanoid: Humanoid,
}

function TestController.new(character: Model): self
    local self = setmetatable({}, TestController) :: self

    self._character = character
    self._rootPart = character:WaitForChild("HumanoidRootPart")
    self._humanoid = character:WaitForChild("Humanoid")

    print(character)

    return self
end
function TestController.Destroy(self: self): nil

end

return TestController