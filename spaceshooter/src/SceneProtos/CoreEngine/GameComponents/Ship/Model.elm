module SceneProtos.CoreEngine.GameComponents.Ship.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

import Canvas exposing (Renderable, shapes)
import Canvas.Settings exposing (fill)
import Color
import Dict
import Lib.Component.Base exposing (DefinedTypes(..))
import Lib.Coordinate.Coordinates exposing (floored)
import Lib.Env.Env exposing (Env, EnvC)
import Lib.Render.Shape exposing (rect)
import SceneProtos.CoreEngine.GameComponent.Base exposing (Data, GameComponentInitData(..), GameComponentMsg, GameComponentTarget)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> GameComponentInitData -> Data
initModel _ initData =
    case initData of
        GCIdData id (GCShipInitData ship) ->
            { uid = id
            , position = ship
            , velocity = ( 0, 0 )
            , collisionBox = ( 100, 50 )
            , extra = Dict.empty
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
        gd =
            env.globalData
    in
    shapes [ fill Color.blue ]
        [ rect gd (floored data.position) (floored data.collisionBox)
        ]
