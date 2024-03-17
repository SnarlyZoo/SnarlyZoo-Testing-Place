local Types = {}

export type InputService = {
    ChangeInputType: (nil, inputType: InputType) -> nil,
    GetInputType: () -> InputType,

    GetInputAction: (nil, actionName: string) -> InputAction,
    GetInputAxis: (nil, axisName: string) -> InputAxis,
}
export type InputAction = {
    Value: boolean,
    Changed: RBXScriptSignal,
}
export type InputAxis = {
    Value: number,
    Changed: RBXScriptSignal,
}

export type KeyboardInput = {
    InputType: "Keyboard",

    Destroy: () -> nil,
}
export type Inputter = KeyboardInput
export type InputType = "Keyboard"


export type PlayerModule = {
    Player: Player,

    ChangeControllerType: (nil, controllerType: ControllerType, any?) -> nil,
    GetControllerType: () -> ControllerType,
}


export type TestController = {
    ControllerType: "Test",

    Destroy: () -> nil,
}
export type Controller = TestController
export type ControllerType = "Test"

export type TestLooker = {
    Destroy: () -> nil,

    ProcessDelta: (nil, delta: Vector3) -> nil,
}
export type Looker = TestLooker

export type TestMovement = {
    Destroy: () -> nil,

    Move: (nil, moveDirection: Vector3, relativeToCamera: boolean?) -> nil,

    Jump: (nil) -> nil,
}
export type Movement = TestMovement

return Types