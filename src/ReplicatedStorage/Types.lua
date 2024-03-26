type Connection = {
    Disconnect: () -> nil,
}
export type Signal = {
    Connect: (fn: (any) -> nil) -> Connection,
    DisconnectAll: () -> nil,
    Fire: (any) -> nil,
    Wait: () -> any,
    Once: (fn: (any) -> nil) -> Connection,
}

export type DebugService = {
    Enable: () -> nil,
    Disable: () -> nil,

    _DebugObjectCreated: (nil, object: DebugObject) -> nil,
    _DebugObjectDestroying: (nil, object: DebugObject) -> nil,
}
export type DebugObject = {
    Enabled: boolean,
    Name: string,

    Destroy: () -> nil,
}

export type InputService = {
    ActionChanged: Signal,

    GetAction: (nil, actionName: string) -> boolean,
    GetAxis: (nil, axisName: string) -> number,
}

export type PlayerModule = {
    GetCharacter: () -> Character,
    LoadCharacter: (nil, characterType: string, character: Model) -> nil,
}

export type Character = {
    Destroy: () -> nil,

    Setup: (player: Player, character: Model) -> nil,
}

export type Looker = {
    Enabled: boolean,

    Destroy: () -> nil,
}

export type Mover = {
    Enabled: boolean,

    Destroy: () -> nil,

    ChangeState: (nil, stateName: string) -> nil,

    Setup: (character: Model) -> nil,
}
export type MoverState = {
    Destroy: () -> nil,

    Enter: () -> nil,
    Exit: () -> nil,

    Update: (nil, deltaTime: number) -> nil,
}