local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Types = ReplicatedFirst.Types

local InputService = {}
InputService.__index = InputService

type self = Types.InputService & {
    _actions: { [string]: boolean },
    _axes: { [string]: number },

    _actionChangedEvent: BindableEvent,

    _onInputBegan: (self, input: InputObject, gameProcessedEvent: boolean) -> nil,
    _onInputEnded: (self, input: InputObject, gameProcessedEvent: boolean) -> nil,

    _Update: (self) -> nil,
}

local ACTIONS = {
    "Jump"
}

local AXES = {
    "LookHorizontal",
    "LookVertical",

    "MoveHorizontal",
    "MoveVertical",
}
local AXES_CONTROLS = {
    MoveUp = {
        Axis = "MoveVertical",
        Value = 1,
    },
    MoveLeft = {
        Axis = "MoveHorizontal",
        Value = -1,
    },
    MoveDown = {
        Axis = "MoveVertical",
        Value = -1,
    },
    MoveRight = {
        Axis = "MoveHorizontal",
        Value = 1,
    },
}

local KEYBOARD_CONTROLS = {
    [Enum.KeyCode.W] = "MoveUp",
    [Enum.KeyCode.A] = "MoveLeft",
    [Enum.KeyCode.S] = "MoveDown",
    [Enum.KeyCode.D] = "MoveRight",

    [Enum.KeyCode.Space] = "Jump",
}
local MOUSE_SENSITIVITY = Vector2.new(1, 0.77)*math.rad(0.5)

function InputService.new(): self
    local self = setmetatable({}, InputService) :: self

    self._actions = {}
    for _, actionName in ipairs(ACTIONS) do
        self._actions[actionName] = false
    end
    self._axes = {}
    for _, axisName in ipairs(AXES) do
        self._axes[axisName] = 0
    end

    self._actionChangedEvent = Instance.new("BindableEvent")
    self.ActionChanged = self._actionChangedEvent.Event

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        self:_onInputBegan(input, gameProcessedEvent)
    end)
    UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        self:_onInputEnded(input, gameProcessedEvent)
    end)

    RunService:BindToRenderStep("InputService", Enum.RenderPriority.Input.Value, function()
        self:_Update()
    end)

    return self
end

function InputService.GetAction(self: self, actionName: string): boolean
    return self._actions[actionName]
end
function InputService.GetAxis(self: self, axisName: string): number
    return self._axes[axisName]
end

function InputService._onInputBegan(self: self, input: InputObject, gameProcessedEvent: boolean): nil
    if not gameProcessedEvent then
        local actionName = KEYBOARD_CONTROLS[input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType]
        if actionName then
            if self._actions[actionName] ~= nil then
                self._actions[actionName] = true
                self._actionChangedEvent:Fire(actionName, true)
            end

            local axisControl = AXES_CONTROLS[actionName]
            if axisControl then
                self._axes[axisControl.Axis] += axisControl.Value
            end
        end
    end
end
function InputService._onInputEnded(self: self, input: InputObject, gameProcessedEvent: boolean): nil
    if not gameProcessedEvent then
        local actionName = KEYBOARD_CONTROLS[input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType]
        if actionName then
            if self._actions[actionName] then
                self._actions[actionName] = false
                self._actionChangedEvent:Fire(actionName, false)
            end

            local axisControl = AXES_CONTROLS[actionName]
            if axisControl then
                self._axes[axisControl.Axis] -= axisControl.Value
            end
        end
    end
end

function InputService._Update(self: self): nil
    local delta = UserInputService:GetMouseDelta()
    self._axes.LookHorizontal = delta.X * MOUSE_SENSITIVITY.X
    self._axes.LookVertical = delta.Y * MOUSE_SENSITIVITY.Y
end

return InputService.new()