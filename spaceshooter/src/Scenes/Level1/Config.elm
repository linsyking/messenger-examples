module Scenes.Level1.Config exposing (..)

import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent, GameComponentInitData(..))
import SceneProtos.CoreEngine.GameComponents.Enemy.Base exposing (EnemyInit)
import SceneProtos.CoreEngine.GameComponents.Enemy.Export as Enemy
import SceneProtos.CoreEngine.GameComponents.Ship.Base exposing (ShipInit)
import SceneProtos.CoreEngine.GameComponents.Ship.Export as Ship


initObjects : Env -> SceneTMsg -> List GameComponent
initObjects env _ =
    [ Ship.initGC env <| GCIdData 0 (GCShipInitData <| ShipInit ( 100, 500 ) 15)
    , Enemy.initGC env <| GCIdData 1 (GCEnemyInitData <| EnemyInit -1 ( 1920, 1000 ) 50 10 25)
    ]
