module SceneProtos.CoreEngine.GameLayer.Collision exposing (updateCollision)

import Messenger.RecursionList exposing (updateObjectsWithTarget)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent, GameComponentMsg(..), GameComponentTarget(..))
import SceneProtos.CoreEngine.GameComponent.Handler exposing (recBody)
import SceneProtos.CoreEngine.GameLayer.Common exposing (EnvC)


{-| Update collision of the game components
-}
updateCollision : EnvC -> List GameComponent -> ( List GameComponent, List GameComponentMsg, EnvC )
updateCollision env xs =
    updateObjectsWithTarget recBody env (judgeCollision xs) xs


{-| Judge Collision, return the list of messages to be sent to the game components
-}
judgeCollision : List GameComponent -> List ( GameComponentTarget, GameComponentMsg )
judgeCollision xs =
    judgeCollisionHelper xs xs []


{-| xs is all the objects

ys are the remaining ones

-}
judgeCollisionHelper : List GameComponent -> List GameComponent -> List ( GameComponentTarget, GameComponentMsg ) -> List ( GameComponentTarget, GameComponentMsg )
judgeCollisionHelper xs ys acc =
    case ys of
        [] ->
            acc

        z :: zs ->
            let
                newMsgs =
                    List.foldl
                        (\x lastMsgs ->
                            if x.data.uid == z.data.uid then
                                lastMsgs

                            else
                                lastMsgs ++ judgeOne z x
                        )
                        acc
                        xs
            in
            judgeCollisionHelper xs zs newMsgs


judgeOne : GameComponent -> GameComponent -> List ( GameComponentTarget, GameComponentMsg )
judgeOne p q =
    let
        p1 =
            p.data.position

        ( p1x, p1y ) =
            p.data.position

        ( p1w, p1h ) =
            p.data.collisionBox

        p2 =
            ( p1x + p1w, p1y + p1h )

        q1 =
            q.data.position

        ( q1x, q1y ) =
            q.data.position

        ( q1w, q1h ) =
            q.data.collisionBox

        q2 =
            ( q1x + q1w, q1y + q1h )
    in
    if judgeSimpleCollision ( p1, p2 ) ( q1, q2 ) then
        [ ( GCById p.data.uid, GCCollisionMsg q.name ), ( GCById q.data.uid, GCCollisionMsg p.name ) ]

    else
        []


{-| judgeSimpleCollision
Simply judge if two rectangle collides.

Here inputs are all the vertices, not width/height

-}
judgeSimpleCollision : ( ( Float, Float ), ( Float, Float ) ) -> ( ( Float, Float ), ( Float, Float ) ) -> Bool
judgeSimpleCollision ( p1, p2 ) ( p3, p4 ) =
    let
        p1x =
            Tuple.first p1

        p1y =
            Tuple.second p1

        p2x =
            Tuple.first p2

        p2y =
            Tuple.second p2

        p3x =
            Tuple.first p3

        p3y =
            Tuple.second p3

        p4x =
            Tuple.first p4

        p4y =
            Tuple.second p4
    in
    if p2y >= p3y && p1y <= p4y && p2x >= p3x && p1x <= p4x then
        True

    else
        False
