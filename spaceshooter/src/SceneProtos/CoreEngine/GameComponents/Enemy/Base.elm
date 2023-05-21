module SceneProtos.CoreEngine.GameComponents.Enemy.Base exposing (EnemyInit)


type alias EnemyInit =
    { velocity : Float
    , position : ( Float, Float )
    , sinF : Float
    , sinA : Float
    , bulletInterval : Int
    }
