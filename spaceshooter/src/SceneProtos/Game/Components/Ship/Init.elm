module SceneProtos.Game.Components.Ship.Init exposing (InitData)


type alias InitData =
    { id : Int
    , position : ( Float, Float )
    , bulletInterval : Int
    }
