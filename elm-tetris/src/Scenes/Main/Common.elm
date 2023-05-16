module Scenes.Main.Common exposing (Model, nullModel)

{-| This is the doc for this module

@docs Model, nullModel

-}

import Lib.Scene.Base exposing (LayerPacker)
import Scenes.Main.LayerBase exposing (CommonData, nullCommonData)
import Scenes.Main.LayerSettings exposing (LayerT)


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
