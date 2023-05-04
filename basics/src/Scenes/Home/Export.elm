module Scenes.Home.Export exposing
    ( Data
    , nullData
    , scene
    )

{-| This is the doc for this module

@docs Data

@docs nullData

@docs scene

-}

import Lib.Scene.Base exposing (..)
import Scenes.Home.Common exposing (Model)
import Scenes.Home.LayerBase exposing (initCommonData)
import Scenes.Home.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| nullData
-}
nullData : Data
nullData =
    { commonData = initCommonData
    , layers = []
    }


{-| scene
-}
scene : Scene Data
scene =
    { init = initModel
    , update = updateModel
    , view = viewModel
    }
