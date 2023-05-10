module SceneProtos.SimpleGame.Common exposing (Model)

{-| This is the doc for this module

@docs Model

-}

import Lib.Scene.Base exposing (LayerPacker)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)
import SceneProtos.SimpleGame.LayerSettings exposing (LayerT)


{-| Model
-}
type alias Model =
    LayerPacker CommonData LayerT
