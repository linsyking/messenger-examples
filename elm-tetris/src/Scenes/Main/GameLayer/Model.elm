module Scenes.Main.GameLayer.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| This is the doc for this module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Base exposing (Msg(..))
import Canvas exposing (Renderable, group, shapes)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Lib.Component.Base exposing (ComponentMsg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Render exposing (renderTextWithColor)
import Lib.Render.Shape exposing (rect)
import Lib.Tetris.Base exposing (TetrisEvent(..))
import Lib.Tetris.Grid as Grid
import Lib.Tetris.Tetriminos as Tetriminos
import Scenes.Main.GameLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Main.LayerBase exposing (LayerInitData, State(..), setState)
import Scenes.Main.UILayer.Common exposing (EnvC)


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel env _ =
    { nullModel
        | score = env.globalData.localstorage.maxScore
        , next = Tetriminos.random env.globalData.localstorage.maxScore
    }


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env msg model =
    case msg of
        LayerTetrisMsg event ->
            case event of
                Start ->
                    ( spawnTetrimino env
                        { model
                            | lines = 0
                            , score = 0
                            , grid = Grid.empty
                        }
                    , []
                    , { env | commonData = setState Playing env.commonData }
                    )

                Pause ->
                    ( model, [], { env | commonData = setState Paused env.commonData } )

                Resume ->
                    ( model
                    , []
                    , { env | commonData = setState Playing env.commonData }
                    )

                CancelAll ->
                    ( { model | moveLeft = False, moveRight = False, rotation = Nothing, acceleration = False }, [], env )

                MoveLeft on ->
                    ( startMove { model | moveLeft = on }
                    , []
                    , env
                    )

                MoveRight on ->
                    ( startMove { model | moveRight = on }
                    , []
                    , env
                    )

                Rotate False ->
                    ( { model | rotation = Nothing }
                    , []
                    , env
                    )

                Rotate True ->
                    ( { model | rotation = Just { active = True, elapsed = 0 } }
                    , []
                    , env
                    )

                Accelerate on ->
                    ( { model | acceleration = on }
                    , []
                    , env
                    )

                GameOver ->
                    ( model, [], env )

        _ ->
            case env.msg of
                Tick _ ->
                    let
                        gd =
                            env.globalData

                        ls =
                            gd.localstorage

                        newLS =
                            { ls
                                | maxScore = max ls.maxScore model.score
                            }

                        newGD =
                            { gd | localstorage = newLS }

                        newEnv =
                            { env | globalData = newGD }
                    in
                    if env.commonData.state == Playing then
                        animate 15 newEnv model

                    else
                        ( model, [], newEnv )

                _ ->
                    ( model, [], env )


animate : Float -> EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
animate elapsed env model =
    checkEndGame env
        (model
            |> moveTetrimino elapsed
            |> rotateTetrimino elapsed
            |> dropTetrimino env elapsed
        )


direction : Model -> Int
direction { moveLeft, moveRight } =
    case ( moveLeft, moveRight ) of
        ( True, False ) ->
            -1

        ( False, True ) ->
            1

        _ ->
            0


startMove : Model -> Model
startMove model =
    if direction model /= 0 then
        { model | direction = Just { active = True, elapsed = 0 } }

    else
        { model | direction = Nothing }


moveTetrimino : Float -> Model -> Model
moveTetrimino elapsed model =
    case model.direction of
        Just state ->
            { model | direction = Just (activateButton 150 elapsed state) }
                |> (if state.active then
                        moveTetrimino_ (direction model)

                    else
                        identity
                   )

        Nothing ->
            model


moveTetrimino_ : Int -> Model -> Model
moveTetrimino_ dx model =
    let
        ( x, y ) =
            model.position

        x_ =
            x + dx
    in
    if Grid.collide model.width model.height x_ (floor y) model.active model.grid then
        model

    else
        { model | position = ( x_, y ) }


activateButton : Float -> Float -> { a | active : Bool, elapsed : Float } -> { a | active : Bool, elapsed : Float }
activateButton interval elapsed state =
    let
        elapsed_ =
            state.elapsed + elapsed
    in
    if elapsed_ > interval then
        { state | active = True, elapsed = elapsed_ - interval }

    else
        { state | active = False, elapsed = elapsed_ }


rotateTetrimino : Float -> Model -> Model
rotateTetrimino elapsed model =
    case model.rotation of
        Just rotation ->
            { model | rotation = Just (activateButton 300 elapsed rotation) }
                |> (if rotation.active then
                        rotateTetrimino_

                    else
                        identity
                   )

        Nothing ->
            model


rotateTetrimino_ : Model -> Model
rotateTetrimino_ model =
    let
        ( x, y ) =
            model.position

        rotated =
            Grid.rotate True model.active

        shiftPosition deltas =
            case deltas of
                dx :: remainingDeltas ->
                    if Grid.collide model.width model.height (x + dx) (floor y) rotated model.grid then
                        shiftPosition remainingDeltas

                    else
                        { model
                            | active = rotated
                            , position = ( x + dx, y )
                        }

                [] ->
                    model
    in
    shiftPosition [ 0, 1, -1, 2, -2 ]


checkEndGame : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
checkEndGame env model =
    if List.any identity (Grid.mapToList (\_ ( _, y ) -> y < 0) model.grid) then
        ( model, [ ( LayerName "UILayer", LayerTetrisMsg GameOver ) ], { env | commonData = setState Stopped env.commonData } )

    else
        ( model, [], env )


spawnTetrimino : EnvC -> Model -> Model
spawnTetrimino env model =
    let
        next =
            Tetriminos.random env.t

        ( x, y ) =
            Grid.initPosition model.width model.next
    in
    { model
        | next = next
        , active = model.next
        , position = ( x, toFloat y )
    }


dropTetrimino : EnvC -> Float -> Model -> Model
dropTetrimino env elapsed model =
    let
        ( x, y ) =
            model.position

        speed =
            if model.acceleration then
                25

            else
                max 25 (800 - 25 * toFloat (level model - 1))

        y_ =
            y + elapsed / speed
    in
    if Grid.collide model.width model.height x (floor y_) model.active model.grid then
        let
            score =
                List.length (Grid.mapToList (\_ _ _ -> True) model.active)
        in
        { model
            | grid = Grid.stamp x (floor y) model.active model.grid
            , score =
                model.score
                    + score
                    * (if model.acceleration then
                        2

                       else
                        1
                      )
        }
            |> spawnTetrimino env
            |> clearLines

    else
        { model | position = ( x, y_ ) }


clearLines : Model -> Model
clearLines model =
    let
        ( grid, lines ) =
            Grid.clearLines model.width model.grid

        bonus =
            case lines of
                0 ->
                    0

                1 ->
                    100

                2 ->
                    300

                3 ->
                    500

                _ ->
                    800
    in
    { model
        | grid = grid
        , score = model.score + bonus * level model
        , lines = model.lines + lines
    }


level : Model -> Int
level model =
    model.lines // 10 + 1


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group []
        [ renderWell env model
        , renderPanel env
            model
        , shapes [ fill Color.white ]
            [ rect env.globalData ( 0, 0 ) ( 600, 30 )
            ]
        ]


renderBox : EnvC -> (Color -> Color) -> Color -> ( Int, Int ) -> Renderable
renderBox env fun c ( x, y ) =
    shapes [ fill (fun c) ]
        [ rect env.globalData ( x * 30, y * 30 + 30 ) ( 30, 30 )
        ]


renderPanel : EnvC -> Model -> Renderable
renderPanel env model =
    group []
        [ renderTextWithColor env.globalData 40 "Tetris" "Helvetica" (Color.rgb255 52 73 95) ( 350, 50 )
        , renderTextWithColor env.globalData 14 "Score" "Helvetica" (Color.rgb255 189 195 199) ( 350, 120 )
        , renderTextWithColor env.globalData 14 "Best Score" "Helvetica" (Color.rgb255 189 195 199) ( 430, 120 )
        , renderTextWithColor env.globalData 30 (String.fromInt env.globalData.localstorage.maxScore) "Helvetica" (Color.rgb255 57 147 208) ( 430, 140 )
        , renderTextWithColor env.globalData 30 (String.fromInt model.score) "Helvetica" (Color.rgb255 57 147 208) ( 350, 140 )
        , renderTextWithColor env.globalData 14 "Lines Cleared" "Helvetica" (Color.rgb255 189 195 199) ( 350, 200 )
        , renderTextWithColor env.globalData 30 (String.fromInt model.lines) "Helvetica" (Color.rgb255 57 147 208) ( 350, 220 )
        , renderTextWithColor env.globalData 14 "Next Shape" "Helvetica" (Color.rgb255 189 195 199) ( 350, 280 )
        , renderNext env model.next
        ]


renderNext : EnvC -> Grid.Grid Color -> Renderable
renderNext env grid =
    grid
        |> Grid.mapToList
            (\_ ( x, y ) ->
                rect env.globalData ( x * 30 + 350, y * 30 + 310 ) ( 30, 30 )
            )
        |> shapes [ fill (Color.rgb255 200 240 241) ]


renderWell : EnvC -> Model -> Renderable
renderWell env { width, height, active, grid, position } =
    group []
        (grid
            |> Grid.stamp (Tuple.first position) (floor (Tuple.second position)) active
            |> Grid.mapToList (renderBox env identity)
            |> (::)
                (shapes [ fill (Color.rgb255 236 240 241) ] [ rect env.globalData ( 0, 30 ) ( width * 30, height * 30 ) ])
        )
