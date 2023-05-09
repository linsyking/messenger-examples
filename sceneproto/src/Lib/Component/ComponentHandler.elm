module Lib.Component.ComponentHandler exposing
    ( updateOnceComponentByComponent
    , updateOnceComponentByIdx
    , updateOnceComponentsByName
    , updateOnceComponentById
    , viewComponent
    , getComponent
    , getComponentIdxByName
    , getComponentIdxById
    , updateComponents
    )

{-| ComponentHandler deals with components

You can use these functions to handle components.

The mosy commonly used one is the `updateComponents` function, which will update all components recursively.

@docs updateOnceComponentByComponent
@docs updateOnceComponentByIdx
@docs updateOnceComponentsByName
@docs updateOnceComponentById
@docs viewComponent
@docs getComponent
@docs getComponentIdxByName
@docs getComponentIdxById
@docs updateComponents

-}

import Array exposing (Array)
import Canvas exposing (Renderable)
import Dict
import Lib.Component.Base exposing (Component, ComponentTMsg(..), ComponentTarget(..), DefinedTypes(..), Env)
import Lib.Tools.Array exposing (locate)
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionArray exposing (updateObjects)


{-| updateOnceComponentByComponent
Given one component, update it.
-}
updateOnceComponentByComponent : Env -> ComponentTMsg -> Component -> ( Component, List ( ComponentTarget, ComponentTMsg ), Env )
updateOnceComponentByComponent env ct c =
    let
        ( newx, newmsg, newenv ) =
            c.update env ct c.data
    in
    ( { c | data = newx }, newmsg, newenv )


{-| updateOnceComponentByIdx

Given an index and an array of components, update that component.

-}
updateOnceComponentByIdx : Env -> ComponentTMsg -> Int -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), Env )
updateOnceComponentByIdx env ct n xs =
    case getComponent n xs of
        Just k ->
            let
                ( newx, newmsg, newenv ) =
                    k.update env ct k.data
            in
            ( Array.set n { k | data = newx } xs, newmsg, newenv )

        Nothing ->
            ( xs, [], env )


{-| updateOnceComponentsByName

Update all components with the given name.

-}
updateOnceComponentsByName : Env -> ComponentTMsg -> String -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), Env )
updateOnceComponentsByName env ct s xs =
    let
        ns =
            getComponentIdxByName s xs
    in
    List.foldl
        (\n ( lastxs, lastmsg, lastenv ) ->
            case getComponent n lastxs of
                Just k ->
                    let
                        ( newx, newmsg, newenv ) =
                            k.update env ct k.data
                    in
                    ( Array.set n { k | data = newx } lastxs, newmsg ++ lastmsg, newenv )

                Nothing ->
                    ( lastxs, lastmsg, lastenv )
        )
        ( xs, [], env )
        ns


{-| Update a component by its id (not index)
-}
updateOnceComponentById : Env -> ComponentTMsg -> Int -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), Env )
updateOnceComponentById env ct id xs =
    let
        n =
            getComponentIdxById id xs
    in
    case getComponent n xs of
        Just k ->
            let
                ( newx, newmsg, newenv ) =
                    k.update env ct k.data
            in
            ( Array.set n { k | data = newx } xs, newmsg, newenv )

        Nothing ->
            ( xs, [], env )


{-| Generate the view of the components
-}
viewComponent : Env -> Array Component -> Renderable
viewComponent env xs =
    Canvas.group [] (Array.toList (Array.map (\x -> x.view env x.data) xs))


{-| Get the nth component in an array
-}
getComponent : Int -> Array Component -> Maybe Component
getComponent n xs =
    Array.get n xs


{-| Get the component index by its name
-}
getComponentIdxByName : String -> Array Component -> List Int
getComponentIdxByName s xs =
    locate (\x -> x.name == s) xs


{-| Get the index of a component by its id
-}
getComponentIdxById : Int -> Array Component -> Int
getComponentIdxById id xs =
    Maybe.withDefault -1 (List.head (locate (\x -> Dict.get "id" x.data == Just (CDInt id)) xs))



-- Below are using the Recursion algorithm to get the update function


update : Component -> Env -> ComponentTMsg -> ( Component, List ( ComponentTarget, ComponentTMsg ), Env )
update c env ct =
    let
        ( newx, newmsg, newenv ) =
            c.update env ct c.data
    in
    ( { c | data = newx }, newmsg, newenv )


match : Component -> ComponentTarget -> Bool
match c ct =
    case ct of
        ComponentParentLayer ->
            False

        ComponentByID x ->
            Dict.get "id" c.data == Just (CDInt x)

        ComponentByName x ->
            c.name == x


super : ComponentTarget -> Bool
super ct =
    case ct of
        ComponentParentLayer ->
            True

        _ ->
            False


recBody : RecBody Component ComponentTMsg Env ComponentTarget
recBody =
    { update = update
    , match = match
    , super = super
    }


{-| Update all the components in an array and recursively update the components which have messenges sent.

Return a list of messages sent to the parentlayer.

-}
updateComponents : Env -> ComponentTMsg -> Array Component -> ( Array Component, List ComponentTMsg, Env )
updateComponents =
    updateObjects recBody
