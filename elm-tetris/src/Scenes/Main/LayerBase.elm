module Scenes.Main.LayerBase exposing
    ( CommonData
    , LayerInitData(..), State(..), nullCommonData, setState
    )

{-| This is the doc for this module

@docs CommonData
@docs initCommonData

-}


type State
    = Paused
    | Playing
    | Stopped


{-| CommonData
Edit your own CommonData here.
-}
type alias CommonData =
    { state : State
    }


setState : State -> CommonData -> CommonData
setState state commonData =
    { commonData | state = state }


{-| Init CommonData
-}
nullCommonData : CommonData
nullCommonData =
    { state = Stopped
    }


type LayerInitData
    = NullLayerInitData
