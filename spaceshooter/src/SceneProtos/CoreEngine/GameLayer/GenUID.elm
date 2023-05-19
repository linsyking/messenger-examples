module SceneProtos.CoreEngine.GameLayer.GenUID exposing (genUID)

{-| GenUID
-}

import List exposing (maximum)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent)


{-| Generate a new ID
-}
genUID : List GameComponent -> Int
genUID xs =
    1 + (Maybe.withDefault 0 <| maximum (List.map (\x -> x.data.uid) xs))
