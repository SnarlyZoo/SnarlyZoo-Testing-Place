local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Types = ReplicatedFirst.Types
type FPLooker = Types.FPLooker
type PhysicsMover = Types.PhysicsMover

local FPSCharacter = {}
FPSCharacter.__index = FPSCharacter

type self = Types.FPSCharacter & {
    _character: Model,
    _humanoid: Humanoid,

    _looker: FPLooker,
    _mover: PhysicsMover,
}

local FPLooker = require(script.FPLooker)
local PhysicsMover = require(script.PhysicsMover)

function FPSCharacter.new(character: Model): self
    local self = setmetatable({}, FPSCharacter) :: self

    self._character = character
    self._humanoid = character:WaitForChild("Humanoid")

    self._looker = FPLooker.new(self._humanoid)
    self._mover = PhysicsMover.new(self._humanoid)

    return self
end
function FPSCharacter.Destroy(self: self): nil
    self._mover:Destroy()
    self._looker:Destroy()
end

function FPSCharacter.Setup(player: Player, character: Model): nil
    PhysicsMover.Setup(character)

    character.Humanoid.BreakJointsOnDeath = false

    player.CharacterAppearanceLoaded:Wait()
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.CollisionGroup = "No Collision"
            end
        end
    end
end

return FPSCharacter