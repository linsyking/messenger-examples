module Scenes.Home.Main.Export exposing
    ( Data
    , initLayer
    )

{-| Export module

The export module for layer.

Although this will not be updated, usually you don't need to change this file.

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Home.LayerBase exposing (CommonData)
import Scenes.Home.Main.Common exposing (EnvC, Model)
import Scenes.Home.Main.Model exposing (initModel, updateModel, viewModel)
import Scenes.Home.SceneInit exposing (HomeInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> HomeInit -> Layer Data CommonData
initLayer env i =
    { name = "Main"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
