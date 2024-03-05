local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local Remotes = ReplicatedStorage.Remotes

local LobbyUser = {}
LobbyUser.__index = LobbyUser

type self = Types.LobbyUser & {
    _player: Player,

    _character: Model,
    _rootPart: BasePart,
    _humanoid: Humanoid,

    _isAlive: boolean,
    _canRespawn: boolean,

    _onDied: () -> nil,
}

local RESPAWN_TIME = 5

function LobbyUser.new(player: Player): self
    local self = setmetatable({}, LobbyUser) :: self

    self._player = player

    self._isAlive = false
    self._canRespawn = true

    self:Spawn()

    return self
end
function LobbyUser.Destroy(self: self): nil
    self._canRespawn = false
    self:_onCharacterRemoving(self._character)
end

function LobbyUser.Spawn(self: self, cframe: CFrame?): nil
    self._player:LoadCharacter()

    local character = self._player.Character
    local rootPart = character:WaitForChild("HumanoidRootPart")
    character.PrimaryPart = rootPart
    if cframe then
        rootPart.CFrame = cframe
    end

    rootPart.AncestryChanged:Connect(function(parent)
        if not parent then
            self:_onCharacterRemoving(character)
        end
    end)

    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        self:_onDied()
    end)

    self._character = character
    self._rootPart = rootPart
    self._humanoid = humanoid

    self._isAlive = true

    Remotes.SetController:FireClient(self._player, "Test", character)
end

function LobbyUser._onCharacterRemoving(self: self, character: Model): nil
    if character == self._character then
        if self._isAlive then
            self:_onDied()
        end

        self._character = nil
    end
end
function LobbyUser._onDied(self: self): nil
    self._isAlive = false

    if self._canRespawn then
        task.delay(RESPAWN_TIME, function()
            self:Spawn()
        end)
    end
end

return LobbyUser