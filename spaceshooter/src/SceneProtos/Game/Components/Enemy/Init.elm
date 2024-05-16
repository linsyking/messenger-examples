module SceneProtos.Game.Components.Enemy.Init exposing (InitData)


type alias InitData =
    { id : Int
    , velocity : Float
    , position : ( Float, Float )
    , sinF : Float
    , sinA : Float
    , bulletInterval : Int
    }
