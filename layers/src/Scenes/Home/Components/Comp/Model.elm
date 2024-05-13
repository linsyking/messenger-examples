module Scenes.Home.Components.Comp.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (shapes)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (WorldEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Coordinate.Coordinates exposing (judgeMouseRect)
import Messenger.Render.Shape exposing (rect)
import Scenes.Home.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Home.LayerBase exposing (SceneCommonData)


type alias Data =
    { left : Float
    , top : Float
    , width : Float
    , height : Float
    , color : Color
    , id : Int
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        RectangleInit initData ->
            ( initData, () )

        _ ->
            ( Data 0 0 0 0 Color.black 0, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    case evnt of
        MouseDown 0 pos ->
            if judgeMouseRect pos ( data.left, data.top ) ( data.width, data.height ) then
                ( ( { data | color = Color.black }, basedata ), [], ( env, True ) )

            else
                ( ( data, basedata ), [], ( env, False ) )

        _ ->
            ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    ( ( data, basedata ), [], env )


view : ComponentView SceneCommonData UserData Data BaseData
view env data basedata =
    ( shapes
        [ fill data.color
        ]
        [ rect env.globalData ( data.left, data.top ) ( data.width, data.height ) ]
    , 0
    )


matcher : ComponentMatcher Data BaseData ComponentTarget
matcher data basedata tar =
    tar == data.id


componentcon : ConcreteUserComponent Data SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Exported component
-}
component : ComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component =
    genComponent componentcon
