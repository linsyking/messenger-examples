module Scenes.Home.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, addCommonData)
import Messenger.Scene.LayeredScene exposing (LayeredSceneInit, LayeredSceneSettingsFunc, genLayeredScene)
import Messenger.Scene.Scene exposing (SceneStorage)
import Scenes.Home.LayerBase exposing (..)
import Scenes.Home.Main.Model as Main


{-| Initialize the commondata used in the scene.
-}
commonDataInit : Env () UserData -> Maybe SceneMsg -> SceneCommonData
commonDataInit _ _ =
    {}


{-| Init function for the scene.

Add all the layers with their init msg here.

-}
init : LayeredSceneInit SceneCommonData UserData LayerTarget LayerMsg SceneMsg
init env msg =
    let
        cd =
            commonDataInit env msg

        envcd =
            addCommonData cd env
    in
    { renderSettings = []
    , commonData = cd
    , layers =
        [ Main.layer NullLayerMsg envcd
        ]
    }


{-| Render setting function
-}
settings : LayeredSceneSettingsFunc SceneCommonData UserData LayerTarget LayerMsg SceneMsg
settings _ _ _ =
    []


{-| Generate an abstract scnene storage
-}
scene : SceneStorage UserData SceneMsg
scene =
    genLayeredScene init settings
