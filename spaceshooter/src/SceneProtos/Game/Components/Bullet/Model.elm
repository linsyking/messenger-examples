module SceneProtos.Game.Components.Bullet.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (roundRect)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget(..), emptyBaseData)
import SceneProtos.Game.SceneBase exposing (SceneCommonData)


type alias Data =
    { color : Color
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init _ initMsg =
    case initMsg of
        BulletInitMsg msg ->
            ( { color = msg.color }
            , { id = msg.id
              , position = msg.position
              , velocity = msg.velocity
              , alive = True
              , collisionBox = ( 20, 10 )
              , ty = "Bullet"
              }
            )

        _ ->
            ( { color = Color.black }, emptyBaseData )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        Tick dt ->
            let
                newBullet =
                    { basedata | position = ( Tuple.first basedata.position + basedata.velocity * toFloat dt, Tuple.second basedata.position ) }
            in
            ( ( data, newBullet ), [], ( env, False ) )

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
view { globalData } data basedata =
    ( Canvas.shapes [ fill data.color ]
        [ roundRect (posToReal globalData.internalData basedata.position) (lengthToReal globalData.internalData 20) (lengthToReal globalData.internalData 10) [ 10, 10, 10, 10 ]
        ]
    , 0
    )


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
