module SceneProtos.SimpleGame.LayerBase exposing
    ( CommonData
    , LayerInitData(..), SimpleGameInit, nullCommonData
    )

{-| This is the doc for this module

@docs CommonData
@docs initCommonData

-}


{-| CommonData

Edit your own CommonData here!

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


type alias SimpleGameInit =
    { ballPositions : List ( Int, Int )
    , ballVelocities : List ( Float, Float )
    }
