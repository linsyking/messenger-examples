module Components.Button.Button exposing
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
import Canvas exposing (Renderable, group, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..))
import Components.Button.Base exposing (ButtonInit)
import Dict
import Lib.Component.Base exposing (ComponentInitData(..), ComponentMsg(..), ComponentTarget(..), Data, DefinedTypes(..))
import Lib.Coordinate.Coordinates exposing (judgeMouse)
import Lib.DefinedTypes.Parser exposing (dColorGet, dIntGet, dStringGet, dStringSet)
import Lib.Env.Env exposing (Env)
import Lib.Render.Render exposing (renderTextWithColorAlign)
import Lib.Render.Shape exposing (rect)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> ComponentInitData -> Data
initModel _ i =
    case i of
        ComponentID id (ComponentButtonMsg b) ->
            Dict.fromList
                [ ( "id", CDInt id )
                , ( "label", CDString b.text )
                , ( "color", CDColor b.background )
                , ( "textcolor", CDColor b.textColor )
                , ( "x", CDInt <| Tuple.first b.position )
                , ( "y", CDInt <| Tuple.second b.position )
                , ( "w", CDInt <| Tuple.first b.size )
                , ( "h", CDInt <| Tuple.second b.size )
                ]

        _ ->
            Dict.fromList []


getButton : Data -> ButtonInit
getButton d =
    { text = dStringGet d "label"
    , background = dColorGet d "color"
    , position = ( dIntGet d "x", dIntGet d "y" )
    , size = ( dIntGet d "w", dIntGet d "h" )
    , textColor = dColorGet d "textcolor"
    }


{-| updateModel

Add your component logic here.

-}
updateModel : Env -> ComponentMsg -> Data -> ( Data, List ( ComponentTarget, ComponentMsg ), Env )
updateModel env ctmsg d =
    let
        button =
            getButton d

        newData =
            case ctmsg of
                ComponentStringMsg x ->
                    d |> dStringSet "label" x

                _ ->
                    d
    in
    case env.msg of
        MouseDown _ pos ->
            if judgeMouse env.globalData pos button.position button.size then
                ( newData, [ ( ComponentParentLayer, ComponentIntMsg (dIntGet d "id") ) ], env )

            else
                ( newData, [], env )

        _ ->
            ( newData, [], env )


{-| viewModel

Change this to your own component view function.

If there is no view function, return Nothing.

-}
viewModel : Env -> Data -> Renderable
viewModel env d =
    let
        button =
            getButton d

        gd =
            env.globalData

        ( x, y ) =
            button.position

        ( w, h ) =
            button.size
    in
    group []
        [ shapes [ fill button.background ]
            [ rect gd button.position button.size
            ]
        , renderTextWithColorAlign gd 20 button.text "Helvetica" button.textColor Center ( x + w // 2, y + h // 2 - 11 )
        ]
