module Scenes.Main.UILayer.Common exposing (Model, nullModel, EnvC)

{-| This is the doc for this module

@docs Model, nullModel, EnvC

-}

import Lib.Component.Base exposing (Component)
import Lib.Env.Env as Env
import Scenes.Main.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { components : List Component
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { components = []
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
