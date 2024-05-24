module PortableComponents.Button.Model exposing (..)

import Canvas exposing (group, shapes)
import Canvas.Settings exposing (fill)
import Color
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.PortableComponent exposing (ConcretePortableComponent, PortableComponentInit, PortableComponentStorage, PortableComponentUpdate, PortableComponentUpdateRec, PortableComponentView, genPortableComponent)
import Messenger.Coordinate.Coordinates exposing (judgeMouseRect)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Text exposing (renderText, renderTextWithColorCenter)


type Target
    = OtherC
    | Me


type Msg
    = InitData (Maybe Data)
    | Pressed


type alias Data =
    { pos : ( Float, Float )
    , size : ( Float, Float )
    , text : String
    }


init : PortableComponentInit userdata Msg Data
init _ msg =
    case msg of
        InitData (Just data) ->
            data

        _ ->
            { pos = ( 0, 0 )
            , size = ( 100, 50 )
            , text = "Button"
            }


update : PortableComponentUpdate Data userdata Target Msg scenemsg
update env event data =
    case event of
        MouseDown 0 pos ->
            if judgeMouseRect pos data.pos data.size then
                ( data, [ Other ( OtherC, Pressed ) ], ( env, True ) )

            else
                ( data, [], ( env, False ) )

        _ ->
            ( data, [], ( env, False ) )


updaterec : PortableComponentUpdateRec Data userdata Target Msg scenemsg
updaterec env msg data =
    ( data, [], env )


view : PortableComponentView userdata Data
view env data =
    let
        cx =
            Tuple.first data.pos + Tuple.first data.size / 2

        cy =
            Tuple.second data.pos + Tuple.second data.size / 2

        pos =
            ( cx, cy )
    in
    group []
        [ shapes [ fill Color.blue ] [ rect env.globalData data.pos data.size ]

        -- , renderText env.globalData 20 data.text "Arial" data.pos
        , renderTextWithColorCenter env.globalData 20 data.text "Arial" Color.black pos
        ]


matcher : Matcher Data Target
matcher data tar =
    tar == Me


componentcon : ConcretePortableComponent Data userdata Target Msg scenemsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }
