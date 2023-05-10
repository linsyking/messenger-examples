module SceneProtos.SimpleGame.GameComponent.Base exposing (..)

import Canvas exposing (Renderable)
import Color exposing (Color)
import Lib.Env.Env exposing (EnvC)
import Messenger.GeneralModel exposing (GeneralModel)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


type alias GameComponent =
    GeneralModel Data (EnvC CommonData) GameComponentInitData GameComponentMsg GameComponentTarget Renderable


type GameComponentTarget
    = GCParent
    | GCById Int
    | GCByName String


type GameComponentMsg
    = NullGCMsg


type alias Data =
    { uid : Int
    , position : ( Int, Int )
    , velocity : ( Float, Float )
    , radius : Float
    , color : Color
    }


type GameComponentInitData
    = GCBallInitData BallInitData
    | NullGCInitData


type alias BallInitData =
    { position : ( Int, Int )
    , velocity : ( Float, Float )
    , radius : Float
    , color : Color
    }
