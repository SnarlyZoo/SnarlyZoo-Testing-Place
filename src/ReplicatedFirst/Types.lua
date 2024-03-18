export type InputService = {
    ActionChanged: RBXScriptSignal,

    GetAction: (nil, actionName: string) -> boolean,
    GetAxis: (nil, axisName: string) -> number,
}

export type PlayerModule = {
    GetController: (nil) -> CharacterController,
}

export type FirstPersonCamera = {
    Destroy: (nil) -> nil,

    Look: (nil, lookVector: Vector2) -> nil,
}

export type CharacterController = {
    Destroy: (nil) -> nil,

    Move: (nil, moveDirection: Vector3, relativeToCamera: boolean?) -> nil,
    QueueJump: (nil, toJump: boolean) -> nil,
}