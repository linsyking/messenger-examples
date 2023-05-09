module Scenes.Home.LayerSettings exposing
    ( LayerDataType(..)
    , LayerT
    )

{-| This is the doc for this module

@docs LayerDataType

@docs LayerT

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Home.GameLayer.Export as GameLayer
import Scenes.Home.GameLayer2.Export as GameLayer2
import Scenes.Home.LayerBase exposing (CommonData, LayerInitData)


{-| LayerDataType
-}
type LayerDataType
    = GameLayerData GameLayer.Data
    | GameLayer2Data GameLayer2.Data
    | NullLayerData


{-| LayerT
-}
type alias LayerT =
    Layer LayerDataType CommonData LayerInitData
