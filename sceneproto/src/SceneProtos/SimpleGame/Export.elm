module SceneProtos.SimpleGame.Export exposing
    ( Data
    , genScene
    )

{-| This is the doc for this module

@docs Data
@docs genScene

-}

import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (Scene, SceneInitData(..), SceneTMsg(..))
import SceneProtos.SimpleGame.Common exposing (Model)
import SceneProtos.SimpleGame.LayerInit exposing (SimpleGameInit)
import SceneProtos.SimpleGame.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


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
                    initModel env <| SimpleGameInitData (im env NullSceneMsg)
    , update = updateModel
    , view = viewModel
    }
