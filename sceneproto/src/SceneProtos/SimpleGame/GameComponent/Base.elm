module SceneProtos.SimpleGame.GameComponent.Base exposing
    ( Data
    , GameComponent
    , GameComponentInitData(..)
    , GameComponentMsg(..)
    , GameComponentTarget(..)
    )

import Canvas exposing (Renderable)
import Color exposing (Color)
import Lib.Env.Env exposing (EnvC)
import Messenger.GeneralModel exposing (GeneralModel)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


type alias GameComponent =
    GeneralModel Data (EnvC CommonData) GameComponentMsg GameComponentTarget Renderable


type GameComponentTarget
    = GCParent
    | GCById Int
    | GCByName String


type GameComponentMsg
    = GCEatMsg Int
    | NullGCMsg


type alias Data =
    { uid : Int
    , position : ( Int, Int )
    , velocity : ( Int, Int )
    , radius : Int
    , color : Color
    }


type GameComponentInitData
    = GCIdData Int GameComponentInitData
    | GCBallInitData BallInitData
    | NullGCInitData


type alias BallInitData =
    { position : ( Int, Int )
    , velocity : ( Int, Int )
    , radius : Int
    , color : Color
    }
