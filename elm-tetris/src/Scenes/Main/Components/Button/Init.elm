module Scenes.Main.Components.Button.Init exposing
    ( InitData
    , ButtonType(..)
    )

{-|


# Init module

@docs InitData

-}

import Canvas exposing (Point)
import Color exposing (Color)
import Lib.Tetris.Base exposing (Direction)


{-| The data used to initialize the scene
-}
type alias InitData =
    { size : ( Float, Float )
    , position : Point
    , text : { content : String, color : Color }
    , backgroundColor : Color
    , buttonType : ButtonType
    }


type ButtonType
    = State
    | Move Direction
    | Rotate
    | Accelerate
