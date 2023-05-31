module Scenes.Game.B.Export exposing
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
import Scenes.Game.B.Common exposing (EnvC, Model)
import Scenes.Game.B.Model exposing (initModel, updateModel, viewModel)
import Scenes.Game.LayerBase exposing (CommonData)
import Scenes.Game.SceneInit exposing (GameInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> GameInit -> Layer Data CommonData
initLayer env i =
    { name = "B"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
