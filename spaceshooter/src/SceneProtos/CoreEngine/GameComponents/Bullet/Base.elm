module SceneProtos.CoreEngine.GameComponents.Bullet.Base exposing (BulletInit)

import Color exposing (Color)


type alias BulletInit =
    { velocity : Float
    , position : ( Float, Float )
    , color : Color
    }
