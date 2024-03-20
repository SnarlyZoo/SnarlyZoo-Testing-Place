local ServerScriptService = game:GetService("ServerScriptService")

local Types = ServerScriptService.Types
type Client = Types.Client

local ClientHandler = require(ServerScriptService.ClientHandler)

ClientHandler.ClientAdded:Connect(function(client: Client)
    client:SpawnCharacter("FPS")
end)