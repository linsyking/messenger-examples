module Scenes.AllScenes exposing (allScenes)

{-| This module is generated by Messenger, don't modify this.

This module records all the scenes.

@docs allScenes

-}

import Scenes.Main.Export as Main
import Scenes.Main.Global as MainG
import Scenes.SceneSettings exposing (SceneT)


{-| allScenes
Add all the scenes here
-}
allScenes : List ( String, SceneT )
allScenes =
    [ ( "Main", MainG.sceneToST Main.scene )
    ]