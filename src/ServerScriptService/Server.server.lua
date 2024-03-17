local ServerScriptService = game:GetService("ServerScriptService")

local Types = require(ServerScriptService.Types)
type Client = Types.Client

local ClientHandler = require(ServerScriptService.ClientHandler)

ClientHandler.ClientAdded:Connect(function(client: Client)

end)