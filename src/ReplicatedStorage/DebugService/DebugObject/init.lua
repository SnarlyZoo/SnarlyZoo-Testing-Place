local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = ReplicatedStorage.Types

local DebugService = require(ReplicatedStorage.DebugService)

local DebugObject = {}
DebugObject.__index = DebugObject

export type self = Types.DebugObject

function DebugObject.new(name): self
    local self = setmetatable({}, DebugObject) :: self

    self.Enabled = true
    self.Name = name

    DebugService._DebugObjectCreated(self)

    return self
end
function DebugObject.Destroy(self: self): nil
    DebugService._DebugObjectDestroying(self)
end

return DebugObject