local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Types = require(ReplicatedFirst.Types)
type InputAction = Types.InputAction
type InputAxis = Types.InputAxis
type Inputter = Types.Inputter
type InputType = Types.InputType

local InputService = {}
InputService.__index = InputService

type self = Types.InputService & {
    _actions: {[string]: InputAction},
    _axes: {[string]: InputAxis},

    _input: Inputter,
}

local ACTIONS = {
    "Jump",
}
local AXES = {
    "LookHorizontal",
    "LookVertical",

    "MoveHorizontal",
    "MoveVertical",
}

function InputService.new(): self
    local self = setmetatable({}, InputService) :: self

    self._actions = {}
    self._axes = {}

    for _, actionName in ipairs(ACTIONS) do
        local event = Instance.new("BindableEvent")
        self._actions[actionName] = {
            Value = false,
            _changedEvent = event,
            Changed = event.Event,
        }
    end
    for _, axisName in ipairs(AXES) do
        local event = Instance.new("BindableEvent")
        self._axes[axisName] = {
            Value = 0,
            _changedEvent = event,
            Changed = event.Event,
        }
    end

    return self
end

function InputService.ChangeInputType(self: self, inputType: InputType): nil
    if self._input then
        self._input:Destroy()
    end

    self._input = require(script:FindFirstChild(inputType .. "Input")).new(self._actions, self._axes)
end
function InputService.GetInputType(self: self): InputType
    return self._input.InputType
end

function InputService.GetInputAction(self: self, actionName: string): InputAction
    return self._actions[actionName]
end
function InputService.GetInputAxis(self: self, axisName: string): InputAxis
    return self._axes[axisName]
end

return InputService.new()