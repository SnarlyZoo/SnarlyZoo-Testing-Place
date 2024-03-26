local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = ReplicatedStorage.Types
type Signal = Types.Signal

local Signal = require(ReplicatedStorage.Signal)

local DebugGizmo = {}
DebugGizmo.__index = DebugGizmo

local DebugObject = require(script.Parent)
export type self = DebugObject.self & {
    _model: Model,

    _propertyChanged: Signal,
}

function DebugGizmo.new(name: string): self
    local self = setmetatable(DebugObject.new(name), DebugGizmo) :: self

    self._model = Instance.new("Model")

    self._propertyChanged = Signal.new()

    return self
end
function DebugGizmo.Destroy(self: self): nil
    DebugObject.Destroy(self)

    self._model:Destroy()
end

function DebugGizmo.__newindex()

end

return DebugGizmo