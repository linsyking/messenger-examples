module SceneProtos.SimpleGame.GameComponents.Ball.Ball exposing
    ( initModel
    , updateModel
    , viewModel
    )

import Canvas exposing (Renderable, shapes)
import Canvas.Settings exposing (fill)
import Color
import Lib.Env.Env exposing (Env, EnvC)
import Lib.Render.Shape exposing (circle)
import SceneProtos.SimpleGame.GameComponent.Base exposing (Data, GameComponentInitData(..), GameComponentMsg, GameComponentTarget)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> GameComponentInitData -> Data
initModel _ initData =
    case initData of
        GCIdData id (GCBallInitData ball) ->
            { uid = id
            , position = ball.position
            , color = ball.color
            , velocity = ball.velocity
            , radius = ball.radius
            }

        _ ->
            { uid = 0
            , position = ( 0, 0 )
            , color = Color.black
            , velocity = ( 0, 0 )
            , radius = 0
            }


{-| updateModel

Add your component logic here.

-}
updateModel : EnvC CommonData -> GameComponentMsg -> Data -> ( Data, List ( GameComponentTarget, GameComponentMsg ), EnvC CommonData )
updateModel env _ d =
    let
        newBall =
            { d | position = ( Tuple.first d.position + Tuple.first d.velocity, Tuple.second d.position + Tuple.second d.velocity ) }
    in
    ( newBall, [], env )


{-| viewModel

Change this to your own component view function.

If there is no view function, return Nothing.

-}
viewModel : EnvC CommonData -> Data -> Renderable
viewModel env data =
    shapes [ fill data.color ] [ circle env.globalData data.position data.radius ]
