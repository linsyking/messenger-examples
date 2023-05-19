module SceneProtos.CoreEngine.GameComponent.Base exposing
    ( Data
    , GameComponent
    , GameComponentInitData(..)
    , GameComponentMsg(..)
    , GameComponentTarget(..)
    )

import Canvas exposing (Renderable)
import Dict exposing (Dict)
import Lib.Component.Base exposing (DefinedTypes)
import Lib.Env.Env exposing (EnvC)
import Messenger.GeneralModel exposing (GeneralModel)
import SceneProtos.CoreEngine.GameComponents.Bullet.Base exposing (Bullet)
import SceneProtos.CoreEngine.GameComponents.Enemy.Base exposing (Enemy)
import SceneProtos.CoreEngine.GameComponents.Ship.Base exposing (Ship)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


type alias GameComponent =
    GeneralModel Data (EnvC CommonData) GameComponentMsg GameComponentTarget Renderable


type GameComponentTarget
    = GCParent
    | GCById Int
    | GCByName String


type GameComponentMsg
    = GCNewBulletMsg Bullet
    | GCCollisionMsg String
    | GCGameOverMsg
    | NullGCMsg


type alias Data =
    { uid : Int
    , position : ( Float, Float )
    , velocity : Float
    , collisionBox : ( Float, Float )
    , alive : Bool
    , extra : Dict String DefinedTypes
    }


type GameComponentInitData
    = GCIdData Int GameComponentInitData
    | GCBulletInitData Bullet
    | GCEnemyInitData Enemy
    | GCShipInitData Ship
    | NullGCInitData
