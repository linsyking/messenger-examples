module Scenes.Level1.Config exposing (..)

import Array exposing (Array)
import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent)


initObjects : Env -> SceneTMsg -> Array GameComponent
initObjects _ _ =
    Array.empty
