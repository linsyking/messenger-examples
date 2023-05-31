module Lib.Render.Text exposing
    ( renderText
    , renderTextWithColor, renderTextWithColorCenter, renderTextWithColorAlignBaseline
    , renderTextWithSettings
    )

{-|


# Text Rendering

@docs renderText
@docs renderTextWithColor, renderTextWithColorCenter, renderTextWithColorAlignBaseline
@docs renderTextWithSettings

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Text exposing (TextAlign(..), TextBaseLine(..), align, baseLine, font)
import Color exposing (Color)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)


{-| Render Text. Black color, left top align.
-}
renderText : GlobalData -> Int -> String -> String -> ( Int, Int ) -> Renderable
renderText gd size s ft ( x, y ) =
    let
        rx =
            lengthToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align Start
        , fill Color.black
        , baseLine Top
        ]
        ( dsx, dsy )
        s


{-| renderTextWithColor
Render colorful texts.
-}
renderTextWithColor : GlobalData -> Int -> String -> String -> Color -> ( Int, Int ) -> Renderable
renderTextWithColor gd size s ft col ( x, y ) =
    let
        rx =
            lengthToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align Start
        , fill col
        , baseLine Top
        ]
        ( dsx, dsy )
        s


{-| renderTextWithColorAlign
Render texts with color and align.
-}
renderTextWithColorCenter : GlobalData -> Int -> String -> String -> Color -> ( Int, Int ) -> Renderable
renderTextWithColorCenter gd size s ft col ( x, y ) =
    let
        rx =
            lengthToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align Center
        , fill col
        , baseLine Middle
        ]
        ( dsx, dsy )
        s


{-| Render texts with color, align and baseline.
-}
renderTextWithColorAlignBaseline : GlobalData -> Int -> String -> String -> Color -> TextAlign -> TextBaseLine -> ( Int, Int ) -> Renderable
renderTextWithColorAlignBaseline gd size s ft col al bl ( x, y ) =
    let
        rx =
            lengthToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align al
        , fill col
        , baseLine bl
        ]
        ( dsx, dsy )
        s


{-| Use customized settings to render texts.
-}
renderTextWithSettings : GlobalData -> Int -> String -> String -> List Setting -> ( Int, Int ) -> Renderable
renderTextWithSettings gd size str ft settings ( x, y ) =
    let
        rx =
            lengthToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        (font { size = floor rx, family = ft } :: settings)
        ( dsx, dsy )
        str
