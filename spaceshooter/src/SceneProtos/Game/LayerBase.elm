module SceneProtos.Game.LayerBase exposing
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

import SceneProtos.Game.Main.Init as MainInit


{-| Layer target type
-}
type alias LayerTarget =
    String


{-| Common data
-}
type alias SceneCommonData =
    {}


{-| General message for layers
-}
type LayerMsg scenemsg
    = MainInitData (MainInit.InitData SceneCommonData scenemsg)
    | NullLayerMsg
