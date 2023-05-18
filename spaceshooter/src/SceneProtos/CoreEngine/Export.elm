module SceneProtos.CoreEngine.Export exposing
    ( Data
    , genScene
    )

{-| This is the doc for this module

@docs Data
@docs genScene

-}

import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (Scene, SceneInitData(..), SceneTMsg(..))
import SceneProtos.CoreEngine.Common exposing (Model)
import SceneProtos.CoreEngine.LayerInit exposing (CoreEngineInit)
import SceneProtos.CoreEngine.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| genScene
-}
genScene : (Env -> SceneTMsg -> CoreEngineInit) -> Scene Data
genScene im =
    { init =
        \env i ->
            case i of
                SceneTransMsg init ->
                    initModel env <| CoreEngineInitData (im env init)

                _ ->
                    initModel env <| CoreEngineInitData (im env NullSceneMsg)
    , update = updateModel
    , view = viewModel
    }
