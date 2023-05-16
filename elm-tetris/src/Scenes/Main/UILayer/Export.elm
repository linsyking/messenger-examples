module Scenes.Main.UILayer.Export exposing
    ( Data
    , initLayer
    )

{-| This is the doc for this module

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Main.LayerBase exposing (CommonData, LayerInitData)
import Scenes.Main.UILayer.Common exposing (EnvC, Model)
import Scenes.Main.UILayer.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> LayerInitData -> Layer Data CommonData
initLayer env i =
    { name = "UILayer"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
