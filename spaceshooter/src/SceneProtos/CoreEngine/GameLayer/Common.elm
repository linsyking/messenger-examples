module SceneProtos.CoreEngine.GameLayer.Common exposing (Model, EnvC, nullModel)

{-| This is the doc for this module

@docs Model, EnvC, nullModel

-}

import Lib.Env.Env as Env
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    {}


{-| nullModel
-}
nullModel : Model
nullModel =
    {}


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
