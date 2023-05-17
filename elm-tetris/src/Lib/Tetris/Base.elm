module Lib.Tetris.Base exposing (AnimationState, TetrisEvent(..))


type TetrisEvent
    = Start
    | Pause
    | Resume
    | MoveLeft Bool
    | MoveRight Bool
    | Rotate Bool
    | Accelerate Bool
    | CancelAll
    | GameOver


type alias AnimationState =
    Maybe
        { active : Bool
        , elapsed : Float
        }
