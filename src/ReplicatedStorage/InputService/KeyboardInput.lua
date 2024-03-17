local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Types = require(ReplicatedFirst.Types)
type InputAction = Types.InputAction
type InputAxis = Types.InputAxis

local KeyboardInput = {}
KeyboardInput.__index = KeyboardInput

type self = Types.KeyboardInput & {
    _controls: {[string]: Enum.KeyCode | Enum.UserInputType},
    _inputRelations: {[Enum.KeyCode | Enum.UserInputType]: InputRelation},

    _connections: {RBXScriptConnection},

    _LoadInputRelations: () -> nil,
}
type InputRelation = {
    Name: string,
    Axis: {
        Name: string,
        Value: number,
    },
}

local DEFAULT_CONTROLS = {
    MoveUp = Enum.KeyCode.W,
    MoveLeft = Enum.KeyCode.A,
    MoveDown = Enum.KeyCode.S,
    MoveRight = Enum.KeyCode.D,

    Jump = Enum.KeyCode.Space,
}

function KeyboardInput.new(actions: {[string]: InputAction}, axes: {[string]: InputAxis}): self
    local self = setmetatable({}, KeyboardInput) :: self

    self._controls = DEFAULT_CONTROLS
    self._inputRelations = {}

    self._connections = {}
    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
        if not processed then
            local relation = self._inputRelations[input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType]
            if relation then
                local action = actions[relation.ActionName]
                if action then
                    action.Value = true
                    action._changedEvent:Fire(true)
                end

                if relation.Axis then
                    local axis = axes[relation.Axis.Name]
                    axis.Value += relation.Axis.Value
                    axis._changedEvent:Fire(axis.Value)
                end
            end
        end
    end))
    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input: InputObject)
        local relation = self._inputRelations[input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType]
        if relation then
            local action = actions[relation.ActionName]
            if action then
                action.Value = false
                action._changedEvent:Fire(false)
            end

            if relation.Axis then
                local axis = axes[relation.Axis.Name]
                axis.Value -= relation.Axis.Value
                axis._changedEvent:Fire(axis.Value)
            end
        end
    end))

    table.insert(self._connections, RunService.Heartbeat:Connect(function()
        local delta = UserInputService:GetMouseDelta()

        axes.LookHorizontal.Value = delta.X
        axes.LookHorizontal._changedEvent:Fire(delta.X)

        axes.LookVertical.Value = delta.Y
        axes.LookVertical._changedEvent:Fire(delta.Y)
    end))

    self:_LoadInputRelations()

    return self
end
function KeyboardInput.Destroy(self: self): nil
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
end

local AXES_CONTROLS = {
    MoveUp = {
        AxisName = "MoveVertical",
        Value = 1,
    },
    MoveLeft = {
        AxisName = "MoveHorizontal",
        Value = -1,
    },
    MoveDown = {
        AxisName = "MoveVertical",
        Value = -1,
    },
    MoveRight = {
        AxisName = "MoveHorizontal",
        Value = 1,
    },
}
function KeyboardInput._LoadInputRelations(self: self): nil
    self._inputRelations = {}

    for name, input in pairs(self._controls) do
        self._inputRelations[input] = {}
        self._inputRelations[input].Name = name

        local axisControl = AXES_CONTROLS[name]
        if axisControl then
            self._inputRelations[input].Axis = {}
            self._inputRelations[input].Axis.Name = axisControl.AxisName
            self._inputRelations[input].Axis.Value = axisControl.Value
        end
    end
end

return KeyboardInput