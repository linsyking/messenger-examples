module SceneProtos.CoreEngine.LayerInit exposing
    ( LayerInitData(..), nullCoreEngineInit
    , CoreEngineInit
    , initCommonData
    )

{-| This is the doc for this module

@docs LayerInitData, nullCoreEngineInit
@docs CoreEngineInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData, nullCommonData)


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


{-| Null coreengine init
-}
nullCoreEngineInit : CoreEngineInit
nullCoreEngineInit =
    { objects = []
    }


{-| Initialize common data
-}
initCommonData : Env -> CoreEngineInit -> CommonData
initCommonData _ _ =
    nullCommonData
