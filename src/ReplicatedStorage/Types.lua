local Types = {}

export type ClientHandler = {
    ClientAdded: RBXScriptSignal,

    GetClient: (player: Player) -> Client,
}
export type Client = {
    Player: Player,

    Destroy: () -> nil,

    ChangeUserType: (userType: UserType) -> nil,
    GetUserType: () -> UserType,
}

export type LobbyUser = {
    UserType: "Lobby",

    Destroy: () -> nil,

    Spawn: (position: CFrame) -> nil,
}
export type User = LobbyUser
export type UserType = "Lobby"

return Types