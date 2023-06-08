module Lib.Coordinate.Coordinates exposing
    ( fixedPosToReal
    , posToReal, posToVirtual
    , lengthToReal
    , fromRealLength
    , maxHandW
    , getStartPoint
    , judgeMouseRect
    , fromMouseToVirtual
    )

{-|


# Coordinate

This module deals with the coordinate transformation.

This module is very important because it can calculate the correct position of the point you want to draw.

@docs fixedPosToReal
@docs posToReal, posToVirtual
@docs lengthToReal
@docs fromRealLength
@docs maxHandW
@docs getStartPoint
@docs judgeMouseRect
@docs fromMouseToVirtual

-}

import Base exposing (GlobalData)
import MainConfig exposing (plHeight, plWidth)



{- The scale is by default 16:9 -}


plScale : Float
plScale =
    toFloat plWidth / toFloat plHeight



--- Transform Coordinates


floatpairadd : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
floatpairadd ( x, y ) ( z, w ) =
    ( x + z, y + w )


{-| fixedPosToReal

Same as posToReal, but add the initial position of canvas.

-}
fixedPosToReal : GlobalData -> ( Int, Int ) -> ( Float, Float )
fixedPosToReal gd ( x, y ) =
    floatpairadd (posToReal gd ( x, y )) ( gd.startLeft, gd.startTop )


{-| posToReal

Transform from the virtual coordinate system to the real pixel system.

-}
posToReal : GlobalData -> ( Int, Int ) -> ( Float, Float )
posToReal gd ( x, y ) =
    let
        realWidth =
            gd.realWidth

        realHeight =
            gd.realHeight
    in
    ( toFloat realWidth * (toFloat x / toFloat plWidth), toFloat realHeight * (toFloat y / toFloat plHeight) )


{-| Inverse of posToReal.
-}
posToVirtual : GlobalData -> ( Float, Float ) -> ( Int, Int )
posToVirtual gd ( x, y ) =
    let
        realWidth =
            gd.realWidth

        realHeight =
            gd.realHeight
    in
    ( floor (toFloat plWidth * (x / toFloat realWidth)), floor (toFloat plHeight * (y / toFloat realHeight)) )


{-| widthToReal
Use this if you want to draw something based on the length.
-}
lengthToReal : GlobalData -> Int -> Float
lengthToReal gd x =
    let
        realWidth =
            gd.realWidth
    in
    toFloat realWidth * (toFloat x / toFloat plWidth)


{-| The inverse function of widthToReal.
-}
fromRealLength : GlobalData -> Float -> Int
fromRealLength gd x =
    let
        realWidth =
            gd.realWidth
    in
    floor (toFloat plWidth * (x / toFloat realWidth))


{-| maxHandW
-}
maxHandW : ( Int, Int ) -> ( Int, Int )
maxHandW ( w, h ) =
    if toFloat w / toFloat h > plScale then
        ( floor (toFloat h * plScale), h )

    else
        ( w, floor (toFloat w / plScale) )


{-| getStartPoint
-}
getStartPoint : ( Int, Int ) -> ( Float, Float )
getStartPoint ( w, h ) =
    let
        fw =
            toFloat h * plScale

        fh =
            toFloat w / plScale
    in
    if toFloat w / toFloat h > plScale then
        ( (toFloat w - fw) / 2, 0 )

    else
        ( 0, (toFloat h - fh) / 2 )


{-| judgeMouseRect
Judge whether the mouse position is in the rectangle.
-}
judgeMouseRect : ( Int, Int ) -> ( Int, Int ) -> ( Int, Int ) -> Bool
judgeMouseRect ( mx, my ) ( x, y ) ( w, h ) =
    if x <= mx && mx <= x + w && y <= my && my <= y + h then
        True

    else
        False


{-| fromMouseToVirtual
-}
fromMouseToVirtual : GlobalData -> ( Float, Float ) -> ( Int, Int )
fromMouseToVirtual gd ( px, py ) =
    posToVirtual gd ( px - gd.startLeft, py - gd.startTop )
