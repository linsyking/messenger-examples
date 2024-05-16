module SceneProtos.Game.Components.Bullet.Init exposing (CreateInitData, InitData)

import Color exposing (Color)


type alias InitData =
    { id : Int
    , velocity : Float
    , position : ( Float, Float )
    , color : Color
    }


type alias CreateInitData =
    { velocity : Float
    , position : ( Float, Float )
    , color : Color
    }
