module SceneProtos.SimpleGame.GameComponents.Blackhole.Blackhole exposing (initModel, updateModel, viewModel)

{-| Blackhole

@docs initModel, updateModel, viewModel

-}

import Canvas exposing (Renderable, circle, shapes)
import Canvas.Settings exposing (fill)
import Color
import Lib.Coordinate.Coordinates exposing (posToReal, widthToReal)
import Lib.Env.Env exposing (Env, EnvC)
import SceneProtos.SimpleGame.GameComponent.Base exposing (Data, GameComponentInitData(..), GameComponentMsg, GameComponentTarget)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> GameComponentInitData -> Data
initModel _ initData =
    case initData of
        GCIdData id _ ->
            { uid = id
            , position = ( 960, 540 )
            , color = Color.black
            , velocity = ( 0, 0 )
            , radius = 30
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
    ( d, [], env )


{-| viewModel

Change this to your own component view function.

If there is no view function, return Nothing.

-}
viewModel : EnvC CommonData -> Data -> Renderable
viewModel env data =
    shapes [ fill Color.black ] [ circle (posToReal env.globalData data.position) (widthToReal env.globalData data.radius) ]
