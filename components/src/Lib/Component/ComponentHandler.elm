module Lib.Component.ComponentHandler exposing
    ( updateOnceComponents
    , updateOnceComponentByComponent
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

@docs updateOnceComponents
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
import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Dict
import Lib.Component.Base exposing (Component, ComponentTMsg(..), ComponentTarget(..), DefinedTypes(..))
import Lib.Tools.Array exposing (locate)
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionArray exposing (updateObjects)


{-| updateOnceComponents

Update all the components only once

-}
updateOnceComponents : Int -> Msg -> GlobalData -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateOnceComponents t msg gd xs =
    Array.foldl
        (\x ( acs, ct, mlgg ) ->
            let
                ( newx, newmsg, newgd ) =
                    x.update msg mlgg NullComponentMsg ( x.data, t )
            in
            ( Array.push { x | data = newx } acs, ct ++ newmsg, newgd )
        )
        ( Array.empty, [], gd )
        xs


{-| updateOnceComponentByComponent
Given one component, update it.
-}
updateOnceComponentByComponent : Msg -> ComponentTMsg -> GlobalData -> Int -> Component -> ( Component, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateOnceComponentByComponent msg ct gd t c =
    let
        ( newx, newmsg, newgd ) =
            c.update msg gd ct ( c.data, t )
    in
    ( { c | data = newx }, newmsg, newgd )


{-| updateOnceComponentByIdx

Given an index and an array of components, update that component.

-}
updateOnceComponentByIdx : Msg -> ComponentTMsg -> GlobalData -> Int -> Int -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateOnceComponentByIdx msg ct gd t n xs =
    case getComponent n xs of
        Just k ->
            let
                ( newx, newmsg, newgd ) =
                    k.update msg gd ct ( k.data, t )
            in
            ( Array.set n { k | data = newx } xs, newmsg, newgd )

        Nothing ->
            ( xs, [], gd )


{-| updateOnceComponentsByName

Update all components with the given name.

-}
updateOnceComponentsByName : Msg -> ComponentTMsg -> GlobalData -> Int -> String -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateOnceComponentsByName msg ct gd t s xs =
    let
        ns =
            getComponentIdxByName s xs
    in
    List.foldl
        (\n ( lastxs, lastmsg, lastgd ) ->
            case getComponent n lastxs of
                Just k ->
                    let
                        ( newx, newmsg, newgd ) =
                            k.update msg lastgd ct ( k.data, t )
                    in
                    ( Array.set n { k | data = newx } lastxs, newmsg ++ lastmsg, newgd )

                Nothing ->
                    ( lastxs, lastmsg, lastgd )
        )
        ( xs, [], gd )
        ns


{-| Update a component by its id (not index)
-}
updateOnceComponentById : Msg -> ComponentTMsg -> GlobalData -> Int -> Int -> Array Component -> ( Array Component, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateOnceComponentById msg ct gd t id xs =
    let
        n =
            getComponentIdxById id xs
    in
    case getComponent n xs of
        Just k ->
            let
                ( newx, newmsg, newgd ) =
                    k.update msg gd ct ( k.data, t )
            in
            ( Array.set n { k | data = newx } xs, newmsg, newgd )

        Nothing ->
            ( xs, [], gd )


{-| Generate the view of the components
-}
viewComponent : GlobalData -> Int -> Array Component -> Maybe Renderable
viewComponent vp t xs =
    let
        children =
            List.filterMap (\x -> x.view ( x.data, t ) vp) (Array.toList xs)
    in
    if List.isEmpty children then
        Nothing

    else
        Just (Canvas.group [] children)


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


type alias Env =
    { msg : Msg
    , globalData : GlobalData
    , t : Int
    }


update : Component -> Env -> ComponentTMsg -> ( Component, List ( ComponentTarget, ComponentTMsg ), Env )
update c env ct =
    let
        ( newx, newmsg, newgd ) =
            c.update env.msg env.globalData ct ( c.data, env.t )
    in
    ( { c | data = newx }, newmsg, { env | globalData = newgd } )


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


updateComponentsProto : Env -> ComponentTMsg -> Array Component -> ( Array Component, List ComponentTMsg, Env )
updateComponentsProto =
    updateObjects recBody


{-| Update all the components in an array and recursively update the components which have messenges sent.

Return a list of messages sent to the parentlayer.

-}
updateComponents : Msg -> GlobalData -> Int -> Array Component -> ( Array Component, List ComponentTMsg, GlobalData )
updateComponents msg gd t cs =
    let
        ( ac, ct, env ) =
            updateComponentsProto { msg = msg, globalData = gd, t = t } NullComponentMsg cs
    in
    ( ac, ct, env.globalData )
