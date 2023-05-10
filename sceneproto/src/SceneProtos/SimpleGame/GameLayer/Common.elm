module SceneProtos.SimpleGame.GameLayer.Common exposing (Model, EnvC)

{-| This is the doc for this module

@docs Model, EnvC

-}

import Array exposing (Array)
import Lib.Env.Env as Env
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { balls : Array GameComponent
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
