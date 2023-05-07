module Scenes.SceneSettings exposing
    ( SceneDataTypes(..)
    , SceneT
    , nullSceneT
    )

{-| This is the doc for this module

@docs SceneDataTypes
@docs SceneT
@docs nullSceneT

-}

import Lib.Scene.Base exposing (Scene)
import Lib.Tools.Maybe exposing (nothing2)
import Scenes.Home.Export as Home



--- Set Scenes


{-| SceneDataTypes

All the scene data types should be listed here.

-}
type SceneDataTypes
    = HomeDataT Home.Data
    | NullSceneData


{-| SceneT

SceneT is a Scene with datatypes.

-}
type alias SceneT =
    Scene SceneDataTypes


{-| nullSceneT
-}
nullSceneT : SceneT
nullSceneT =
    { init = \_ _ -> NullSceneData
    , update = \_ g ( _, _ ) -> ( NullSceneData, [], g )
    , view = nothing2
    }
