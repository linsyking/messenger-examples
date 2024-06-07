module Scenes.Main.Model exposing (scene)

{-| Scene configuration module

@docs scene

-}

import Lib.Base exposing (SceneMsg)
import Lib.Tetris.Tetriminos as Tetriminos
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env, addCommonData)
import Messenger.Scene.LayeredScene exposing (LayeredSceneInit, LayeredSceneSettingsFunc, genLayeredScene)
import Messenger.Scene.Scene exposing (SceneStorage)
import Scenes.Main.FrontLayer.Model as FrontLayer
import Scenes.Main.GameLayer.Model as GameLayer
import Scenes.Main.SceneBase exposing (..)
import Time


commonDataInit : Env () UserData -> Maybe SceneMsg -> SceneCommonData
commonDataInit env _ =
    { state = Stopped
    , score = 0
    , lines = 0
    , next = Tetriminos.random <| Time.posixToMillis env.globalData.currentTimeStamp
    }


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
        [ GameLayer.layer NullLayerMsg envcd
        , FrontLayer.layer NullLayerMsg envcd
        ]
    }


settings : LayeredSceneSettingsFunc SceneCommonData UserData LayerTarget LayerMsg SceneMsg
settings _ _ _ =
    []


{-| Scene generator
-}
scene : SceneStorage UserData SceneMsg
scene =
    genLayeredScene init settings
