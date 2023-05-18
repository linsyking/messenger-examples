module Lib.Coordinate.HTML exposing (genAttribute)

import Base exposing (GlobalData)
import Html exposing (Attribute)
import Html.Attributes exposing (style)
import Lib.Coordinate.Coordinates exposing (fixedPosToReal, heightToReal, widthToReal)


genAttribute : GlobalData -> ( Int, Int ) -> ( Int, Int ) -> List (Attribute msg)
genAttribute gd ( x, y ) ( w, h ) =
    let
        ( rx, ry ) =
            fixedPosToReal gd ( x, y )

        ( rw, rh ) =
            ( widthToReal gd w, heightToReal gd h )
    in
    [ style "position" "fixed"
    , style "left" (String.fromFloat rx ++ "px")
    , style "top" (String.fromFloat ry ++ "px")
    , style "width" (String.fromFloat rw ++ "px")
    , style "height" (String.fromFloat rh ++ "px")
    ]
