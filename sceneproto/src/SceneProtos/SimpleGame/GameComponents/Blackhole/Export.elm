module SceneProtos.SimpleGame.GameComponents.Blackhole.Export exposing (..)

import Lib.Env.Env exposing (Env)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent, GameComponentInitData)
import SceneProtos.SimpleGame.GameComponents.Blackhole.Blackhole exposing (initModel, updateModel, viewModel)


initGC : Env -> GameComponentInitData -> GameComponent
initGC env i =
    { name = "Blackhole"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
