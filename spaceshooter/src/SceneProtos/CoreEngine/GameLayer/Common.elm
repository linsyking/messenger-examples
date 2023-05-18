module SceneProtos.CoreEngine.GameLayer.Common exposing (Model, EnvC, nullModel)

{-| This is the doc for this module

@docs Model, EnvC, nullModel

-}

import Array exposing (Array)
import Lib.Env.Env as Env
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { objects : Array GameComponent
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { objects = Array.empty
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
