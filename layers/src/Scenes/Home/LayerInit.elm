module Scenes.Home.LayerInit exposing
    ( LayerInitData(..), nullHomeInit
    , HomeInit
    , initCommonData
    )

{-| This is the doc for this module

@docs LayerInitData, nullHomeInit
@docs HomeInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Home.LayerBase exposing (CommonData, nullCommonData)


{-| LayerInitData

Edit your own LayerInitData here.

-}
type LayerInitData
    = NullLayerInitData


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
