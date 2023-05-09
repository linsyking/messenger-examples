module Lib.Layer.LayerHandler exposing
    ( updateLayer
    , viewLayer
    )

{-|


# Layer Handler

Compare this to Lib.Layer.LayerHandlerRaw.elm.

If you want to implement custom layer handler, please use the raw version.

For example, you can implement a "stopper" that stops the layer updating if some confitions are satisfied.

@docs updateLayer

@docs viewLayer

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (Env, Layer, LayerMsg(..), LayerTarget(..))
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionList exposing (updateObjects)


update : Layer a b c -> Env b -> LayerMsg -> ( Layer a b c, List ( LayerTarget, LayerMsg ), Env b )
update layer env lm =
    let
        ( newData, newMsgs, newEnv ) =
            layer.update env lm layer.data
    in
    ( { layer | data = newData }, newMsgs, newEnv )


match : Layer a b c -> LayerTarget -> Bool
match l t =
    case t of
        LayerParentScene ->
            False

        LayerName n ->
            n == l.name


super : LayerTarget -> Bool
super t =
    case t of
        LayerParentScene ->
            True

        LayerName _ ->
            False


recBody : RecBody (Layer a b c) LayerMsg (Env b) LayerTarget
recBody =
    { update = update, match = match, super = super }


{-| updateLayer

Update all the layers.

-}
updateLayer : Env b -> LayerMsg -> List (Layer a b c) -> ( List (Layer a b c), List LayerMsg, Env b )
updateLayer =
    updateObjects recBody


{-| viewLayer

Get the view of the layer.

-}
viewLayer : Env b -> List (Layer a b c) -> Renderable
viewLayer env xs =
    Canvas.group []
        (List.map (\l -> l.view env l.data) xs)
