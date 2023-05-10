module SceneProtos.SimpleGame.GameLayer.Export exposing
    ( Data
    , nullData
    , layer
    )

{-| This is the doc for this module

@docs Data
@docs nullData
@docs layer

-}

import Array
import Lib.Layer.Base exposing (Layer)
import SceneProtos.SimpleGame.GameLayer.Common exposing (Model)
import SceneProtos.SimpleGame.GameLayer.Model exposing (initModel, updateModel, viewModel)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData, LayerInitData)


{-| Data
-}
type alias Data =
    Model


{-| nullData
-}
nullData : Data
nullData =
    { components = Array.empty
    }


{-| layer
-}
layer : Layer Data CommonData LayerInitData
layer =
    { name = "GameLayer"
    , data = nullData
    , init = initModel
    , update = updateModel
    , view = viewModel
    }
