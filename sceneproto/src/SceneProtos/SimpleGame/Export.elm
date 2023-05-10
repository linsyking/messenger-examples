module SceneProtos.SimpleGame.Export exposing
    ( Data
    , nullData
    , scene
    )

{-| This is the doc for this module

@docs Data
@docs nullData
@docs scene

-}

import Lib.Scene.Base exposing (Scene)
import SceneProtos.SimpleGame.Common exposing (Model)
import SceneProtos.SimpleGame.LayerBase exposing (nullCommonData)
import SceneProtos.SimpleGame.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| nullData
-}
nullData : Data
nullData =
    { commonData = nullCommonData
    , layers = []
    }


{-| scene
-}
scene : Scene Data
scene =
    { init = initModel
    , update = updateModel
    , view = viewModel
    }
