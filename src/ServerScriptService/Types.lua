export type ClientHandler = {
    ClientAdded: RBXScriptSignal,

    GetClients: (nil) -> {Client},
}
export type Client = {
    SpawnCharacter: (nil, characterType: string) -> nil,
}