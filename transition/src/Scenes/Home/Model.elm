module Scenes.Home.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Canvas
import Duration
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Scene.RawScene exposing (RawSceneInit, RawSceneUpdate, RawSceneView, genRawScene)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneOutputMsg(..), SceneStorage)
import Messenger.Scene.Transitions.Base exposing (genTransition)
import Messenger.Scene.Transitions.Fade exposing (fadeInBlack, fadeOutBlack)


type alias Data =
    {}


init : RawSceneInit Data UserData SceneMsg
init env msg =
    {}


update : RawSceneUpdate Data UserData SceneMsg
update env msg data =
    if env.globalData.sceneStartFrame == 100 then
        ( data, [ SOMChangeScene Nothing "Home2" (Just <| genTransition ( fadeOutBlack, Duration.seconds 1 ) ( fadeInBlack, Duration.seconds 1 )) ], env )

    else
        ( data, [], env )


view : RawSceneView UserData Data
view env data =
    Canvas.group []
        [ renderSprite env.globalData [] ( 0, 0 ) ( 1920, 0 ) "bg"
        , renderSprite env.globalData [] ( 0, 0 ) ( 960, 0 ) "blob"
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
