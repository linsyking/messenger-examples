module SceneProtos.SimpleGame.GameLayer.Common exposing (Model, EnvC, nullModel)

{-| This is the doc for this module

@docs Model, EnvC, nullModel

-}

import Array exposing (Array)
import Lib.Env.Env as Env
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { balls : Array GameComponent
    , blackhole : Maybe GameComponent
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { balls = Array.empty
    , blackhole = Nothing
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
