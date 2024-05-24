module Scenes.Home.Main.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Color exposing (orange, red, yellow)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent, updateComponents, viewComponents)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Layer.Layer exposing (ConcreteLayer, Handler, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer, handleComponentMsgs)
import PortableComponents.Button.Model as ButtonConfig
import Scenes.Home.Components.Button as Button
import Scenes.Home.Components.Comp.Model as Rect
import Scenes.Home.Components.Comp.Msg as RectMsg
import Scenes.Home.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Home.LayerBase exposing (..)


type alias Data =
    { components : List (AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg)
    }


init : LayerInit SceneCommonData UserData LayerMsg Data
init env initMsg =
    Data
        [ Button.component 1 "Rect" (RectMsg yellow) (ButtonInit <| ButtonConfig.Data ( 0, 0 ) ( 100, 100 ) "Button 1") env
        , Button.component 1 "Rect" (RectMsg orange) (ButtonInit <| ButtonConfig.Data ( 300, 300 ) ( 100, 100 ) "Button 2") env
        , Rect.component (RectInit <| RectMsg.Init 200 500 200 200 red) env
        ]


handleComponentMsg : Handler Data SceneCommonData UserData LayerTarget LayerMsg SceneMsg ComponentMsg
handleComponentMsg env compmsg data =
    case compmsg of
        SOMMsg som ->
            ( data, [ Parent <| SOMMsg som ], env )

        _ ->
            ( data, [], env )


update : LayerUpdate SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
update env evt data =
    let
        ( comps1, msgs1, ( env1, block1 ) ) =
            updateComponents env evt data.components

        ( data1, msgs2, env2 ) =
            handleComponentMsgs env1 msgs1 { data | components = comps1 } [] handleComponentMsg
    in
    ( data1, msgs2, ( env2, block1 ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
updaterec env msg data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    viewComponents env data.components


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "Main"


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
