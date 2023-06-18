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
    plWidth / plHeight



--- Transform Coordinates


floatpairadd : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
floatpairadd ( x, y ) ( z, w ) =
    ( x + z, y + w )


{-| fixedPosToReal

Same as posToReal, but add the initial position of canvas.

-}
fixedPosToReal : GlobalData -> ( Float, Float ) -> ( Float, Float )
fixedPosToReal gd ( x, y ) =
    floatpairadd (posToReal gd ( x, y )) ( gd.internalData.startLeft, gd.internalData.startTop )


{-| posToReal

Transform from the virtual coordinate system to the real pixel system.

-}
posToReal : GlobalData -> ( Float, Float ) -> ( Float, Float )
posToReal gd ( x, y ) =
    let
        realWidth =
            gd.internalData.realWidth

        realHeight =
            gd.internalData.realHeight
    in
    ( realWidth * (x / plWidth), realHeight * (y / plHeight) )


{-| Inverse of posToReal.
-}
posToVirtual : GlobalData -> ( Float, Float ) -> ( Float, Float )
posToVirtual gd ( x, y ) =
    let
        realWidth =
            gd.internalData.realWidth

        realHeight =
            gd.internalData.realHeight
    in
    ( plWidth * (x / realWidth), plHeight * (y / realHeight) )


{-| widthToReal
Use this if you want to draw something based on the length.
-}
lengthToReal : GlobalData -> Float -> Float
lengthToReal gd x =
    let
        realWidth =
            gd.internalData.realWidth
    in
    realWidth * (x / plWidth)


{-| The inverse function of widthToReal.
-}
fromRealLength : GlobalData -> Float -> Float
fromRealLength gd x =
    let
        realWidth =
            gd.internalData.realWidth
    in
    plWidth * (x / realWidth)


{-| maxHandW
-}
maxHandW : ( Float, Float ) -> ( Float, Float )
maxHandW ( w, h ) =
    if w / h > plScale then
        ( h * plScale, h )

    else
        ( w, w / plScale )


{-| getStartPoint
-}
getStartPoint : ( Float, Float ) -> ( Float, Float )
getStartPoint ( w, h ) =
    let
        fw =
            h * plScale

        fh =
            w / plScale
    in
    if w / h > plScale then
        ( (w - fw) / 2, 0 )

    else
        ( 0, (h - fh) / 2 )


{-| judgeMouseRect
Judge whether the mouse position is in the rectangle.
-}
judgeMouseRect : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Bool
judgeMouseRect ( mx, my ) ( x, y ) ( w, h ) =
    if x <= mx && mx <= x + w && y <= my && my <= y + h then
        True

    else
        False


{-| fromMouseToVirtual
-}
fromMouseToVirtual : GlobalData -> ( Float, Float ) -> ( Float, Float )
fromMouseToVirtual gd ( px, py ) =
    posToVirtual gd ( px - gd.internalData.startLeft, py - gd.internalData.startTop )
