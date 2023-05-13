module Components.Console.Console exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Component

This is a component model module. It should define init, update and view model.

@docs initModel
@docs updateModel
@docs viewModel

-}

import Base exposing (Msg(..))
import Canvas exposing (Renderable, empty, group, shapes)
import Canvas.Settings.Advanced exposing (alpha)
import Dict
import Lib.Component.Base exposing (ComponentInitData(..), ComponentMsg(..), ComponentTarget(..), Data, DefinedTypes(..))
import Lib.DefinedTypes.Parser exposing (dBoolGet, dBoolSet, dComponentTargetGet, dIntGet, dStringGet, dStringSet)
import Lib.Env.Env exposing (Env)
import Lib.Render.Render exposing (renderText)
import Lib.Render.Shape exposing (rect)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> ComponentInitData -> Data
initModel _ i =
    case i of
        ComponentID id (ComponentIntData x) ->
            Dict.fromList
                [ ( "id", CDInt id )
                , ( "text", CDString "" )
                , ( "typer", CDComponentTarget (ComponentByID x) )
                , ( "state", CDBool False )
                ]

        _ ->
            Dict.fromList []


{-| updateModel

Add your component logic here.

-}
updateModel : Env -> ComponentMsg -> Data -> ( Data, List ( ComponentTarget, ComponentMsg ), Env )
updateModel env ctmsg d =
    let
        typer =
            dComponentTargetGet d "typer"

        self =
            ComponentByID (dIntGet d "id")
    in
    case env.msg of
        KeyDown 13 ->
            -- Enter
            if dBoolGet d "state" then
                ( d |> dStringSet "text" "" |> dBoolSet "state" False
                , [ ( ComponentParentLayer, ComponentStringMsg (dStringGet d "text") )
                  , ( typer, ComponentNamedMsg self (ComponentBoolMsg False) )
                  , ( typer, ComponentNamedMsg self (ComponentStringMsg "") )
                  ]
                , env
                )

            else
                ( d, [], env )

        KeyDown 17 ->
            -- ctrl
            ( d |> dBoolSet "state" True, [ ( typer, ComponentNamedMsg self (ComponentBoolMsg True) ) ], env )

        _ ->
            case ctmsg of
                ComponentNamedMsg target x ->
                    if target == typer then
                        case x of
                            ComponentStringMsg text ->
                                ( d |> dStringSet "text" text, [], env )

                            _ ->
                                ( d, [], env )

                    else
                        ( d, [], env )

                _ ->
                    ( d, [], env )


{-| viewModel

Change this to your own component view function.

If there is no view function, return Nothing.

-}
viewModel : Env -> Data -> Renderable
viewModel env d =
    let
        command =
            dStringGet d "text"

        gd =
            env.globalData
    in
    if dBoolGet d "state" then
        group []
            [ shapes [ alpha 0.1 ] [ rect gd ( 20, 970 ) ( 1850, 40 ) ]
            , renderText gd 30 ("> " ++ command ++ "_") "sans-seif" ( 30, 975 )
            ]

    else
        empty
