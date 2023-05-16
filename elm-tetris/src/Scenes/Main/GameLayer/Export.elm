module Scenes.Main.GameLayer.Export exposing
    ( Data
    , initLayer
    )

{-| This is the doc for this module

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Main.GameLayer.Common exposing (EnvC, Model)
import Scenes.Main.GameLayer.Model exposing (initModel, updateModel, viewModel)
import Scenes.Main.LayerBase exposing (CommonData, LayerInitData)


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
