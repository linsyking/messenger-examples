module SceneProtos.SimpleGame.GameLayer.Export exposing
    ( Data
    , initLayer
    )

{-| This is the doc for this module

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import SceneProtos.SimpleGame.GameLayer.Common exposing (EnvC, Model)
import SceneProtos.SimpleGame.GameLayer.Model exposing (initModel, updateModel, viewModel)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)
import SceneProtos.SimpleGame.LayerInit exposing (LayerInitData)


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
