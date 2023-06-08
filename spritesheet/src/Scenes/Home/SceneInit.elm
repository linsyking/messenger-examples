module Scenes.Home.SceneInit exposing
    ( nullHomeInit
    , HomeInit
    , initCommonData
    )

{-| SceneInit

@docs nullHomeInit
@docs HomeInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Home.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias HomeInit =
    {}


{-| Null HomeInit data
-}
nullHomeInit : HomeInit
nullHomeInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> HomeInit -> CommonData
initCommonData _ _ =
    nullCommonData
