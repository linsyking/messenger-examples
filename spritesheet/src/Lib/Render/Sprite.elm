module Lib.Render.Sprite exposing (renderSprite, renderSpriteWithRev)

{-|


# Sprite Rendering

@docs renderSprite, renderSpriteWithRev

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable, empty, texture)
import Canvas.Settings exposing (Setting)
import Canvas.Settings.Advanced exposing (scale, transform, translate)
import Canvas.Texture exposing (Texture, dimensions)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Resources.Base exposing (igetSprite)


{-| renderSprite

Render a single sprite.

-}
renderSprite : GlobalData -> List Setting -> ( Int, Int ) -> ( Int, Int ) -> String -> Renderable
renderSprite gd ls p size name =
    let
        dst =
            gd.sprites
    in
    case igetSprite name dst of
        Just t ->
            renderSprite_ gd ls p size t

        Nothing ->
            empty


renderSprite_ : GlobalData -> List Setting -> ( Int, Int ) -> ( Int, Int ) -> Texture -> Renderable
renderSprite_ gd ls p ( w, h ) t =
    let
        text_dim =
            dimensions t

        rw =
            lengthToReal gd w

        rh =
            lengthToReal gd h

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


{-| renderSpriteWithRev

Render a single sprite with (possible) reverse.

The first argument is the reverse flag. Sent true to make the sprite being rendered in reverse.

-}
renderSpriteWithRev : Bool -> GlobalData -> List Setting -> ( Int, Int ) -> ( Int, Int ) -> String -> Renderable
renderSpriteWithRev rev gd ls p size name =
    if not rev then
        renderSprite gd ls p size name

    else
        case igetSprite name gd.sprites of
            Just t ->
                renderSpriteWithRev_ gd ls p size t

            Nothing ->
                empty


renderSpriteWithRev_ : GlobalData -> List Setting -> ( Int, Int ) -> ( Int, Int ) -> Texture -> Renderable
renderSpriteWithRev_ gd ls p ( w, h ) t =
    let
        text_dim =
            dimensions t

        rw =
            lengthToReal gd w

        rh =
            lengthToReal gd h

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
