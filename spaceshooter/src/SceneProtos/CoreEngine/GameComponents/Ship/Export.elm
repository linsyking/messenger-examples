module SceneProtos.CoreEngine.GameComponents.Ship.Export exposing (initGC)

import Lib.Env.Env exposing (Env)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent, GameComponentInitData)
import SceneProtos.CoreEngine.GameComponents.Ship.Model exposing (initModel, updateModel, viewModel)


initGC : Env -> GameComponentInitData -> GameComponent
initGC env i =
    { name = "Ship"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
