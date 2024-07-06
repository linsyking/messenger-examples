module Scenes.Home.Main.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Canvas exposing (group)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent, updateComponents, updateComponentsWithTarget, viewComponents)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Layer.Layer exposing (ConcreteLayer, Handler, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer, handleComponentMsgs)
import Messenger.Render.Text exposing (renderTextWithColorCenter)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import PortableComponents.Typer.History as History
import Scenes.Home.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Home.Components.Console as Console
import Scenes.Home.SceneBase exposing (..)


type alias Data =
    { components : List (AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg)
    , txt : String
    , clear : Bool
    }


init : LayerInit SceneCommonData UserData LayerMsg Data
init env _ =
    Data
        [ Console.component 0 (ConsoleInit env.globalData.userData.consoleHis) env ]
        ""
        False


handleComponentMsg : Handler Data SceneCommonData UserData LayerTarget LayerMsg SceneMsg ComponentMsg
handleComponentMsg ({ globalData } as env) compmsg data =
    case compmsg of
        SOMMsg som ->
            ( data, [ Parent <| SOMMsg som ], env )

        OtherMsg cmsg ->
            case cmsg of
                ConsoleOutput cmd ->
                    case cmd of
                        "clear" ->
                            ( { data | clear = True }, [ Parent <| SOMMsg <| SOMSaveGlobalData ], { env | globalData = { globalData | userData = { consoleHis = History.Empty } } } )

                        _ ->
                            ( { data | txt = cmd }, [], env )

                ConsoleLog his ->
                    ( data, [ Parent <| SOMMsg <| SOMSaveGlobalData ], { env | globalData = { globalData | userData = { consoleHis = his } } } )

                _ ->
                    ( data, [], env )


update : LayerUpdate SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
update env evt data =
    let
        ( comps1, msgs1, ( env1, block1 ) ) =
            updateComponents env evt data.components

        ( data1, msgs2, env2 ) =
            handleComponentMsgs env1 msgs1 { data | components = comps1 } [] handleComponentMsg

        data2 =
            if data1.clear then
                (\( comps, _, _ ) -> { data1 | components = comps, clear = False }) <|
                    updateComponentsWithTarget env2 [ ( "console", ConsoleClear ) ] data1.components

            else
                data1
    in
    ( data2, msgs2, ( env2, block1 ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
updaterec env _ data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    group []
        [ renderTextWithColorCenter env.globalData.internalData 100 data.txt "Arial" Color.black ( 960, 540 )
        , viewComponents env data.components
        ]


matcher : Matcher Data LayerTarget
matcher _ tar =
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
