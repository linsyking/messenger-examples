module SceneProtos.CoreEngine.GameComponents.Bullet.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

import Canvas exposing (Renderable, roundRect, shapes)
import Canvas.Settings exposing (fill)
import Dict
import Lib.Component.Base exposing (DefinedTypes(..))
import Lib.Coordinate.Coordinates exposing (floored, posToReal, widthToReal)
import Lib.DefinedTypes.Parser exposing (dColorGet)
import Lib.Env.Env exposing (Env, EnvC)
import SceneProtos.CoreEngine.GameComponent.Base exposing (Data, GameComponentInitData(..), GameComponentMsg, GameComponentTarget)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> GameComponentInitData -> Data
initModel _ initData =
    case initData of
        GCIdData id (GCBulletInitData bullet) ->
            { uid = id
            , position = bullet.position
            , velocity = bullet.velocity
            , collisionBox = ( 20, 10 )
            , extra =
                Dict.fromList
                    [ ( "color", CDColor bullet.color )
                    ]
            }

        _ ->
            { uid = 0
            , position = ( 0, 0 )
            , velocity = ( 0, 0 )
            , collisionBox = ( 0, 0 )
            , extra = Dict.empty
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
    let
        color =
            dColorGet data.extra "color"

        gd =
            env.globalData
    in
    shapes [ fill color ]
        [ roundRect (posToReal gd (floored data.position)) (widthToReal gd 20) (widthToReal gd 10) [ 5, 5, 5, 5 ]
        ]
