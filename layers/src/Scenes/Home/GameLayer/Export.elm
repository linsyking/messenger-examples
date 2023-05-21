module Scenes.Home.GameLayer.Export exposing
    ( Data
    , initLayer, initFromScene
    )

{-| This is the doc for this module

@docs Data
@docs initLayer, initFromScene

-}

import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (Layer)
import Scenes.Home.GameLayer.Common exposing (EnvC, Model)
import Scenes.Home.GameLayer.Model exposing (initModel, updateModel, viewModel)
import Scenes.Home.LayerBase exposing (CommonData)
import Scenes.Home.LayerInit exposing (HomeInit, LayerInitData(..))


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

{-|
Initialize layer from scene init data
-}
initFromScene : Env -> HomeInit -> LayerInitData
initFromScene _ _ =
    NullLayerInitData
