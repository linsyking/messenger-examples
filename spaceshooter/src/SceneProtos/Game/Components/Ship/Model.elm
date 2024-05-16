module SceneProtos.Game.Components.Ship.Model exposing (component)

{-| Component model

@docs component

-}

import Color
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.GeneralModel exposing (Msg(..), MsgBase(..))
import Messenger.Misc.KeyCode exposing (arrowDown, arrowUp)
import Messenger.Render.Sprite exposing (renderSprite)
import SceneProtos.Game.Components.Bullet.Init exposing (CreateInitData)
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget(..), emptyBaseData)
import SceneProtos.Game.LayerBase exposing (SceneCommonData)


type alias Data =
    { interval : Int
    }


moveShip : BaseData -> BaseData
moveShip d =
    let
        ( x, y ) =
            d.position
    in
    { d | position = ( x, y + d.velocity ) }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        ShipInitMsg msg ->
            ( { interval = msg.bulletInterval }
            , { id = msg.id
              , position = msg.position
              , velocity = 0
              , alive = True
              , collisionBox = ( 150, 50 )
              , ty = "Ship"
              }
            )

        _ ->
            ( { interval = 0 }, emptyBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    if basedata.alive then
        case evnt of
            Tick ->
                if modBy data.interval env.globalData.sceneStartTime == 0 then
                    let
                        ( x, y ) =
                            basedata.position
                    in
                    -- Generate a new bullet
                    ( ( data, moveShip basedata ), [ Parent <| OtherMsg <| NewBulletMsg (CreateInitData 10 ( x + 170, y + 20 ) Color.blue) ], ( env, False ) )

                else
                    ( ( data, moveShip basedata ), [], ( env, False ) )

            KeyDown key ->
                if key == arrowDown then
                    ( ( data, { basedata | velocity = 10 } ), [], ( env, False ) )

                else if key == arrowUp then
                    ( ( data, { basedata | velocity = -10 } ), [], ( env, False ) )

                else
                    ( ( data, basedata ), [], ( env, False ) )

            KeyUp key ->
                if key == arrowDown || key == arrowUp then
                    ( ( data, { basedata | velocity = 0 } ), [], ( env, False ) )

                else
                    ( ( data, basedata ), [], ( env, False ) )

            _ ->
                ( ( data, basedata ), [], ( env, False ) )

    else
        ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        CollisionMsg _ ->
            ( ( data, { basedata | alive = False } ), [ Parent <| OtherMsg <| GameOverMsg ], env )

        _ ->
            ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( renderSprite env.globalData [] basedata.position basedata.collisionBox "ship", 0 )


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
