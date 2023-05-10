module SceneProtos.SimpleGame.GameLayer.Common exposing (Model, EnvC)

{-| This is the doc for this module

@docs Model, EnvC

-}

import Array exposing (Array)
import Lib.Component.Base exposing (Component)
import Lib.Env.Env as Env
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { components : Array Component
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
