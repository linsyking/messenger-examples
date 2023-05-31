module Scenes.Game.SceneInit exposing
    ( nullGameInit
    , GameInit
    , initCommonData
    )

{-| SceneInit

@docs nullGameInit
@docs GameInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Game.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias GameInit =
    {}


{-| Null GameInit data
-}
nullGameInit : GameInit
nullGameInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> GameInit -> CommonData
initCommonData _ _ =
    nullCommonData
