module Scenes.Home.SceneBase exposing
    ( LayerTarget
    , SceneCommonData
    , LayerMsg(..)
    )

{-|


# LayerBase

Basic data for the layers.

@docs LayerTarget
@docs SceneCommonData
@docs LayerMsg

-}


{-| Layer target type
-}
type alias LayerTarget =
    String


{-| Common data
-}
type alias SceneCommonData =
    {}


{-| Gerneral meassge for layers.

Add layer specific messages here.

-}
type LayerMsg
    = NullLayerMsg
