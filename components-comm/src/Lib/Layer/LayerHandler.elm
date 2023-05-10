module Lib.Layer.LayerHandler exposing
    ( update, match, super, recBody
    , updateLayer
    , viewLayer
    )

{-|


# Layer Handler

@docs update, match, super, recBody
@docs updateLayer
@docs viewLayer

-}

import Canvas exposing (Renderable, group)
import Lib.Env.Env exposing (EnvC)
import Lib.Layer.Base exposing (Layer, LayerMsg(..), LayerTarget(..))
import Messenger.GeneralModel exposing (viewModelList)
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionList exposing (updateObjects)


{-| Updater
-}
update : Layer a b c -> EnvC b -> LayerMsg -> ( Layer a b c, List ( LayerTarget, LayerMsg ), EnvC b )
update layer env lm =
    let
        ( newData, newMsgs, newEnv ) =
            layer.update env lm layer.data
    in
    ( { layer | data = newData }, newMsgs, newEnv )


{-| Matcher
-}
match : Layer a b c -> LayerTarget -> Bool
match l t =
    case t of
        LayerParentScene ->
            False

        LayerName n ->
            n == l.name


{-| Super
-}
super : LayerTarget -> Bool
super t =
    case t of
        LayerParentScene ->
            True

        LayerName _ ->
            False


{-| Recbody
-}
recBody : RecBody (Layer a b c) LayerMsg (EnvC b) LayerTarget
recBody =
    { update = update, match = match, super = super }


{-| updateLayer

Update all the layers.

-}
updateLayer : EnvC b -> LayerMsg -> List (Layer a b c) -> ( List (Layer a b c), List LayerMsg, EnvC b )
updateLayer =
    updateObjects recBody


{-| viewLayer

Get the view of the layer.

-}
viewLayer : EnvC b -> List (Layer a b c) -> Renderable
viewLayer env models =
    group [] <| viewModelList env models
