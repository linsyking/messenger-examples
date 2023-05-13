module Scenes.Home.LayerBase exposing
    ( CommonData
    , LayerInitData(..), nullCommonData
    )

{-| This is the doc for this module

@docs CommonData
@docs initCommonData

-}


{-| CommonData
Edit your own CommonData here.
-}
type alias CommonData =
    {}


{-| Init CommonData
-}
nullCommonData : CommonData
nullCommonData =
    {}


type LayerInitData
    = NullLayerInitData
