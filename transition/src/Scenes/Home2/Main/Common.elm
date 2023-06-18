module Scenes.Home2.Main.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Home2.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
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
