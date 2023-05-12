module Scenes.Home.GameLayer.Export exposing
    ( Data
    , initLayer
    )

{-| This is the doc for this module

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Home.GameLayer.Common exposing (EnvC, Model)
import Scenes.Home.GameLayer.Model exposing (initModel, updateModel, viewModel)
import Scenes.Home.LayerBase exposing (CommonData, LayerInitData)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> LayerInitData -> Layer Data CommonData
initLayer env i =
    { name = "GameLayer"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
