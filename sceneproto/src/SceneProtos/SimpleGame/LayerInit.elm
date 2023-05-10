module SceneProtos.SimpleGame.LayerInit exposing (LayerInitData(..), SimpleGameInit)

import Array exposing (Array)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent)


type LayerInitData
    = GameLayerInitData SimpleGameInit
    | NullLayerInitData


type alias SimpleGameInit =
    { balls : Array GameComponent
    }
