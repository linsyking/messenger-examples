module Scenes.Home2.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Canvas
import Canvas.Settings exposing (fill)
import Color
import Duration
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Sprite exposing (renderSprite)
import Messenger.Scene.RawScene exposing (RawSceneInit, RawSceneUpdate, RawSceneView, genRawScene)
import Messenger.Scene.Scene exposing (MConcreteScene, SceneOutputMsg(..), SceneStorage)
import Messenger.Scene.Transitions.Base exposing (genTransition, nullTransition)
import Messenger.Scene.Transitions.Fade exposing (fadeInWithRenderable)
import Messenger.UserConfig exposing (coloredBackground)


type alias Data =
    {}


init : RawSceneInit Data UserData SceneMsg
init env msg =
    {}


update : RawSceneUpdate Data UserData SceneMsg
update env msg data =
    if env.globalData.sceneStartFrame == 200 then
        ( data, [ SOMChangeScene Nothing "Home" (Just <| genTransition ( nullTransition, Duration.seconds 0 ) ( fadeInWithRenderable (view env data), Duration.seconds 1 )) ], env )

    else
        ( data, [], env )


view : RawSceneView UserData Data
view env data =
    Canvas.group []
        [ coloredBackground Color.white env.globalData
        , renderSprite env.globalData [] ( 100, 100 ) ( 100, 0 ) "blob"
        , Canvas.shapes [ fill Color.blue ]
            [ rect env.globalData ( 400, 200 ) ( 100, 100 )
            ]
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
