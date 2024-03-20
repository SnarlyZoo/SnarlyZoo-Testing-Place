local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

Players.CharacterAutoLoads = false

local Types = ServerScriptService.Types
type Client = Types.Client

local ClientHandler = {}
ClientHandler.__index = ClientHandler

type self = Types.ClientHandler & {
    _clients: {Client},

    _clientAddedEvent: BindableEvent,

    _onPlayerAdded: (self, player: Player) -> nil,
    _onPlayerRemoving: (self, player: Player) -> nil,
}

local Client = require(script.Client)

function ClientHandler.new(): self
    local self = setmetatable({}, ClientHandler) :: self

    self._clients = {}

    self._clientAddedEvent = Instance.new("BindableEvent")
    self.ClientAdded = self._clientAddedEvent.Event

    Players.PlayerAdded:Connect(function(player: Player)
        self:_onPlayerAdded(player)
    end)
    Players.PlayerRemoving:Connect(function(player: Player)
        self:_onPlayerRemoving(player)
    end)

    return self
end

function ClientHandler.GetClients(self: self): {Client}
    return self._clients
end

function ClientHandler._onPlayerAdded(self: self, player: Player): nil
    local client = Client.new(player)
    table.insert(self._clients, client)
    self._clientAddedEvent:Fire(client)
end
function ClientHandler._onPlayerRemoving(self: self, player: Player): nil
    for index, client in ipairs(self._clients) do
        if client.Player == player then
            client:Destroy()
            table.remove(self._clients, index)
            break
        end
    end
end

return ClientHandler.new()