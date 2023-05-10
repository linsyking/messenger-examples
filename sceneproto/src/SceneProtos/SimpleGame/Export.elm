module SceneProtos.SimpleGame.Export exposing
    ( Data
    , nullData
    , genScene
    )

{-| This is the doc for this module

@docs Data
@docs nullData
@docs genScene

-}

import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (Scene, SceneInitData(..), SceneTMsg)
import SceneProtos.SimpleGame.Common exposing (Model)
import SceneProtos.SimpleGame.LayerBase exposing (nullCommonData)
import SceneProtos.SimpleGame.LayerInit exposing (SimpleGameInit)
import SceneProtos.SimpleGame.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| nullData
-}
nullData : Data
nullData =
    { commonData = nullCommonData
    , layers = []
    }


{-| genScene
-}
genScene : (Env -> SceneTMsg -> SimpleGameInit) -> Scene Data
genScene im =
    { init =
        \env i ->
            case i of
                SceneTransMsg init ->
                    initModel env <| SimpleGameInitData (im env init)

                _ ->
                    nullData
    , update = updateModel
    , view = viewModel
    }
