type Connection = {
    Disconnect: () -> nil,
}
type Signal = {
    Connect: (fn: (any) -> nil) -> Connection,
    DisconnectAll: () -> nil,
    Fire: (any) -> nil,
    Wait: () -> any,
    Once: (fn: (any) -> nil) -> Connection,
}

export type ClientHandler = {
    ClientAdded: Signal,

    GetClients: () -> {Client},
}
export type Client = {
    Player: Player,

    SpawnCharacter: (nil, characterType: string) -> nil,
}