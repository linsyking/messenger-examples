module SceneProtos.SimpleGame.GameLayer.Export exposing
    ( Data
    , nullData
    , initLayer
    )

{-| This is the doc for this module

@docs Data
@docs nullData
@docs initLayer

-}

import Array
import Lib.Layer.Base exposing (Layer)
import SceneProtos.SimpleGame.GameLayer.Common exposing (EnvC, Model)
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
    { balls = Array.empty }


{-| initLayer
-}
initLayer : EnvC -> LayerInitData -> Layer Data CommonData
initLayer env i =
    { name = "GameLayer"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
