module SceneProtos.SimpleGame.GameLayer.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| This is the doc for this module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Array exposing (Array)
import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent, GameComponentInitData(..), GameComponentMsg(..))
import SceneProtos.SimpleGame.GameComponent.Handler exposing (update, updateGC, viewGC)
import SceneProtos.SimpleGame.GameLayer.Common exposing (EnvC, Model, nullModel)
import SceneProtos.SimpleGame.LayerInit exposing (LayerInitData(..))


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel _ i =
    case i of
        GameLayerInitData x ->
            x

        _ ->
            nullModel


detectCollision : Array GameComponent -> Array GameComponent
detectCollision newgcs =
    Array.foldl
        (\gc lastGC ->
            let
                x =
                    Tuple.first gc.data.position

                y =
                    Tuple.second gc.data.position

                r =
                    gc.data.radius

                gcd =
                    gc.data

                newgc =
                    if x - r < 0 then
                        { gc | data = { gcd | velocity = ( -1 * Tuple.first gc.data.velocity, Tuple.second gc.data.velocity ), position = ( r, y ) } }

                    else if x + r > 1920 then
                        { gc | data = { gcd | velocity = ( -1 * Tuple.first gc.data.velocity, Tuple.second gc.data.velocity ), position = ( 1920 - r, y ) } }

                    else if y - r < 0 then
                        { gc | data = { gcd | velocity = ( Tuple.first gc.data.velocity, -1 * Tuple.second gc.data.velocity ), position = ( x, r ) } }

                    else if y + r > 1080 then
                        { gc | data = { gcd | velocity = ( Tuple.first gc.data.velocity, -1 * Tuple.second gc.data.velocity ), position = ( x, 1080 - r ) } }

                    else
                        gc
            in
            Array.push newgc lastGC
        )
        Array.empty
        newgcs


distance : ( Int, Int ) -> ( Int, Int ) -> Float
distance ( x1, y1 ) ( x2, y2 ) =
    let
        x =
            toFloat (x2 - x1)

        y =
            toFloat (y2 - y1)
    in
    sqrt (x * x + y * y)


checkEat : EnvC -> Array GameComponent -> Maybe GameComponent -> ( Array GameComponent, Maybe GameComponent )
checkEat env newgcs bh =
    case bh of
        Nothing ->
            ( newgcs, Nothing )

        Just blackhole ->
            let
                ( xs, bl ) =
                    Array.foldl
                        (\gc ( lastGC, lastBlackhole ) ->
                            let
                                ( bh2, _, _ ) =
                                    update blackhole
                                        env
                                        (GCEatMsg gc.data.radius)
                            in
                            if floor (distance gc.data.position blackhole.data.position) + gc.data.radius < lastBlackhole.data.radius then
                                -- Eaten
                                ( lastGC, bh2 )

                            else
                                ( Array.push gc lastGC, lastBlackhole )
                        )
                        ( Array.empty, blackhole )
                        newgcs
            in
            ( xs, Just bl )


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    let
        ( gc1, _, env1 ) =
            updateGC env model.balls

        ( gc2, bh ) =
            checkEat env (detectCollision gc1) model.blackhole
    in
    ( { model | balls = gc2, blackhole = bh }, [], env1 )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    viewGC env <|
        case model.blackhole of
            Just bh ->
                Array.push bh model.balls

            Nothing ->
                model.balls
