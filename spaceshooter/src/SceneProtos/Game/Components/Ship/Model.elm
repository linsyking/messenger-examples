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
import SceneProtos.Game.SceneBase exposing (SceneCommonData)
import Set


type alias Data =
    { interval : Int
    , timer : Int
    }


moveShip : BaseData -> Int -> BaseData
moveShip d dt =
    let
        ( x, y ) =
            d.position
    in
    { d | position = ( x, y + d.velocity * toFloat dt ) }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init _ initMsg =
    case initMsg of
        ShipInitMsg msg ->
            ( { interval = msg.bulletInterval, timer = 15 }
            , { id = msg.id
              , position = msg.position
              , velocity = 0
              , alive = True
              , collisionBox = ( 150, 50 )
              , ty = "Ship"
              }
            )

        _ ->
            ( { interval = 0, timer = 15 }, emptyBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    if basedata.alive then
        case evnt of
            Tick dt ->
                if data.timer >= data.interval then
                    let
                        ( x, y ) =
                            basedata.position
                    in
                    -- Generate a new bullet
                    ( ( { data | timer = 0 }, moveShip basedata dt ), [ Parent <| OtherMsg <| NewBulletMsg (CreateInitData 1 ( x + 170, y + 20 ) Color.blue) ], ( env, False ) )

                else
                    ( ( { data | timer = data.timer + dt }, moveShip basedata dt ), [], ( env, False ) )

            KeyDown key ->
                let
                    v =
                        1 / 4

                    vModify =
                        toFloat env.commonData.score * 1 / 60 |> max (3 / 2)
                in
                if key == arrowDown then
                    ( ( data, { basedata | velocity = v + vModify } ), [], ( env, False ) )

                else if key == arrowUp then
                    ( ( data, { basedata | velocity = -v - vModify } ), [], ( env, False ) )

                else
                    ( ( data, basedata ), [], ( env, False ) )

            KeyUp key ->
                if (key == arrowDown || key == arrowUp) && Set.isEmpty env.globalData.pressedKeys then
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
view { globalData } _ basedata =
    ( renderSprite globalData.internalData [] basedata.position basedata.collisionBox "ship", 0 )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher _ basedata tar =
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
