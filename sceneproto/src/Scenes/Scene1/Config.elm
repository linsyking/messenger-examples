module Scenes.Scene1.Config exposing (..)

import Array exposing (Array)
import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent)


initBalls : Env -> SceneTMsg -> Array GameComponent
initBalls _ _ =
    Array.empty
