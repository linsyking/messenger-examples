module SceneProtos.Game.FrontLayer.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Canvas
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (alpha, filter)
import Color exposing (red, white)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Layer.Layer exposing (ConcreteLayer, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer)
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Text exposing (renderText, renderTextWithColorCenter)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import SceneProtos.Game.SceneBase exposing (..)
import String exposing (fromInt)


type alias Data =
    { level : String }


init : LayerInit SceneCommonData UserData (LayerMsg SceneMsg) Data
init env initMsg =
    case initMsg of
        FrontInitData lv ->
            Data lv

        _ ->
            Data ""


update : LayerUpdate SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
update env evt data =
    if not env.commonData.gameOver then
        let
            nextLvmsg =
                if env.commonData.score >= 80 && data.level == "Level1" then
                    [ Parent <| SOMMsg <| SOMChangeScene Nothing "Level2" Nothing ]

                else
                    []
        in
        ( data, nextLvmsg, ( env, False ) )

    else
        case evt of
            MouseDown 0 _ ->
                ( data, [ Parent <| SOMMsg <| SOMChangeScene Nothing data.level Nothing ], ( env, True ) )

            KeyDown 32 ->
                -- space
                ( data, [ Parent <| SOMMsg <| SOMChangeScene Nothing data.level Nothing ], ( env, True ) )

            _ ->
                ( data, [], ( env, False ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
updaterec env msg data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    let
        gameOverVE =
            if env.commonData.gameOver then
                [ filter "blur(5px)" ]

            else
                []

        gameOverMask =
            if env.commonData.gameOver then
                Canvas.group []
                    [ Canvas.shapes [ alpha 0.2, fill white ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
                    , renderTextWithColorCenter env.globalData 120 "Game Over" "Arial" red ( 960, 540 )
                    ]

            else
                Canvas.empty
    in
    [ Canvas.group gameOverVE
        [ renderText env.globalData 40 ("Score: " ++ fromInt env.commonData.score) "Arial" ( 1730, 80 )
        , renderText env.globalData 40 data.level "Arial" ( 1750, 30 )
        ]
    , gameOverMask
    ]
        |> Canvas.group []


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "FrontLayer"


layercon : ConcreteLayer Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
layercon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Layer generator
-}
layer : LayerStorage SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
layer =
    genLayer layercon
