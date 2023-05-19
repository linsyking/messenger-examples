module SceneProtos.CoreEngine.GameComponents.Enemy.Base exposing (Enemy)


type alias Enemy =
    { velocity : Float
    , position : ( Float, Float )
    , sinF : Float
    , sinA : Float
    , bulletInterval : Int
    }
