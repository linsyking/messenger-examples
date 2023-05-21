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
import SceneProtos.CoreEngine.GameComponents.Bullet.Base exposing (BulletInit)
import SceneProtos.CoreEngine.GameComponents.Enemy.Base exposing (EnemyInit)
import SceneProtos.CoreEngine.GameComponents.Ship.Base exposing (ShipInit)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


type alias GameComponent =
    GeneralModel Data (EnvC CommonData) GameComponentMsg GameComponentTarget Renderable


type GameComponentTarget
    = GCParent
    | GCById Int
    | GCByName String


type GameComponentMsg
    = GCNewBulletMsg BulletInit
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
    | GCBulletInitData BulletInit
    | GCEnemyInitData EnemyInit
    | GCShipInitData ShipInit
    | NullGCInitData
