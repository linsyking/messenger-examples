module Scenes.Main.FrontLayer.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Canvas exposing (Renderable)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Lib.Base exposing (SceneMsg)
import Lib.Tetris.Grid as Grid exposing (Grid)
import Lib.UserData exposing (UserData)
import Markdown
import Messenger.Base exposing (Env)
import Messenger.Coordinate.HTML exposing (genAttribute)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Layer.Layer exposing (ConcreteLayer, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer)
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Text exposing (renderTextWithColor)
import Scenes.Main.SceneBase exposing (..)


type alias EnvFrontLayer =
    Env SceneCommonData UserData


type alias Data =
    {}


init : LayerInit SceneCommonData UserData LayerMsg Data
init env initMsg =
    {}


update : LayerUpdate SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
update ({ globalData } as env) evt data =
    ( data, [], ( { env | globalData = { globalData | extraHTML = Just <| htmlView env } }, False ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget LayerMsg SceneMsg Data
updaterec env msg data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    renderPanel env


htmlView : EnvFrontLayer -> Html msg
htmlView env =
    Html.div
        (genAttribute env.globalData ( 0, 30 ) ( 300, 600 )
            ++ [ style "background-color" "rgba(236, 240, 241, 0.65)"
               , style "line-height" "1.5"
               , style "overflow" "auto"
               , style "display"
                    (if env.commonData.state == Playing then
                        "none"

                     else
                        "block"
                    )
               , style "user-select" "none"
               ]
        )
        [ Markdown.toHtml [ style "padding" "0 15px" ]
            """
elm-tetris is a Tetris game coded in [**Elm**](http://elm-lang.org/) language.

          
Inspired by the classic [**Tetris**](http://en.wikipedia.org/wiki/Tetris)
game, the game can be played with a keyboard using the arrow keys,
and on mobile devices using the buttons below.

elm-tetris is a modified version of [**elm-flatris**](https://github.com/w0rm/elm-flatris).
Beyond being ported to Elm 0.19.1, the code was cleaned up, and adjusted to fit SilverFOCS needs.

The source code was rewritten by using the Messenger game framework in 2024.
"""
        ]


renderPanel : EnvFrontLayer -> Renderable
renderPanel ({ commonData } as env) =
    Canvas.group []
        [ renderTextWithColor env.globalData 40 "Tetris" "Helvetica" (Color.rgb255 52 73 95) ( 350, 50 )
        , renderTextWithColor env.globalData 14 "Score" "Helvetica" (Color.rgb255 189 195 199) ( 350, 120 )
        , renderTextWithColor env.globalData 14 "Best Score" "Helvetica" (Color.rgb255 189 195 199) ( 430, 120 )
        , renderTextWithColor env.globalData 30 (String.fromInt env.globalData.userData.lastMaxScore) "Helvetica" (Color.rgb255 57 147 208) ( 430, 140 )
        , renderTextWithColor env.globalData 30 (String.fromInt commonData.score) "Helvetica" (Color.rgb255 57 147 208) ( 350, 140 )
        , renderTextWithColor env.globalData 14 "Lines Cleared" "Helvetica" (Color.rgb255 189 195 199) ( 350, 200 )
        , renderTextWithColor env.globalData 30 (String.fromInt commonData.lines) "Helvetica" (Color.rgb255 57 147 208) ( 350, 220 )
        , renderTextWithColor env.globalData 14 "Next Shape" "Helvetica" (Color.rgb255 189 195 199) ( 350, 280 )
        , renderNext env commonData.next
        ]


renderNext : EnvFrontLayer -> Grid Color -> Renderable
renderNext env grid =
    grid
        |> Grid.mapToList
            (\_ ( x, y ) ->
                rect env.globalData ( toFloat <| x * 30 + 350, toFloat <| y * 30 + 310 ) ( 30, 30 )
            )
        |> Canvas.shapes [ fill (Color.rgb255 200 240 241) ]


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "FrontLayer"


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
