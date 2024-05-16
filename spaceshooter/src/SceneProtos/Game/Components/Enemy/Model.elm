module SceneProtos.Game.Components.Enemy.Model exposing (component)

{-| Component model

@docs component

-}

import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Render.Sprite exposing (renderSprite)
import SceneProtos.Game.Components.Bullet.Init exposing (CreateInitData)
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget(..), emptyBaseData)
import SceneProtos.Game.LayerBase exposing (SceneCommonData)


type alias Data =
    { interval : Int
    , sinf : Float
    , sina : Float
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        EnemyInitMsg msg ->
            ( { interval = msg.bulletInterval, sinf = msg.sinF, sina = msg.sinA }
            , { id = msg.id
              , position = msg.position
              , velocity = msg.velocity
              , alive = True
              , collisionBox = ( 150, 50 )
              , ty = "Enemy"
              }
            )

        _ ->
            ( { interval = 0, sinf = 0, sina = 0 }, emptyBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick ->
            let
                velx =
                    sin (toFloat env.globalData.sceneStartTime / data.sinf) * data.sina

                ( x, y ) =
                    basedata.position

                newEnemy =
                    { basedata | position = ( x + basedata.velocity, y + velx * basedata.velocity ) }
            in
            if modBy data.interval env.globalData.sceneStartTime == 0 then
                -- Generate a new bullet
                ( ( data, newEnemy ), [ Parent <| OtherMsg <| NewBulletMsg (CreateInitData -10 ( x - 50, y + 5 ) Color.red) ], ( env, False ) )

            else
                ( ( data, newEnemy ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        CollisionMsg "Bullet" ->
            ( ( data, { basedata | alive = False } ), [], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( renderSprite env.globalData [] basedata.position basedata.collisionBox "enemy", 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == Type basedata.ty || tar == Id basedata.id


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Component generator
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
