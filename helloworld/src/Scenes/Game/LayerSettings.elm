module Scenes.Game.LayerSettings exposing
    ( LayerDataType(..)
    , LayerT
    )

{-| This module is generated by Messenger, don't modify this.

@docs LayerDataType
@docs LayerT

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Game.A.Export as A
import Scenes.Game.B.Export as B
import Scenes.Game.LayerBase exposing (CommonData)


{-| LayerDataType
-}
type LayerDataType
    = BData B.Data
    | AData A.Data
    | NullLayerData


{-| LayerT
-}
type alias LayerT =
    Layer LayerDataType CommonData