module Lib.Render.Shape exposing (circle, rect)

{-|


# Shape Rendering

@docs circle, rect

-}

import Base exposing (GlobalData)
import Canvas
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)


{-| Draw circle based on global dataa.
-}
circle : GlobalData -> ( Int, Int ) -> Int -> Canvas.Shape
circle gd pos r =
    Canvas.circle (posToReal gd pos) (lengthToReal gd r)


{-| Draw rectangle based on global dataa.
-}
rect : GlobalData -> ( Int, Int ) -> ( Int, Int ) -> Canvas.Shape
rect gd pos ( w, h ) =
    Canvas.rect (posToReal gd pos) (lengthToReal gd w) (lengthToReal gd h)
