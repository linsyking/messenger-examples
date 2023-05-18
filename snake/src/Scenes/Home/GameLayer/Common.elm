module Scenes.Home.GameLayer.Common exposing
    ( Model, nullModel, EnvC
    , Dir(..), Live_status(..), Movable(..)
    )

{-| This is the doc for this module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Home.LayerBase exposing (CommonData)


{-| Model
-}
type alias Model =
    { snake_body : List ( Int, Int )
    , snake_dir : Dir
    , snake_state : Live_status
    , fruit_pos : ( Int, Int )
    , move_timer : Float
    }


type Dir
    = Up
    | Down
    | Left
    | Right


type Movable
    = Wall
    | Free


type Live_status
    = Alive
    | Dead


{-| nullModel
-}
nullModel : Model
nullModel =
    Model [ ( 1, 0 ), ( 0, 0 ) ] Right Alive ( 5, 1 ) 0


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
