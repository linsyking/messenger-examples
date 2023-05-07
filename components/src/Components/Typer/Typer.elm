module Components.Typer.Typer exposing
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
import Canvas exposing (Renderable, empty)
import Char
import Dict
import Lib.Component.Base exposing (ComponentTMsg(..), ComponentTarget(..), Data, DefinedTypes(..))
import Lib.DefinedTypes.Parser exposing (dBoolGet, dBoolSet, dComponentTargetGet, dIntGet, dStringGet, dStringSet)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Int -> Int -> ComponentTMsg -> Data
initModel _ id msg =
    let
        updater =
            case msg of
                ComponentIntMsg i ->
                    ComponentByID i

                _ ->
                    ComponentParentLayer
    in
    Dict.fromList
        [ ( "id", CDInt id )
        , ( "status", CDBool False ) -- Write to text
        , ( "isCaps", CDBool False )
        , ( "isShift", CDBool False )
        , ( "updater", CDComponentTarget updater )
        , ( "text", CDString "" )
        ]


{-| updateModel

Add your component logic here.

-}
updateModel : Msg -> GlobalData -> ComponentTMsg -> ( Data, Int ) -> ( Data, List ( ComponentTarget, ComponentTMsg ), GlobalData )
updateModel msg gd ctmsg ( d, _ ) =
    let
        updater =
            dComponentTargetGet d "updater"

        normalUpdate =
            if dBoolGet d "status" then
                -- Listen to keypresses
                let
                    text =
                        dStringGet d "text"

                    transform =
                        transformInt d

                    self =
                        ComponentByID (dIntGet d "id")
                in
                case msg of
                    KeyDown 16 ->
                        -- Shift
                        ( d |> dBoolSet "isShift" True, [], gd )

                    KeyUp 16 ->
                        -- Shift
                        ( d |> dBoolSet "isShift" False, [], gd )

                    KeyDown 8 ->
                        -- Backspace
                        let
                            newText =
                                String.dropRight 1 text
                        in
                        ( d |> dStringSet "text" newText, [ ( updater, ComponentNamedMsg self (ComponentStringMsg newText) ) ], gd )

                    KeyDown 20 ->
                        -- Caps lock
                        ( d |> dBoolSet "isCaps" (not (dBoolGet d "isCaps")), [], gd )

                    KeyDown x ->
                        if isCharacter x then
                            let
                                newText =
                                    String.append text (String.fromChar (transform x))
                            in
                            ( d |> dStringSet "text" newText, [ ( updater, ComponentNamedMsg self (ComponentStringMsg newText) ) ], gd )

                        else
                            ( d, [ ( updater, ComponentNamedMsg self (ComponentIntMsg x) ) ], gd )

                    _ ->
                        ( d, [], gd )

            else
                -- Inactive
                ( d, [], gd )
    in
    case ctmsg of
        ComponentNamedMsg target cmsg ->
            if target == updater then
                case cmsg of
                    ComponentBoolMsg x ->
                        ( d |> dBoolSet "status" x, [], gd )

                    ComponentStringMsg x ->
                        ( d |> dStringSet "text" x, [], gd )

                    _ ->
                        normalUpdate

            else
                -- Not the updater
                normalUpdate

        _ ->
            normalUpdate


isCharacter : Int -> Bool
isCharacter x =
    if x >= 65 && x <= 90 then
        -- a-z
        True

    else if x >= 48 && x <= 57 then
        -- 0-9
        True

    else if x >= 186 && x <= 192 then
        -- ;-`
        True

    else if x >= 219 && x <= 222 then
        -- [-'
        True

    else if x == 32 then
        -- Space
        True

    else
        False


transformInt : Data -> Int -> Char
transformInt d c =
    let
        shift =
            dBoolGet d "isShift"

        caps =
            dBoolGet d "isCaps"

        char =
            Char.fromCode c
    in
    if xor shift caps then
        -- Not the same
        Char.toUpper char

    else
        Char.toLower char


{-| viewModel

Change this to your own component view function.

-}
viewModel : ( Data, Int ) -> GlobalData -> Renderable
viewModel _ _ =
    empty
