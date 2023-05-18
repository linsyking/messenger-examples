module Scenes.Home.GameLayer.Model exposing
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
import Canvas exposing (Renderable, empty, group, shapes)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Lib.Component.Base exposing (ComponentMsg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Render exposing (renderText)
import Lib.Render.Shape exposing (rect)
import Lib.Tools.RNG exposing (genRandomInt)
import Scenes.Home.GameLayer.Common exposing (Dir(..), EnvC, Live_status(..), Model, Movable(..), nullModel)
import Scenes.Home.LayerBase exposing (LayerInitData)


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    let
        ( newModel, newEnv ) =
            update env model
    in
    ( newModel, [], newEnv )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group [] <|
        List.map
            (viewGrid env model)
            (range2d mapsize)
            ++ [ renderInfo env model.snake_state
               ]


update : EnvC -> Model -> ( Model, EnvC )
update env model =
    ( model, env )
        |> updateSnake
        |> updateFruit


updateSnake : ( Model, EnvC ) -> ( Model, EnvC )
updateSnake ( model, env ) =
    ( { model | move_timer = model.move_timer + 10 }
        |> timedForward
    , env
    )


timedForward : Model -> Model
timedForward model =
    let
        ( nbody, nstate ) =
            legalForward model.snake_body model.snake_dir model.snake_state model.fruit_pos
    in
    if model.move_timer >= 200 then
        { model | snake_body = nbody, snake_state = nstate, move_timer = 0 }

    else
        model


legalForward : List ( Int, Int ) -> Dir -> Live_status -> ( Int, Int ) -> ( List ( Int, Int ), Live_status )
legalForward body dir state fruitpos =
    case List.head body of
        Nothing ->
            ( body, state )

        Just oldhead ->
            let
                newhead =
                    headPos oldhead dir
            in
            ( forward body newhead fruitpos, state )


headPos : ( Int, Int ) -> Dir -> ( Int, Int )
headPos ( oldx, oldy ) dir =
    case dir of
        Up ->
            ( oldx, oldy - 1 )

        Down ->
            ( oldx, oldy + 1 )

        Right ->
            ( oldx + 1, oldy )

        Left ->
            ( oldx - 1, oldy )


headLegal : ( Int, Int ) -> List ( Int, Int ) -> Movable
headLegal ( x, y ) body =
    if x < 0 || x >= Tuple.first mapsize then
        Wall

    else if y < 0 || y >= Tuple.second mapsize then
        Wall

    else if List.member ( x, y ) body then
        Wall

    else
        Free


forward : List ( Int, Int ) -> ( Int, Int ) -> ( Int, Int ) -> List ( Int, Int )
forward body newhead fruitpos =
    if headLegal newhead body == Wall then
        body

    else if getFruit newhead fruitpos then
        body
            |> putHead newhead

    else
        body
            |> putHead newhead
            |> removeTail


getFruit : ( Int, Int ) -> ( Int, Int ) -> Bool
getFruit head fruit =
    fruit == head


putHead : ( Int, Int ) -> List ( Int, Int ) -> List ( Int, Int )
putHead newhead body =
    List.append [ newhead ] body


removeTail : List a -> List a
removeTail body =
    body
        |> List.reverse
        |> List.tail
        |> Maybe.withDefault []
        |> List.reverse


generateValidFruitPos : EnvC -> Model -> ( Int, Int )
generateValidFruitPos env _ =
    ( genRandomInt env.t ( 0, 9 ), genRandomInt (env.t + 1) ( 0, 9 ) )


updateFruit : ( Model, EnvC ) -> ( Model, EnvC )
updateFruit ( model, env ) =
    case env.msg of
        Tick _ ->
            if List.member model.fruit_pos model.snake_body then
                ( { model | fruit_pos = generateValidFruitPos env model }, env )

            else
                ( model, env )

        KeyDown 40 ->
            ( { model
                | snake_dir =
                    if model.snake_state == Alive then
                        Down

                    else
                        model.snake_dir
              }
            , env
            )

        KeyDown 38 ->
            ( { model
                | snake_dir =
                    if model.snake_state == Alive then
                        Up

                    else
                        model.snake_dir
              }
            , env
            )

        KeyDown 39 ->
            ( { model
                | snake_dir =
                    if model.snake_state == Alive then
                        Right

                    else
                        model.snake_dir
              }
            , env
            )

        KeyDown 37 ->
            ( { model
                | snake_dir =
                    if model.snake_state == Alive then
                        Left

                    else
                        model.snake_dir
              }
            , env
            )

        _ ->
            ( model, env )



--View


gridsize : Int
gridsize =
    50


mapsize : ( Int, Int )
mapsize =
    ( 12, 12 )


gridColor : Model -> ( Int, Int ) -> Color
gridColor model pos =
    if List.member pos model.snake_body then
        Color.black

    else if model.fruit_pos == pos then
        Color.red

    else
        Color.rgb255 230 250 230


viewGrid : EnvC -> Model -> ( Int, Int ) -> Renderable
viewGrid env model pos =
    let
        ( x, y ) =
            pos
    in
    shapes [ fill <| gridColor model pos ]
        [ rect env.globalData
            ( x * gridsize, y * gridsize )
            ( gridsize, gridsize )
        ]


range2d : ( Int, Int ) -> List ( Int, Int )
range2d size =
    let
        rangex =
            List.range 0 (Tuple.first size - 1)

        rangey =
            List.range 0 (Tuple.second size - 1)

        line =
            \y -> List.map (\x -> Tuple.pair x y) rangex
    in
    List.map line rangey
        |> List.concat


renderInfo : EnvC -> Live_status -> Renderable
renderInfo env state =
    if state == Alive then
        empty

    else
        renderText env.globalData 40 "You Dead!" "Arial" ( 200, 250 )
