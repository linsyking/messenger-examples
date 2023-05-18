module MainConfig exposing
    ( initScene
    , timeInterval
    , background, plHeight, plWidth
    )

{-| This module is used for configuring the parameters of the game framework.

@docs initScene
@docs timeInterval

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable)
import Canvas.Settings exposing (fill)
import Color


{-| Start scene of the game
-}
initScene : String
initScene =
    "Home"


{-| Time Interval in milliseconds.
Value 16 is approximately 60 fps.
-}
timeInterval : Float
timeInterval =
    15


{-| The height of the game screen in pixel.

You can change this value. However, the position you used in your views are fixed number which will not be scaled automatically.
So please determine these two values before you start to write your game.

The default scale is 16x9.

-}
plHeight : Int
plHeight =
    600


{-| The width of the game screen in pixel.
-}
plWidth : Int
plWidth =
    600


{-| The background of the game.

This renderable will be rendered below all other renderables.

Default is a white rectangle. You can change the background color to other color when debugging.

-}
background : GlobalData -> Renderable
background gd =
    Canvas.shapes [ fill Color.white ] [ Canvas.rect ( 0, 0 ) (toFloat gd.realWidth) (toFloat gd.realHeight) ]
