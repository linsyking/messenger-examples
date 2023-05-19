module SceneProtos.CoreEngine.GameComponents.Enemy.Export exposing (initGC)

import Lib.Env.Env exposing (Env)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent, GameComponentInitData)
import SceneProtos.CoreEngine.GameComponents.Enemy.Model exposing (initModel, updateModel, viewModel)


initGC : Env -> GameComponentInitData -> GameComponent
initGC env i =
    { name = "Enemy"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
