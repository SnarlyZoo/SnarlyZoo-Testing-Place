local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local Types = ServerScriptService.Types

local Characters = ReplicatedStorage.Characters
local Remotes = ReplicatedStorage.Remotes

local Client = {}
Client.__index = Client

type self = Types.Client & {
    _player: Player,
}

function Client.new(player: Player): self
    local self = setmetatable({}, Client) :: self

    self._player = player

    return self
end
function Client.Destroy(self: self): nil

end

function Client.SpawnCharacter(self: self, characterType: string): nil
    self._player:LoadCharacter()

    local character = self._player.Character
    character.PrimaryPart = character:WaitForChild("HumanoidRootPart")

    repeat
        task.wait()
    until character:IsDescendantOf(Workspace)

    require(Characters:FindFirstChild(characterType .. "Character")).Setup(self._player, character)
    Remotes.LoadCharacter:FireClient(self._player, characterType, character)
end

return Client