module Scenes.Main.Components.GameGrid.Model exposing (component)

{-| Component model

@docs component

-}

import Browser.Events exposing (Visibility(..))
import Canvas
import Canvas.Settings exposing (fill)
import Color
import Lib.Base exposing (SceneMsg)
import Lib.Tetris.Base exposing (AnimationState, Direction(..), TetrisEvent(..))
import Lib.Tetris.Grid as G
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Scene.Scene exposing (SceneOutputMsg(..))
import Scenes.Main.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Main.Components.GameGrid.Animate exposing (animate, cancelState, changeDir, spawnTetrimino, startAccelerate, startMove, startRotate)
import Scenes.Main.Components.GameGrid.Base exposing (Data)
import Scenes.Main.Components.GameGrid.Render exposing (renderWell)
import Scenes.Main.SceneBase exposing (SceneCommonData, State(..))


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    ( { grid = G.empty
      , active = G.empty
      , scale = { width = 10, height = 20 }
      , position = ( 0, 0 )
      , direction = { left = False, right = False }
      , animation = { move = AnimationState False False 0, rotate = AnimationState False False 0, accelerate = False }
      }
    , ()
    )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update ({ globalData } as env) evnt data basedata =
    if globalData.windowVisibility == Visible then
        case evnt of
            KeyDown 37 ->
                --Left
                ( ( startMove <| changeDir Left data, basedata ), [], ( env, False ) )

            KeyDown 39 ->
                --Right
                ( ( startMove <| changeDir Right data, basedata ), [], ( env, False ) )

            KeyDown 38 ->
                --Up
                ( ( startRotate True data, basedata ), [], ( env, False ) )

            KeyDown 40 ->
                --Down
                ( ( startAccelerate True data, basedata ), [], ( env, False ) )

            KeyUp _ ->
                ( ( cancelState data, basedata ), [], ( env, False ) )

            Tick dt ->
                let
                    newMaxScore =
                        max env.commonData.score globalData.userData.currentMaxScore

                    newEnv =
                        { env | globalData = { globalData | userData = { lastMaxScore = globalData.userData.lastMaxScore, currentMaxScore = newMaxScore } } }
                in
                if env.commonData.state == Playing && dt <= 100 then
                    animate dt newEnv data
                        |> (\( d, m, e ) -> ( ( d, () ), m ++ [ Parent <| SOMMsg SOMSaveGlobalData ], ( e, False ) ))

                else
                    ( ( data, basedata ), [ Parent <| SOMMsg SOMSaveGlobalData ], ( newEnv, False ) )

            _ ->
                ( ( data, basedata ), [], ( env, False ) )

    else
        ( ( cancelState data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec ({ commonData } as env) msg data basedata =
    case msg of
        TetrisMsg tevent ->
            case tevent of
                Start ->
                    let
                        ( newData, newEnv ) =
                            spawnTetrimino { env | commonData = { commonData | score = 0, lines = 0 } } { data | grid = G.empty }
                    in
                    ( ( newData, basedata ), [], newEnv )

                CancelAll ->
                    ( ( cancelState data, basedata ), [], env )

                Move dir ->
                    ( ( startMove <| changeDir dir data, basedata ), [], env )

                Rotate on ->
                    ( ( startRotate on data, basedata ), [], env )

                Accelerate on ->
                    ( ( startAccelerate on data, basedata ), [], env )

                _ ->
                    ( ( data, basedata ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( Canvas.group []
        [ renderWell env data
        , Canvas.shapes [ fill Color.white ]
            [ rect env.globalData ( 0, 0 ) ( 600, 30 )
            ]
        ]
    , 0
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == "GameGrid"


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
