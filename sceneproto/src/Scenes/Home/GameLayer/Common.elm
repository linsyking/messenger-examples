module Scenes.Home.GameLayer.Common exposing (Model, nullModel, EnvC)

{-| This is the doc for this module

@docs Model, nullModel, EnvC

-}

import Array exposing (Array)
import Lib.Component.Base exposing (Component)
import Lib.Env.Env as Env
import Scenes.Home.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { components : Array Component
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { components = Array.empty
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
