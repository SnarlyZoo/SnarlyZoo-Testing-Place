export type ClientHandler = {
    GetClients: (nil) -> {Client},
}
export type Client = {
    Player: Player,

    SpawnCharacter: (nil, characterType: string) -> nil,
}