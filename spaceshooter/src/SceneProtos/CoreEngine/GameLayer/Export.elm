module SceneProtos.CoreEngine.GameLayer.Export exposing
    ( Data
    , initLayer, initFromScene
    )

{-| This is the doc for this module

@docs Data
@docs initLayer, initFromScene

-}

import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (Layer)
import SceneProtos.CoreEngine.GameLayer.Common exposing (EnvC, Model)
import SceneProtos.CoreEngine.GameLayer.Model exposing (initModel, updateModel, viewModel)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)
import SceneProtos.CoreEngine.LayerInit exposing (CoreEngineInit, LayerInitData(..))


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


{-| Initialize from the scene
-}
initFromScene : Env -> CoreEngineInit -> LayerInitData
initFromScene _ init =
    GameLayerInitData init
