module Scenes.Level1.Export exposing (game)

{-| Export module

@docs game

-}

import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import SceneProtos.CoreEngine.LayerInit exposing (CoreEngineInit)


{-| Use the environment and sent init data to change the init data.
-}
game : Env -> SceneTMsg -> CoreEngineInit
game _ _ =
    {}
