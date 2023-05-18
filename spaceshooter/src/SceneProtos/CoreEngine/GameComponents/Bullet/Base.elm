module SceneProtos.CoreEngine.GameComponents.Bullet.Base exposing (Bullet)

import Color exposing (Color)


type alias Bullet =
    { velocity : Float
    , position : ( Float, Float )
    , color : Color
    }
