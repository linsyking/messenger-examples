module Scenes.Home.GameLayer.Common exposing (Model, Env)

{-| This is the doc for this module

@docs Model, Env

-}

import Array exposing (Array)
import Lib.Component.Base exposing (Component)
import Lib.Layer.Base as L
import Scenes.Home.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { components : Array Component
    }


{-| Convenient type alias for the environment
-}
type alias Env =
    L.Env CommonData
