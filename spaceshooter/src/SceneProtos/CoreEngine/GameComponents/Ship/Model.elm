module SceneProtos.CoreEngine.GameComponents.Ship.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

import Base exposing (Msg(..))
import Canvas exposing (Renderable, group, shapes)
import Canvas.Settings exposing (fill)
import Color
import Dict
import Lib.Component.Base exposing (DefinedTypes(..))
import Lib.Coordinate.Coordinates exposing (floored)
import Lib.DefinedTypes.Parser exposing (dIntGet)
import Lib.Env.Env exposing (Env, EnvC)
import Lib.Render.Render exposing (renderSprite)
import Lib.Render.Shape exposing (rect)
import Lib.Tools.KeyCode exposing (arrowDown, arrowUp)
import SceneProtos.CoreEngine.GameComponent.Base exposing (Data, GameComponentInitData(..), GameComponentMsg(..), GameComponentTarget(..))
import SceneProtos.CoreEngine.GameComponents.Bullet.Base exposing (Bullet)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> GameComponentInitData -> Data
initModel _ initData =
    case initData of
        GCIdData id (GCShipInitData ship) ->
            { uid = id
            , position = ship.position
            , velocity = 0
            , collisionBox = ( 150, 50 )
            , alive = True
            , extra =
                Dict.fromList
                    [ ( "bullet", CDInt ship.interval )
                    ]
            }

        _ ->
            { uid = 0
            , position = ( 0, 0 )
            , velocity = 0
            , collisionBox = ( 0, 0 )
            , alive = True
            , extra = Dict.empty
            }


{-| updateModel

Add your component logic here.

-}
updateModel : EnvC CommonData -> GameComponentMsg -> Data -> ( Data, List ( GameComponentTarget, GameComponentMsg ), EnvC CommonData )
updateModel env gcmsg d =
    if not d.alive then
        ( d, [], env )

    else
        case gcmsg of
            GCCollisionMsg _ ->
                ( { d | alive = False }, [ ( GCParent, GCGameOverMsg ) ], env )

            _ ->
                let
                    ( x, y ) =
                        d.position

                    interval =
                        dIntGet d.extra "bullet"
                in
                case env.msg of
                    KeyDown key ->
                        if key == arrowDown then
                            ( { d | position = ( x, y + 20 ) }, [], env )

                        else if key == arrowUp then
                            ( { d | position = ( x, y - 20 ) }, [], env )

                        else
                            ( d, [], env )

                    _ ->
                        if modBy interval env.t == 0 then
                            -- Generate a new bullet
                            ( d, [ ( GCParent, GCNewBulletMsg (Bullet 10 ( x + 170, y + 20 ) Color.blue) ) ], env )

                        else
                            ( d, [], env )


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
    group []
        [ shapes [ fill Color.white ]
            [ rect gd (floored data.position) (floored data.collisionBox)
            ]
        , renderSprite gd [] (floored data.position) (floored data.collisionBox) "ship"
        ]
