local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Types = require(ReplicatedFirst.Types)
type Looker = Types.Looker
type Movement = Types.Movement

local InputService = require(ReplicatedStorage.InputService)

local ControllerModules = ReplicatedStorage.ControllerModules
local TestLooker = require(ControllerModules.TestLooker)
local TestMovement = require(ControllerModules.TestMovement)

local TestController = {}
TestController.__index = TestController

type self = Types.TestController & {
    _character: Model,
    _rootPart: BasePart,
    _humanoid: Humanoid,

    _looker: Looker,
    _movement: Movement,

    _connection: RBXScriptConnection,

    _Update: () -> nil,
}

function TestController.new(character: Model): self
    local self = setmetatable({}, TestController) :: self

    self._character = character
    self._rootPart = character:WaitForChild("HumanoidRootPart")
    self._humanoid = character:WaitForChild("Humanoid")

    self._looker = TestLooker.new(self._humanoid)
    self._movement = TestMovement.new(self._humanoid)

    self._connections = {}

    table.insert(self._connections, RunService.Heartbeat:Connect(function()
        self:_Update()
    end))

    table.insert(self._connections, InputService:GetInputAction("Jump").Changed:Connect(function(bool)
        print(bool)
        if bool then
            self._movement:Jump()
        end
    end))

    return self
end
function TestController.Destroy(self: self): nil
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end

    self._movement:Destroy()
    self._looker:Destroy()
end

function TestController._Update(self: self): nil
    self._looker:ProcessDelta(Vector3.new(InputService:GetInputAxis("LookHorizontal").Value, InputService:GetInputAxis("LookVertical").Value, 0))
    self._movement:Move(Vector3.new(InputService:GetInputAxis("MoveHorizontal").Value, 0, -InputService:GetInputAxis("MoveVertical").Value), true)
end

return TestController