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

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Renderable, empty, group, rect, shapes)
import Canvas.Settings.Advanced exposing (alpha)
import Dict
import Lib.Component.Base exposing (ComponentTMsg(..), ComponentTarget(..), Data, DefinedTypes(..))
import Lib.Coordinate.Coordinates exposing (heightToReal, posToReal, widthToReal)
import Lib.DefinedTypes.Parser exposing (dBoolGet, dBoolSet, dComponentTargetGet, dIntGet, dStringGet, dStringSet)
import Lib.Render.Render exposing (renderText)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Int -> Int -> ComponentTMsg -> Data
initModel _ id tmsg =
    let
        typer =
            case tmsg of
                ComponentIntMsg i ->
                    ComponentByID i

                _ ->
                    ComponentParentLayer
    in
    Dict.fromList
        [ ( "id", CDInt id )
        , ( "text", CDString "" )
        , ( "typer", CDComponentTarget typer )
        , ( "state", CDBool False )
        ]


{-| updateModel

Add your component logic here.

-}
updateModel : Msg -> GlobalData -> ComponentTMsg -> ( Data, Int ) -> ( Data, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateModel msg gd tmsg ( d, _ ) =
    let
        typer =
            dComponentTargetGet d "typer"

        self =
            ComponentByID (dIntGet d "id")
    in
    case msg of
        KeyDown 13 ->
            -- Enter
            ( d |> dStringSet "text" "" |> dBoolSet "state" False
            , [ ( ComponentParentLayer, ComponentStringMsg (dStringGet d "text") )
              , ( typer, ComponentNamedMsg self (ComponentBoolMsg False) )
              , ( typer, ComponentNamedMsg self (ComponentStringMsg "") )
              ]
            , gd
            )

        KeyDown 17 ->
            -- ctrl
            ( d |> dBoolSet "state" True, [ ( typer, ComponentNamedMsg self (ComponentBoolMsg True) ) ], gd )

        _ ->
            case tmsg of
                ComponentNamedMsg target x ->
                    if target == typer then
                        case x of
                            ComponentStringMsg text ->
                                ( d |> dStringSet "text" text, [], gd )

                            _ ->
                                ( d, [], gd )

                    else
                        ( d, [], gd )

                _ ->
                    ( d, [], gd )


{-| viewModel

Change this to your own component view function.

If there is no view function, remove this and change the view function in export module to nothing.

-}
viewModel : ( Data, Int ) -> GlobalData -> Renderable
viewModel ( d, _ ) gd =
    let
        command =
            dStringGet d "text"
    in
    if dBoolGet d "state" then
        group []
            [ shapes [ alpha 0.1 ] [ rect (posToReal gd ( 20, 970 )) (widthToReal gd 1850) (heightToReal gd 40) ]
            , renderText gd 30 ("> " ++ command ++ "_") "sans-seif" ( 30, 975 )
            ]

    else
        empty
