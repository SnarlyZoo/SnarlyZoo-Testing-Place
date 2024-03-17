local Types = {}

export type ClientHandler = {
    ClientAdded: RBXScriptSignal,

    GetClient: (nil, player: Player) -> Client,
}
export type Client = {
    Player: Player,

    Destroy: () -> nil,

    ChangeUserType: (nil, userType: UserType) -> nil,
    GetUserType: () -> UserType,
}

export type LobbyUser = {
    UserType: "Lobby",

    Destroy: () -> nil,

    Spawn: (nil, position: CFrame?) -> nil,
}
export type User = LobbyUser
export type UserType = "Lobby"

return Types