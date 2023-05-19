module SceneProtos.CoreEngine.GameComponents.Enemy.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

import Canvas exposing (Renderable)
import Color
import Dict
import Lib.Component.Base exposing (DefinedTypes(..))
import Lib.Coordinate.Coordinates exposing (floored)
import Lib.DefinedTypes.Parser exposing (dFloatGet, dIntGet)
import Lib.Env.Env exposing (Env, EnvC)
import Lib.Render.Render exposing (renderSprite)
import SceneProtos.CoreEngine.GameComponent.Base exposing (Data, GameComponentInitData(..), GameComponentMsg(..), GameComponentTarget(..))
import SceneProtos.CoreEngine.GameComponents.Bullet.Base exposing (Bullet)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> GameComponentInitData -> Data
initModel _ initData =
    case initData of
        GCIdData id (GCEnemyInitData enemy) ->
            { uid = id
            , position = enemy.position
            , velocity = enemy.velocity
            , alive = True
            , collisionBox = ( 150, 50 )
            , extra =
                Dict.fromList
                    [ ( "bullet", CDInt enemy.bulletInterval )
                    , ( "F", CDFloat enemy.sinF )
                    , ( "A", CDFloat enemy.sinA )
                    ]
            }

        _ ->
            { uid = 0
            , position = ( 0, 0 )
            , velocity = 0
            , alive = True
            , collisionBox = ( 0, 0 )
            , extra = Dict.empty
            }


{-| updateModel

Add your component logic here.

-}
updateModel : EnvC CommonData -> GameComponentMsg -> Data -> ( Data, List ( GameComponentTarget, GameComponentMsg ), EnvC CommonData )
updateModel env msg d =
    if not d.alive then
        ( d, [], env )

    else
        case msg of
            GCCollisionMsg "Bullet" ->
                ( { d | alive = False }, [], env )

            _ ->
                let
                    sina =
                        dFloatGet d.extra "A"

                    sinf =
                        dFloatGet d.extra "F"

                    interval =
                        dIntGet d.extra "bullet"

                    velx =
                        sin (toFloat env.t / sinf) * sina

                    ( x, y ) =
                        d.position

                    newEnemy =
                        { d | position = ( x + d.velocity, y + velx * d.velocity ) }
                in
                if modBy interval env.t == 0 then
                    -- Generate a new bullet
                    ( newEnemy, [ ( GCParent, GCNewBulletMsg (Bullet -10 ( x - 50, y + 5 ) Color.red) ) ], env )

                else
                    ( newEnemy, [], env )


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
    renderSprite gd [] (floored data.position) (floored data.collisionBox) "enemy"
