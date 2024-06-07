module Scenes.Main.Components.Button.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (Point)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), TextBaseLine(..))
import Color exposing (Color)
import Lib.Base exposing (SceneMsg)
import Lib.Tetris.Base as Tetris
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Coordinate.Coordinates exposing (judgeMouseRect)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Text exposing (renderTextWithColorAlignBaseline)
import Scenes.Main.Components.Button.Init as Button exposing (ButtonType)
import Scenes.Main.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Main.SceneBase exposing (SceneCommonData, State(..))


type alias Data =
    { size : ( Float, Float )
    , position : Point
    , text : { content : String, color : Color }
    , backgroundColor : Color
    , buttonType : ButtonType
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        ButtonInitMsg initData ->
            ( initData, () )

        _ ->
            ( Data ( 0, 0 ) ( 0, 0 ) { content = "", color = Color.white } Color.white Button.State, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update ({ commonData } as env) evnt ({ text } as data) basedata =
    case evnt of
        MouseDown 0 pos ->
            if judgeMouseRect pos data.position data.size then
                case ( data.buttonType, commonData.state ) of
                    ( Button.State, Stopped ) ->
                        ( ( { data | text = { text | content = "Pause" } }, basedata ), [ Other ( "GameGrid", TetrisMsg Tetris.Start ) ], ( { env | commonData = { commonData | state = Playing } }, False ) )

                    ( Button.State, Paused ) ->
                        ( ( { data | text = { text | content = "Pause" } }, basedata ), [], ( { env | commonData = { commonData | state = Playing } }, False ) )

                    ( Button.State, Playing ) ->
                        ( ( { data | text = { text | content = "Resume" } }, basedata ), [], ( { env | commonData = { commonData | state = Paused } }, False ) )

                    ( Button.Move dir, Playing ) ->
                        ( ( data, basedata ), [ Other ( "GameGrid", TetrisMsg <| Tetris.Move dir ) ], ( env, False ) )

                    ( Button.Rotate, Playing ) ->
                        ( ( data, basedata ), [ Other ( "GameGrid", TetrisMsg <| Tetris.Rotate True ) ], ( env, False ) )

                    ( Button.Accelerate, Playing ) ->
                        ( ( data, basedata ), [ Other ( "GameGrid", TetrisMsg <| Tetris.Accelerate True ) ], ( env, False ) )

                    _ ->
                        ( ( data, basedata ), [], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        MouseUp 0 pos ->
            if judgeMouseRect pos data.position data.size then
                ( ( data, basedata ), [ Other ( "GameGrid", TetrisMsg Tetris.CancelAll ) ], ( env, False ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg ({ text } as data) basedata =
    case msg of
        TetrisMsg Tetris.GameOver ->
            if data.buttonType == Button.State then
                ( ( { data | text = { text | content = "New Game" } }, basedata ), [], env )

            else
                ( ( data, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    let
        ( x, y ) =
            data.position

        ( w, h ) =
            data.size
    in
    ( Canvas.group []
        [ Canvas.shapes [ fill data.backgroundColor ]
            [ rect env.globalData data.position data.size
            ]
        , renderTextWithColorAlignBaseline env.globalData 20 data.text.content "Helvetica" data.text.color Center Middle ( x + w / 2, y + h / 2 )
        ]
    , 1
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "Button"


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Component generator
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
