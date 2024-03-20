local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = ReplicatedFirst.Types
type Character = Types.Character

local Characters = ReplicatedStorage.Characters

local PlayerModule = {}
PlayerModule.__index = PlayerModule

type self = Types.PlayerModule & {
    _character: Character,
}

function PlayerModule.new(): self
    local self = setmetatable({}, PlayerModule) :: self

    return self
end

function PlayerModule.GetCharacter(self: self): Character
    return self._character
end
function PlayerModule.LoadCharacter(self: self, characterType: string, character: Model): nil
    if self._character then
        self._character:Destroy()
    end

    self._character = require(Characters:FindFirstChild(characterType .. "Character")).new(character)
end

return PlayerModule.new()