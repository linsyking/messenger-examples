module Scenes.AllScenes exposing (allScenes)

{-| This is the doc for this module

This module records all the scenes.

@docs allScenes

-}

import SceneProtos.SimpleGame.Export as SimpleGame
import SceneProtos.SimpleGame.Global as SimpleGameG
import Scenes.Home.Export as Home
import Scenes.Home.Global as HomeG
import Scenes.Scene1.Export as Scene1
import Scenes.SceneSettings exposing (SceneT)


{-| allScenes
Add all the scenes here
-}
allScenes : List ( String, SceneT )
allScenes =
    [ ( "Home", HomeG.sceneToST Home.scene )
    , ( "Scene1", SimpleGameG.sceneToST <| SimpleGame.genScene Scene1.game )
    ]
