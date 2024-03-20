export type InputService = {
    ActionChanged: RBXScriptSignal,

    GetAction: (nil, actionName: string) -> boolean,
    GetAxis: (nil, axisName: string) -> number,
}

export type PlayerModule = {
    GetCharacter: (nil) -> Character,
    LoadCharacter: (nil, characterType: string, character: Model) -> nil,
}

export type Character = {
    Destroy: (nil) -> nil,

    Setup: (player: Player, character: Model) -> nil,
}
export type FPSCharacter = Character

export type FPLooker = {
    Destroy: (nil) -> nil,
}

export type PhysicsMover = {
    Destroy: (nil) -> nil,

    Setup: (character: Model) -> nil,
}