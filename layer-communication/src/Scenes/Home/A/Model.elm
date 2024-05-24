module Scenes.Home.A.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Canvas
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.GeneralModel exposing (Matcher, Msg(..))
import Messenger.Layer.Layer exposing (ConcreteLayer, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer)
import Scenes.Home.SceneBase exposing (..)


type alias Data =
    {}


init : LayerInit SceneCommonData UserData LayerMsg Data
init env initMsg =
    {}


update : LayerUpdate SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
update env evt data =
    ( data, [], ( env, False ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
updaterec env msg data =
    case msg of
        IntMsg x ->
            if 0 <= x && x < 10 then
                ( data, [ Other ( "B", IntMsg (3 * x) ), Other ( "B", IntMsg (10 - 3 * x) ), Other ( "C", IntMsg x ) ], env )

            else
                ( data, [], env )

        _ ->
            ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    Canvas.empty


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "A"


layercon : ConcreteLayer Data SceneCommonData UserData LayerTarget LayerMsg SceneMsg
layercon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Layer generator
-}
layer : LayerStorage SceneCommonData UserData LayerTarget LayerMsg SceneMsg
layer =
    genLayer layercon
