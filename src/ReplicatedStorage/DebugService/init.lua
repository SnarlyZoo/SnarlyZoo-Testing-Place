local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = ReplicatedStorage.Types
type DebugObject = Types.DebugObject

local DebugService = {
    _enabled = false,

    _objects = {},
}
DebugService.__index = DebugService

type self = Types.DebugService & {
    _enabled: boolean,

    _objects: {DebugObject},

    _SetEnabled: (self, enabled: boolean) -> nil,
}

function DebugService.new(): self
    local self = setmetatable({}, DebugService) :: self

    return self
end

function DebugService._SetEnabled(self: self, enabled: boolean): nil
    self._enabled = enabled

    for _, object in ipairs(self._objects) do
        object.Enabled = enabled
    end
end
function DebugService.Enable(self: self): nil
    self:_SetEnabled(true)
end
function DebugService.Disable(self: self): nil
    self:_SetEnabled(false)
end

function DebugService._DebugObjectCreated(self: self, object: DebugObject): nil
    table.insert(self._objects, object)
    object.Enabled = self._enabled
end
function DebugService._DebugObjectDestroying(self: self, object: DebugObject): nil
    for index, otherObject in ipairs(self._objects) do
        if otherObject == object then
            table.remove(self._objects, index)
            break
        end
    end
end

return DebugService.new()