module Lib.Render.Render exposing
    ( renderSprite
    , renderSpriteWithRev
    , renderText, renderTextWithColor, renderTextWithColorAlign
    , renderSpriteRawPos
    )

{-| This is the doc for this module

@docs renderSprite
@docs renderSpriteWithRev
@docs renderText, renderTextWithColor, renderTextWithColorAlign
@docs renderSpriteRawPos

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable, text, texture)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (scale, transform, translate)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Canvas.Texture exposing (dimensions)
import Color exposing (Color)
import Lib.Coordinate.Coordinates exposing (heightToReal, posToReal, widthToReal)
import Lib.Resources.Base exposing (igetSprite)


{-| renderSprite

Render a single sprite.

-}
renderSprite : GlobalData -> List Setting -> ( Int, Int ) -> ( Int, Int ) -> String -> Renderable
renderSprite gd ls p ( w, h ) name =
    let
        dst =
            gd.sprites
    in
    case igetSprite name dst of
        Just t ->
            let
                text_dim =
                    dimensions t

                rw =
                    widthToReal gd w

                rh =
                    heightToReal gd h

                text_width =
                    text_dim.width

                text_height =
                    text_dim.height

                width_s =
                    rw / text_width

                height_s =
                    rh / text_height

                ( newx, newy ) =
                    posToReal gd p
            in
            if w > 0 && h > 0 then
                texture
                    (transform
                        [ translate newx newy
                        , scale width_s height_s
                        ]
                        :: ls
                    )
                    ( 0, 0 )
                    t

            else if w > 0 && h <= 0 then
                texture
                    (transform
                        [ translate newx newy
                        , scale width_s width_s
                        ]
                        :: ls
                    )
                    ( 0, 0 )
                    t

            else if w <= 0 && h > 0 then
                texture
                    (transform
                        [ translate newx newy
                        , scale height_s height_s
                        ]
                        :: ls
                    )
                    ( 0, 0 )
                    t

            else
                -- All <= 0
                texture
                    ls
                    ( newx, newy )
                    t

        Nothing ->
            text [] (posToReal gd p) ""


{-| renderSpriteRawPos

The positions are raw. (not converted to real)

-}
renderSpriteRawPos : GlobalData -> List Setting -> ( Float, Float ) -> ( Int, Int ) -> String -> Renderable
renderSpriteRawPos gd ls p ( w, h ) name =
    let
        dst =
            gd.sprites
    in
    case igetSprite name dst of
        Just t ->
            let
                text_dim =
                    dimensions t

                rw =
                    widthToReal gd w

                rh =
                    heightToReal gd h

                text_width =
                    text_dim.width

                text_height =
                    text_dim.height

                width_s =
                    rw / text_width

                height_s =
                    rh / text_height

                ( newx, newy ) =
                    p
            in
            if w > 0 && h > 0 then
                texture
                    (transform
                        [ translate newx newy
                        , scale width_s height_s
                        ]
                        :: ls
                    )
                    ( 0, 0 )
                    t

            else if w > 0 && h <= 0 then
                texture
                    (transform
                        [ translate newx newy
                        , scale width_s width_s
                        ]
                        :: ls
                    )
                    ( 0, 0 )
                    t

            else if w <= 0 && h > 0 then
                texture
                    (transform
                        [ translate newx newy
                        , scale height_s height_s
                        ]
                        :: ls
                    )
                    ( 0, 0 )
                    t

            else
                -- All <= 0
                texture
                    ls
                    ( newx, newy )
                    t

        Nothing ->
            text [] p ""


{-| renderSpriteWithRev

Render a single sprite with (possible) reverse.

The first argument is the reverse flag. Sent true to make the sprite being rendered in reverse.

-}
renderSpriteWithRev : Bool -> GlobalData -> List Setting -> ( Int, Int ) -> ( Int, Int ) -> String -> Renderable
renderSpriteWithRev rev gd ls p ( w, h ) name =
    if not rev then
        renderSprite gd ls p ( w, h ) name

    else
        let
            dst =
                gd.sprites
        in
        case igetSprite name dst of
            Just t ->
                let
                    text_dim =
                        dimensions t

                    rw =
                        widthToReal gd w

                    rh =
                        heightToReal gd h

                    text_width =
                        text_dim.width

                    text_height =
                        text_dim.height

                    width_s =
                        rw / text_width

                    height_s =
                        rh / text_height

                    ( newx, newy ) =
                        posToReal gd p
                in
                if w > 0 && h > 0 then
                    texture
                        (transform
                            [ translate newx newy
                            , scale -width_s width_s
                            , translate -text_width 0
                            ]
                            :: ls
                        )
                        ( 0, 0 )
                        t

                else if w > 0 && h <= 0 then
                    texture
                        (transform
                            [ translate newx newy
                            , scale -width_s width_s
                            , translate -text_width 0
                            ]
                            :: ls
                        )
                        ( 0, 0 )
                        t

                else if w <= 0 && h > 0 then
                    texture
                        (transform
                            [ translate newx newy
                            , scale -height_s height_s
                            , translate -text_width 0
                            ]
                            :: ls
                        )
                        ( 0, 0 )
                        t

                else
                    -- All <= 0
                    texture
                        ls
                        ( newx, newy )
                        t

            Nothing ->
                text [] (posToReal gd p) "Wrong Sprite"


{-| renderText

Render texts.

-}
renderText : GlobalData -> Int -> String -> String -> ( Int, Int ) -> Renderable
renderText gd size s ft ( x, y ) =
    let
        rx =
            heightToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align Start
        , fill Color.black
        ]
        ( dsx, dsy + rx - 1 )
        s


{-| renderTextWithColor
Render colorful texts.
-}
renderTextWithColor : GlobalData -> Int -> String -> String -> Color -> ( Int, Int ) -> Renderable
renderTextWithColor gd size s ft col ( x, y ) =
    let
        rx =
            heightToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align Start
        , fill col
        ]
        ( dsx, dsy + rx - 1 )
        s


{-| renderTextWithColorAlign
Render texts with color and align.
-}
renderTextWithColorAlign : GlobalData -> Int -> String -> String -> Color -> TextAlign -> ( Int, Int ) -> Renderable
renderTextWithColorAlign gd size s ft col al ( x, y ) =
    let
        rx =
            heightToReal gd size

        ( dsx, dsy ) =
            posToReal gd ( x, y )
    in
    text
        [ font { size = floor rx, family = ft }
        , align al
        , fill col
        ]
        ( dsx, dsy + rx - 1 )
        s
