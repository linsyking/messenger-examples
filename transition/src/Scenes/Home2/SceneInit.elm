module Scenes.Home2.SceneInit exposing
    ( nullHome2Init
    , Home2Init
    , initCommonData
    )

{-| SceneInit

@docs nullHome2Init
@docs Home2Init
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Home2.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias Home2Init =
    {}


{-| Null Home2Init data
-}
nullHome2Init : Home2Init
nullHome2Init =
    {}


{-| Initialize common data
-}
initCommonData : Env -> Home2Init -> CommonData
initCommonData _ _ =
    nullCommonData
