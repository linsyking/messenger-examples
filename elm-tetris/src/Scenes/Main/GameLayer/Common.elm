module Scenes.Main.GameLayer.Common exposing (Model, nullModel, EnvC)

{-| This is the doc for this module

@docs Model, nullModel, EnvC

-}

import Color exposing (Color)
import Lib.Env.Env as Env
import Lib.Tetris.Base exposing (AnimationState)
import Lib.Tetris.Grid as G exposing (Grid)
import Lib.Tetris.Tetriminos as Tetriminos
import Scenes.Main.LayerBase exposing (CommonData, State(..))


{-| Model
-}
type alias Model =
    { active : Grid Color
    , position : ( Int, Float )
    , grid : Grid Color
    , lines : Int
    , next : Grid Color
    , score : Int
    , acceleration : Bool
    , moveLeft : Bool
    , moveRight : Bool
    , direction : AnimationState
    , rotation : AnimationState
    , width : Int
    , height : Int
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { active = G.empty
    , position = ( 0, 0 )
    , grid = G.empty
    , lines = 0
    , next = Tetriminos.random 0
    , score = 0
    , acceleration = False
    , moveLeft = False
    , moveRight = False
    , rotation = Nothing
    , direction = Nothing
    , width = 10
    , height = 20
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
