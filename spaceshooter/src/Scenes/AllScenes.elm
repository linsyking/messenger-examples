module Scenes.AllScenes exposing (allScenes)

{-| This module is generated by Messenger, don't modify this.

This module records all the scenes.

@docs allScenes

-}

import SceneProtos.CoreEngine.Export as CoreEngine
import SceneProtos.CoreEngine.Global as CoreEngineG
import Scenes.Level1.Export as Level1
import Scenes.SceneSettings exposing (SceneT)


{-| allScenes
Add all the scenes here
-}
allScenes : List ( String, SceneT )
allScenes =
    [ ( "Level1", CoreEngineG.sceneToST <| CoreEngine.genScene Level1.game )
    ]