module Scenes.Home.MainLayer.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Home.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { title : String
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { title = ""
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
