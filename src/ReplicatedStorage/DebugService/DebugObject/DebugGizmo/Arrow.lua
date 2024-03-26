local Arrow = {}
Arrow.__index = Arrow

local DebugGizmo = require(script.Parent)
type self = DebugGizmo.self & {

}

function Arrow.new(name: string): self
    local self = setmetatable(DebugGizmo.new(name), Arrow) :: self

    return self
end
function Arrow.Destroy(self: self): nil
    DebugGizmo.Destroy(self)
end

return Arrow