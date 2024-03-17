local ServerScriptService = game:GetService("ServerScriptService")

local Types = require(ServerScriptService.Types)
type User = Types.User
type UserType = Types.UserType

local Users = ServerScriptService.Users

local Client = {}
Client.__index = Client

type self = Types.Client & {
    _user: User,
}

function Client.new(player: Player): self
    local self = setmetatable({}, Client) :: self

    self.Player = player

    self:ChangeUserType("Lobby")

    return self
end
function Client.Destroy(self: self): nil
    self:ChangeUserType(nil)
end

function Client.ChangeUserType(self: self, userType: UserType?): nil
    if self._user then
        self._user:Destroy()
    end

    if userType then
        self._user = require(Users:FindFirstChild(userType .. "User")).new(self.Player)
    end
end
function Client.GetUserType(self: self): UserType
    return self._user.UserType
end

return Client