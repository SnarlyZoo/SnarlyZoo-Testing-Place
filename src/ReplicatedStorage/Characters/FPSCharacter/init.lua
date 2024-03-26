local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = ReplicatedStorage.Types
type Looker = Types.Looker
type Mover = Types.Mover

local DebugService = require(ReplicatedStorage.DebugService)

local FPSCharacter = {}
FPSCharacter.__index = FPSCharacter

type self = Types.Character & {
    _character: Model,
    _humanoid: Humanoid,

    _looker: Looker,
    _mover: Mover,

    _isAlive: boolean,
}

local FPLooker = require(script.FPLooker)
local PhysicsMover = require(script.PhysicsMover)

function FPSCharacter.new(character: Model): self
    local self = setmetatable({}, FPSCharacter) :: self

    self._character = character
    self._humanoid = character:WaitForChild("Humanoid")

    self._looker = FPLooker.new(self._humanoid)
    self._mover = PhysicsMover.new(self._humanoid)

    do -- DEBUG
        self._looker:Destroy()
        self._looker = DebugService.Looker.new(self._humanoid)
    end

    self._isAlive = true
    self._humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if self._humanoid.Health <= 0 then
            self:_onDied()
        end
    end)

    return self
end
function FPSCharacter.Destroy(self: self): nil
    if self._isAlive then
        self:_onDied()
    end

    self._looker:Destroy()
end

function FPSCharacter._onDied(self: self): nil
    self._isAlive = false

    self._mover:Destroy()
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