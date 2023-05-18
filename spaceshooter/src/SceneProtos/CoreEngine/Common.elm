module SceneProtos.CoreEngine.Common exposing (Model, nullModel)

{-| This is the doc for this module

@docs Model, nullModel

-}

import Lib.Scene.Base exposing (LayerPacker)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData, nullCommonData)
import SceneProtos.CoreEngine.LayerSettings exposing (LayerT)


{-| Model
-}
type alias Model =
    LayerPacker CommonData LayerT


{-| nullModel
-}
nullModel : Model
nullModel =
    { commonData = nullCommonData
    , layers = []
    }
