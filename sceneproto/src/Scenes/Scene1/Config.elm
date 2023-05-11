module Scenes.Scene1.Config exposing (..)

import Array exposing (Array)
import Color
import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import Lib.Tools.RNG exposing (genRandomListInt)
import List.Extra exposing (zip)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent, GameComponentInitData(..))
import SceneProtos.SimpleGame.GameComponents.Ball.Export as Ball
import SceneProtos.SimpleGame.GameComponents.Blackhole.Export as Blackhole


initBalls : Env -> SceneTMsg -> Array GameComponent
initBalls env _ =
    let
        num =
            500

        speed =
            10

        rdh =
            genRandomListInt env.t num ( 100, 980 )

        rdw =
            genRandomListInt env.t num ( 100, 1820 )

        rdx =
            genRandomListInt env.t num ( -speed, speed )

        rdy =
            genRandomListInt (env.t + 1) num ( -speed, speed )

        rd =
            zip (zip rdw rdh) (zip rdx rdy)
    in
    Array.fromList <|
        List.map
            (\( ( x, y ), ( x2, y2 ) ) ->
                Ball.initGC env <|
                    GCIdData 1 <|
                        GCBallInitData
                            { position = ( x, y )
                            , velocity = ( x2, y2 )
                            , radius = 5
                            , color = Color.red
                            }
            )
            rd


initBlackhole : Env -> SceneTMsg -> Maybe GameComponent
initBlackhole env _ =
    Just <|
        Blackhole.initGC env <|
            GCIdData 0 <|
                NullGCInitData
