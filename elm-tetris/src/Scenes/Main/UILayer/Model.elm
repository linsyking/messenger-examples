module Scenes.Main.UILayer.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| This is the doc for this module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Array
import Base exposing (Msg(..))
import Canvas exposing (Renderable)
import Color
import Components.Button.Export as Button
import Html exposing (Html)
import Html.Attributes exposing (style)
import Lib.Component.Base exposing (ComponentInitData(..), ComponentMsg(..), ComponentTarget(..))
import Lib.Component.ComponentHandler exposing (recBody, updateComponents, viewComponent)
import Lib.Coordinate.HTML exposing (genAttribute)
import Lib.Env.Env exposing (addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Tetris.Base exposing (TetrisEvent(..))
import Markdown
import Messenger.RecursionArray exposing (updateObjectByIndex)
import Scenes.Main.LayerBase exposing (LayerInitData, State(..), setState)
import Scenes.Main.UILayer.Common exposing (EnvC, Model)


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel env _ =
    { components =
        Array.fromList
            [ Button.initComponent (noCommonData env) <|
                ComponentID 0 <|
                    ComponentButtonMsg
                        { position = ( 350, 550 )
                        , textColor = Color.white
                        , size = ( 120, 50 )
                        , text =
                            "New Game"
                        , background = Color.darkBlue
                        }
                        ComponentParentLayer
                        (ComponentStringMsg
                            "Start"
                        )
            , Button.initComponent (noCommonData env) <|
                ComponentID 1 <|
                    ComponentButtonMsg
                        { position = ( 10, 650 )
                        , textColor = Color.black
                        , size = ( 50, 50 )
                        , text = "↻"
                        , background = Color.rgb255 236 240 241
                        }
                        ComponentParentLayer
                        (ComponentStringMsg "Rotate")
            , Button.initComponent (noCommonData env) <|
                ComponentID 2 <|
                    ComponentButtonMsg
                        { position = ( 80, 650 )
                        , textColor = Color.black
                        , size = ( 50, 50 )
                        , text = "←"
                        , background = Color.rgb255 236 240 241
                        }
                        ComponentParentLayer
                        (ComponentStringMsg "Left")
            , Button.initComponent (noCommonData env) <|
                ComponentID 3 <|
                    ComponentButtonMsg
                        { position = ( 150, 650 )
                        , textColor = Color.black
                        , size = ( 50, 50 )
                        , text = "→"
                        , background = Color.rgb255 236 240 241
                        }
                        ComponentParentLayer
                        (ComponentStringMsg "Right")
            , Button.initComponent (noCommonData env) <|
                ComponentID 4 <|
                    ComponentButtonMsg
                        { position = ( 220, 650 )
                        , textColor = Color.black
                        , size = ( 50, 50 )
                        , text = "↓"
                        , background = Color.rgb255 236 240 241
                        }
                        ComponentParentLayer
                        (ComponentStringMsg "Accelerate")
            ]
    }


updateButtonText : EnvC -> Model -> String -> String -> Model
updateButtonText env model s s2 =
    let
        ( comp, _, _ ) =
            updateObjectByIndex recBody (noCommonData env) (ComponentStringMsg s) 0 model.components

        ( comp2, _, _ ) =
            updateObjectByIndex recBody (noCommonData env) (ComponentMsgMsg (ComponentStringMsg s2)) 0 comp
    in
    { model | components = comp2 }


{-| Handle component messages (that are sent to this layer).
-}
handleComponentMsg : EnvC -> ComponentMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
handleComponentMsg env cmsg model =
    case cmsg of
        ComponentStringMsg "Start" ->
            ( updateButtonText env model "Pause" "Pause", [ ( LayerName "GameLayer", LayerTetrisMsg Start ) ], { env | commonData = setState Playing env.commonData } )

        ComponentStringMsg "Pause" ->
            ( updateButtonText env model "Resume" "Resume", [ ( LayerName "GameLayer", LayerTetrisMsg Pause ) ], { env | commonData = setState Paused env.commonData } )

        ComponentStringMsg "Resume" ->
            ( updateButtonText env model "Pause" "Pause", [ ( LayerName "GameLayer", LayerTetrisMsg Resume ) ], { env | commonData = setState Playing env.commonData } )

        ComponentStringMsg "Release" ->
            ( model, [ ( LayerName "GameLayer", LayerTetrisMsg CancelAll ) ], env )

        ComponentStringMsg "Left" ->
            ( model, [ ( LayerName "GameLayer", LayerTetrisMsg (MoveLeft True) ) ], env )

        ComponentStringMsg "Right" ->
            ( model, [ ( LayerName "GameLayer", LayerTetrisMsg (MoveRight True) ) ], env )

        ComponentStringMsg "Rotate" ->
            ( model, [ ( LayerName "GameLayer", LayerTetrisMsg (Rotate True) ) ], env )

        ComponentStringMsg "Accelerate" ->
            ( model, [ ( LayerName "GameLayer", LayerTetrisMsg (Accelerate True) ) ], env )

        _ ->
            ( model, [], env )


htmlView : EnvC -> Html msg
htmlView env =
    Html.div
        (genAttribute env.globalData ( 0, 30 ) ( 300, 600 )
            ++ [ style "background-color" "rgba(236, 240, 241, 0.35)"
               , style "line-height" "1.5"
               , style "overflow" "auto"
               , style "display"
                    (if env.commonData.state == Playing then
                        "none"

                     else
                        "block"
                    )
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

The source code was rewritten by using the Messenger game framework in 2023.
"""
        ]


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env lmsg model =
    let
        components =
            model.components

        ( newComponents, newMsg, newEnv ) =
            updateComponents (noCommonData env) components

        model2 =
            { model | components = newComponents }

        gd =
            newEnv.globalData

        newgd =
            { gd | extraHTML = Just <| htmlView env }

        newMsg2 =
            case env.msg of
                KeyDown 37 ->
                    [ ComponentStringMsg "Left" ]

                KeyDown 39 ->
                    [ ComponentStringMsg "Right" ]

                KeyDown 40 ->
                    [ ComponentStringMsg "Accelerate" ]

                KeyDown 38 ->
                    [ ComponentStringMsg "Rotate" ]

                KeyUp _ ->
                    [ ComponentStringMsg "Release" ]

                MouseUp _ ->
                    [ ComponentStringMsg "Release" ]

                _ ->
                    newMsg

        model3 =
            case lmsg of
                LayerTetrisMsg GameOver ->
                    updateButtonText env model2 "New Game" "Start"

                _ ->
                    model2
    in
    List.foldl
        (\cTMsg ( m, cmsg, cenv ) ->
            let
                ( nm, nmsg, nenv ) =
                    handleComponentMsg cenv cTMsg m
            in
            ( nm, nmsg ++ cmsg, nenv )
        )
        ( model3, [], addCommonData env.commonData { newEnv | globalData = newgd } )
        newMsg2


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    viewComponent (noCommonData env) model.components
