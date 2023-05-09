module Components.Rect.Rect exposing
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
import Canvas exposing (Renderable, rect, shapes)
import Canvas.Settings exposing (fill)
import Color
import Dict
import Lib.Component.Base exposing (ComponentInitData(..), ComponentTMsg(..), ComponentTarget(..), Data, DefinedTypes(..), Env)
import Lib.Coordinate.Coordinates exposing (heightToReal, judgeMouse, posToReal, widthToReal)
import Lib.DefinedTypes.Parser exposing (dColorGet, dColorSet, dIntGet)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> ComponentInitData -> Data
initModel _ i =
    case i of
        ComponentID id (RectInitData x y w h c) ->
            Dict.fromList
                [ ( "id", CDInt id )
                , ( "x", CDInt x )
                , ( "y", CDInt y )
                , ( "width", CDInt w )
                , ( "height", CDInt h )
                , ( "color", CDColor c )
                ]

        _ ->
            Dict.fromList []


{-| updateModel

Add your component logic here.

-}
updateModel : Env -> ComponentTMsg -> Data -> ( Data, List ( ComponentTarget, ComponentTMsg ), Env )
updateModel env _ d =
    let
        x =
            dIntGet d "x"

        y =
            dIntGet d "y"

        w =
            dIntGet d "width"

        h =
            dIntGet d "height"
    in
    case env.msg of
        MouseDown 0 pos ->
            if judgeMouse env.globalData pos ( x, y ) ( w, h ) then
                ( d |> dColorSet "color" Color.black, [], { env | msg = UnknownMsg } )

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
        x =
            dIntGet d "x"

        y =
            dIntGet d "y"

        w =
            dIntGet d "width"

        h =
            dIntGet d "height"

        color =
            dColorGet d "color"

        gd =
            env.globalData
    in
    shapes
        [ fill color ]
        [ rect (posToReal gd ( x, y )) (widthToReal gd w) (heightToReal gd h)
        ]
