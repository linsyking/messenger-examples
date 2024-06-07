module Scenes.Main.Components.GameGrid.Base exposing (Data, EnvGameGrid, OutputMsg)

import Color exposing (Color)
import Lib.Base exposing (SceneMsg)
import Lib.Tetris.Base exposing (AnimationState)
import Lib.Tetris.Grid exposing (Grid)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (Env)
import Messenger.GeneralModel exposing (MMsg)
import Scenes.Main.Components.ComponentBase exposing (ComponentMsg, ComponentTarget)
import Scenes.Main.SceneBase exposing (SceneCommonData)


type alias Data =
    { grid : Grid Color
    , active : Grid Color
    , scale : { width : Int, height : Int }
    , position : ( Int, Float )
    , direction : { left : Bool, right : Bool }
    , animation : { move : AnimationState, rotate : AnimationState, accelerate : Bool }
    }


type alias EnvGameGrid =
    Env SceneCommonData UserData


type alias OutputMsg =
    MMsg ComponentTarget ComponentMsg SceneMsg UserData
