module MainConfig exposing
    ( initScene, initSceneSettings
    , timeInterval
    , background, plHeight, plWidth
    , debug
    )

{-| MainConfig

This module is used for configuring the parameters of the game framework.

@docs initScene, initSceneSettings
@docs timeInterval
@docs background, plHeight, plWidth
@docs debug

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable)
import Lib.Scene.Base exposing (SceneInitData(..))


{-| Start scene of the game
-}
initScene : String
initScene =
    "Home"


{-| Initial scene settings
-}
initSceneSettings : SceneInitData
initSceneSettings =
    NullSceneInitData


{-| Time Interval in milliseconds.
Value 16 is approximately 60 fps.
-}
timeInterval : Float
timeInterval =
    16


{-| The height of the game screen in pixel.

You can change this value. However, the position you used in your views are fixed number which will not be scaled automatically.
So please determine these two values before you start to write your game.

The default scale is 16x9.

-}
plHeight : Float
plHeight =
    1080


{-| The width of the game screen in pixel.
-}
plWidth : Float
plWidth =
    1920


{-| Debug flag
-}
debug : Bool
debug =
    False


{-| The background of the game.

This renderable will be rendered below all other renderables.

Default is clear function that cleans the background.

You can change the background color to other color when debugging.

Change color by using this:

Canvas.shapes [ fill Color.blue ][ Canvas.rect ( 0, 0 ) (toFloat gd.realWidth) (toFloat gd.realHeight) ]

-}
background : GlobalData -> Renderable
background gd =
    Canvas.clear ( 0, 0 ) gd.internalData.realWidth gd.internalData.realHeight
