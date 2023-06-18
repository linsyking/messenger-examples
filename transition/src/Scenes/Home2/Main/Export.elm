module Scenes.Home2.Main.Export exposing
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
import Scenes.Home2.LayerBase exposing (CommonData)
import Scenes.Home2.Main.Common exposing (EnvC, Model)
import Scenes.Home2.Main.Model exposing (initModel, updateModel, viewModel)
import Scenes.Home2.SceneInit exposing (Home2Init)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> Home2Init -> Layer Data CommonData
initLayer env i =
    { name = "Main"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
