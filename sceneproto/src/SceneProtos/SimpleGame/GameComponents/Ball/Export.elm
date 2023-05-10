module SceneProtos.SimpleGame.GameComponents.Ball.Export exposing (initGC)

import Lib.Env.Env exposing (EnvC)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent, GameComponentInitData)
import SceneProtos.SimpleGame.GameComponents.Ball.Ball exposing (initModel, updateModel, viewModel)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


initGC : EnvC CommonData -> GameComponentInitData -> GameComponent
initGC env i =
    { name = "Ball"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
