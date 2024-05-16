module SceneProtos.Game.Main.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent, updateComponents, viewComponents)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..), unroll)
import Messenger.Layer.Layer exposing (ConcreteLayer, Handler, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer, handleComponentMsgs)
import SceneProtos.Game.Components.Bullet.Model as Bullet
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Game.LayerBase exposing (..)
import SceneProtos.Game.Main.Collision exposing (updateCollision)


type alias GameComponent =
    AbstractComponent SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg


{-| Remove dead objects
-}
removeDead : List GameComponent -> List GameComponent
removeDead =
    List.filter (\x -> (unroll x).baseData.alive)


{-| Generate a new ID
-}
genUID : List GameComponent -> Int
genUID xs =
    1 + (Maybe.withDefault 0 <| List.maximum (List.map (\x -> (unroll x).baseData.id) xs))


{-| Remove OoB objects
-}
removeOutOfBound : List GameComponent -> List GameComponent
removeOutOfBound =
    List.filter
        (\p ->
            let
                ( x, _ ) =
                    (unroll p).baseData.position
            in
            x > -200 && x < 2000
        )


type alias Data =
    { components : List GameComponent
    }


init : LayerInit SceneCommonData UserData (LayerMsg SceneMsg) Data
init env initMsg =
    case initMsg of
        MainInitData data ->
            Data data.components

        _ ->
            Data []


handleComponentMsg : Handler Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg ComponentMsg
handleComponentMsg env compmsg data =
    case compmsg of
        SOMMsg som ->
            ( data, [ Parent <| SOMMsg som ], env )

        OtherMsg msg ->
            case msg of
                NewBulletMsg initData ->
                    let
                        objs =
                            data.components

                        newBulletInitMsg =
                            BulletInitMsg
                                { id = genUID objs
                                , position = initData.position
                                , velocity = initData.velocity
                                , color = initData.color
                                }

                        newBullet =
                            Bullet.component newBulletInitMsg env

                        newObjs =
                            newBullet :: objs
                    in
                    ( { data | components = newObjs }, [], env )

                _ ->
                    ( data, [], env )


update : LayerUpdate SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
update env evt data =
    let
        comps0 =
            removeOutOfBound <| removeDead data.components

        ( comps1, msgs1, ( env1, block1 ) ) =
            updateComponents env evt comps0

        ( comps2, msgs2, env2 ) =
            updateCollision env1 comps1

        ( data1, msgs3, env3 ) =
            handleComponentMsgs env2 (msgs2 ++ msgs1) { data | components = comps2 } [] handleComponentMsg
    in
    ( data1, msgs3, ( env3, block1 ) )


updaterec : LayerUpdateRec SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
updaterec env msg data =
    ( data, [], env )


view : LayerView SceneCommonData UserData Data
view env data =
    viewComponents env data.components


matcher : Matcher Data LayerTarget
matcher data tar =
    tar == "Main"


layercon : ConcreteLayer Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
layercon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }


{-| Layer generator
-}
layer : LayerStorage SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
layer =
    genLayer layercon
