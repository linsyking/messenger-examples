module Scenes.AllScenes exposing (allScenes)

{-| This is the doc for this module

This module records all the scenes.

@docs allScenes

-}

import Scenes.Home.Export as Home
import Scenes.Home.Global as HomeG
import Scenes.SceneSettings exposing (..)


{-| allScenes
Add all the scenes here
-}
allScenes : List ( String, SceneT )
allScenes =
    [ ( "Home", HomeG.sceneToST Home.scene )
    ]
