module Scenes.Home.Components.Comp.Model exposing (component)

{-| Component model

@docs component

-}

import Canvas exposing (shapes)
import Canvas.Settings exposing (fill)
import Color exposing (Color, green)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Base exposing (WorldEvent(..))
import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent, genComponent)
import Messenger.Coordinate.Coordinates exposing (judgeMouseRect)
import Messenger.GeneralModel exposing (Msg(..))
import Messenger.Render.Shape exposing (rect)
import Scenes.Home.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Home.LayerBase exposing (SceneCommonData)


type alias Data =
    { left : Float
    , top : Float
    , width : Float
    , height : Float
    , color : Color
    }


init : ComponentInit SceneCommonData UserData ComponentMsg Data BaseData
init env initMsg =
    case initMsg of
        RectInit initData ->
            ( initData, () )

        _ ->
            ( Data 0 0 0 0 Color.black, () )


update : ComponentUpdate SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
update env evnt data basedata =
    ( ( data, basedata ), [], ( env, False ) )


updaterec : ComponentUpdateRec SceneCommonData Data UserData SceneMsg ComponentTarget ComponentMsg BaseData
updaterec env msg data basedata =
    case msg of
        RectMsg c ->
            ( ( { data | color = c }, basedata ), [], env )

        _ ->
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
    tar == "Rect"


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
