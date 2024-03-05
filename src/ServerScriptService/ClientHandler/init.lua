local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)
type Client = Types.Client

local Client = require(script.Client)

Players.CharacterAutoLoads = false

local ClientHandler = {}
ClientHandler.__index = ClientHandler

type self = Types.ClientHandler & {
    _clients: {[number]: Client},

    _clientAddedEvent: BindableEvent,

    _onPlayerAdded: (player: Player) -> nil,
    _onPlayerRemoving: (player: Player) -> nil,
}

function ClientHandler.new(): self
    local self = setmetatable({}, ClientHandler) :: self

    self._clients = {}

    self._clientAddedEvent = Instance.new("BindableEvent")
    self.ClientAdded = self._clientAddedEvent.Event

    Players.PlayerAdded:Connect(function(player)
        self:_onPlayerAdded(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        self:_onPlayerRemoving(player)
    end)

    return self
end

function ClientHandler.GetClient(self: self, player: Player): Client
    return self._clients[player.UserId]
end

function ClientHandler._onPlayerAdded(self: self, player: Player): nil
    local client = Client.new(player)
    self._clients[player.UserId] = client
    self._clientAddedEvent:Fire(client)
end
function ClientHandler._onPlayerRemoving(self: self, player: Player): nil
    local client = self:GetClient(player)
    if client then
        client:Destroy()
        self._clients[player.UserId] = nil
    end
end

return ClientHandler.new()