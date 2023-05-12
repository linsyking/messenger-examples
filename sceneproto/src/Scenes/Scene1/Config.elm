module Scenes.Scene1.Config exposing (..)

import Array exposing (Array)
import Color
import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (SceneTMsg)
import Lib.Tools.RNG exposing (genRandomListInt)
import List.Extra exposing (zip, zip3)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent, GameComponentInitData(..))
import SceneProtos.SimpleGame.GameComponents.Ball.Export as Ball
import SceneProtos.SimpleGame.GameComponents.Blackhole.Export as Blackhole


initBalls : Env -> SceneTMsg -> Array GameComponent
initBalls env _ =
    let
        num =
            200

        speed =
            5

        rdh =
            genRandomListInt env.t num ( 100, 980 )

        rdw =
            genRandomListInt env.t num ( 100, 1820 )

        rdx =
            genRandomListInt env.t num ( -speed, speed )

        rdy =
            genRandomListInt (env.t + 1) num ( -speed, speed )

        rdr =
            genRandomListInt env.t num ( 5, 20 )

        rd =
            zip3 (zip rdw rdh) (zip rdx rdy) rdr
    in
    Array.fromList <|
        List.map
            (\( ( x, y ), ( x2, y2 ), r ) ->
                Ball.initGC env <|
                    GCIdData 1 <|
                        GCBallInitData
                            { position = ( x, y )
                            , velocity = ( x2, y2 )
                            , radius = r
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
