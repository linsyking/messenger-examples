module Scenes.Home.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Canvas exposing (Renderable, group)
import Canvas.Settings.Advanced exposing (alpha, imageSmoothing)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.Resources exposing (allSpriteSheets, allTexture)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (GlobalData, loadedSpriteNum)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import Messenger.Scene.RawScene exposing (RawSceneInit, RawSceneUpdate, RawSceneView, genRawScene)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneStorage)
import Messenger.UserConfig exposing (spriteNum)
import String exposing (fromInt)


type alias Data =
    {}


init : RawSceneInit Data UserData SceneMsg
init env msg =
    {}


update : RawSceneUpdate Data UserData SceneMsg
update env msg data =
    ( data, [], env )


view : RawSceneView UserData Data
view env data =
    let
        gd =
            env.globalData

        rate =
            5

        currentAct x =
            String.fromInt (modBy (rate * x) gd.sceneStartTime // rate)
    in
    group []
        [ renderSprite env.globalData [ imageSmoothing False ] ( 100, 300 ) ( 100, 0 ) ("player.0/" ++ currentAct 13)
        , renderSprite env.globalData [ imageSmoothing False ] ( 300, 300 ) ( 100, 0 ) ("player.1/" ++ currentAct 8)
        , renderSprite env.globalData [ imageSmoothing False ] ( 500, 300 ) ( 100, 0 ) ("player.2/" ++ currentAct 10)
        , renderSprite env.globalData [ imageSmoothing False ] ( 700, 300 ) ( 100, 0 ) ("player.3/" ++ currentAct 10)
        , renderSprite env.globalData [ imageSmoothing False ] ( 900, 300 ) ( 100, 0 ) ("player.4/" ++ currentAct 10)
        , renderSprite env.globalData [ imageSmoothing False ] ( 1100, 300 ) ( 100, 0 ) ("player.5/" ++ currentAct 6)
        , renderSprite env.globalData [ imageSmoothing False ] ( 1300, 300 ) ( 100, 0 ) ("player.6/" ++ currentAct 4)
        , renderSprite env.globalData [ imageSmoothing False ] ( 1500, 300 ) ( 100, 0 ) ("player.7/" ++ currentAct 7)
        , startText gd
        ]


startText : GlobalData UserData -> Renderable
startText gd =
    let
        loaded =
            loadedSpriteNum gd

        total =
            spriteNum allTexture allSpriteSheets

        progress =
            String.slice 0 4 <| String.fromFloat (toFloat loaded / toFloat total * 100)

        text =
            if loaded < total then
                "Loading... " ++ fromInt loaded ++ "/" ++ fromInt total ++ " (" ++ progress ++ "%)"

            else
                ""
    in
    group [ alpha (0.7 + sin (toFloat gd.globalTime / 10) / 3) ]
        [ renderTextWithColorCenter gd 60 text "Arial" Color.black ( 960, 900 )
        ]


scenecon : MConcreteScene Data UserData SceneMsg
scenecon =
    { init = init
    , update = update
    , view = view
    }


{-| Scene generator
-}
scene : SceneStorage UserData SceneMsg
scene =
    genRawScene scenecon
