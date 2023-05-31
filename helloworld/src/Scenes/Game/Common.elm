module Scenes.Game.Common exposing (Model, nullModel, initModel)

{-| Common module

This module is generated by Messenger, don't modify this.

@docs Model, nullModel, initModel

-}

import Lib.Env.Env exposing (Env, addCommonData)
import Lib.Scene.Base exposing (LayerPacker, SceneInitData(..))
import Scenes.Game.A.Export as A
import Scenes.Game.A.Global as AG
import Scenes.Game.B.Export as B
import Scenes.Game.B.Global as BG
import Scenes.Game.LayerBase exposing (CommonData, nullCommonData)
import Scenes.Game.LayerSettings exposing (LayerT)
import Scenes.Game.SceneInit exposing (initCommonData, nullGameInit)


{-| Model
-}
type alias Model =
    LayerPacker CommonData LayerT


{-| nullModel
-}
nullModel : Model
nullModel =
    { commonData = nullCommonData
    , layers = []
    }


{-| Initialize the model
-}
initModel : Env -> SceneInitData -> Model
initModel env init =
    let
        layerInitData =
            case init of
                GameInitData x ->
                    x

                _ ->
                    nullGameInit
    in
    { commonData = initCommonData env layerInitData
    , layers =
        [ BG.getLayerT <| B.initLayer (addCommonData nullCommonData env) layerInitData
        , AG.getLayerT <| A.initLayer (addCommonData nullCommonData env) layerInitData
        ]
    }