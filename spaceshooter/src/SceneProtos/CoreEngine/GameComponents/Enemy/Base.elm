module SceneProtos.CoreEngine.GameComponents.Enemy.Base exposing (Enemy)


type alias Enemy =
    { velocity : Float
    , position : Int -> Float
    , bulletInterval : Int
    }
