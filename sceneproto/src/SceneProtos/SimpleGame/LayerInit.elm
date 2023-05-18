module SceneProtos.SimpleGame.LayerInit exposing
    ( LayerInitData(..)
    , SimpleGameInit
    )

{-|

@docs LayerInitData
@docs SumpleGameInit

-}

import Array exposing (Array)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent)


{-| Layer init
-}
type LayerInitData
    = GameLayerInitData SimpleGameInit
    | NullLayerInitData


{-| simple game init
-}
type alias SimpleGameInit =
    { balls : Array GameComponent
    , blackhole : Maybe GameComponent
    }
