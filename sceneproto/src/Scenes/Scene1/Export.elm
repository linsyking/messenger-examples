module Scenes.Scene1.Export exposing (game)

import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import SceneProtos.SimpleGame.LayerInit exposing (SimpleGameInit)
import Scenes.Scene1.Config exposing (initBalls, initBlackhole)


{-| Use the environment and sent init data to change the init data.
-}
game : Env -> SceneTMsg -> SimpleGameInit
game env msg =
    { balls = initBalls env msg
    , blackhole = initBlackhole env msg
    }
