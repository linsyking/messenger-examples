module Lib.Component.ComponentHandler exposing
    ( update, match, super, recBody
    , updateComponents
    , viewComponent
    )

{-| ComponentHandler deals with components

You can use these functions to handle components.

The mosy commonly used one is the `updateComponents` function, which will update all components recursively.

@docs update, match, super, recBody
@docs updateComponents
@docs viewComponent

-}

import Array exposing (Array)
import Canvas exposing (Renderable, group)
import Dict
import Lib.Component.Base exposing (Component, ComponentMsg(..), ComponentTarget(..), DefinedTypes(..))
import Lib.Env.Env exposing (Env)
import Messenger.GeneralModel exposing (viewModelArray)
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionArray exposing (updateObjects)



-- Below are using the Recursion algorithm to get the update function


{-| Updater
-}
update : Component -> Env -> ComponentMsg -> ( Component, List ( ComponentTarget, ComponentMsg ), Env )
update c env ct =
    let
        ( newx, newmsg, newenv ) =
            c.update env ct c.data
    in
    ( { c | data = newx }, newmsg, newenv )


{-| Matcher
-}
match : Component -> ComponentTarget -> Bool
match c ct =
    case ct of
        ComponentParentLayer ->
            False

        ComponentByID x ->
            Dict.get "id" c.data == Just (CDInt x)

        ComponentByName x ->
            c.name == x


{-| Super
-}
super : ComponentTarget -> Bool
super ct =
    case ct of
        ComponentParentLayer ->
            True

        _ ->
            False


{-| Rec body for the component
-}
recBody : RecBody Component ComponentMsg Env ComponentTarget
recBody =
    { update = update
    , match = match
    , super = super
    }


{-| Update all the components in an array and recursively update the components which have messenges sent.

Return a list of messages sent to the parentlayer.

-}
updateComponents : Env -> Array Component -> ( Array Component, List ComponentMsg, Env )
updateComponents env =
    updateObjects recBody env NullComponentMsg


{-| Generate the view of the components
-}
viewComponent : Env -> Array Component -> Renderable
viewComponent env xs =
    group [] <| viewModelArray env xs
