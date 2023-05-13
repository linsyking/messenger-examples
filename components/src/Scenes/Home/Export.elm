module Scenes.Home.Export exposing
    ( Data
    , scene
    )

{-| This is the doc for this module

@docs Data
@docs scene

-}

import Lib.Scene.Base exposing (Scene)
import Scenes.Home.Common exposing (Model)
import Scenes.Home.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| scene
-}
scene : Scene Data
scene =
    { init = initModel
    , update = updateModel
    , view = viewModel
    }
