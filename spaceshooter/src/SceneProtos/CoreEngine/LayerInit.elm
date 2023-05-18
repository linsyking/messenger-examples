module SceneProtos.CoreEngine.LayerInit exposing
    ( LayerInitData(..)
    , CoreEngineInit
    )

{-| This is the doc for this module

@docs LayerInitData
@docs CoreEngineInit

-}

import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent)


{-| LayerInitData

Edit your own LayerInitData here.

-}
type LayerInitData
    = GameLayerInitData CoreEngineInit
    | NullLayerInitData


{-| Init Data
-}
type alias CoreEngineInit =
    { objects : List GameComponent
    }
