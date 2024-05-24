module SceneProtos.Game.Main.Model exposing (layer)

{-| Layer configuration module

Set the Data Type, Init logic, Update logic, View logic and Matcher logic here.

@docs layer

-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.Component exposing (AbstractComponent, updateComponentsWithBlock, updateComponentsWithTarget, viewComponents)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..), unroll)
import Messenger.Layer.Layer exposing (ConcreteLayer, Handler, LayerInit, LayerStorage, LayerUpdate, LayerUpdateRec, LayerView, genLayer, handleComponentMsgs)
import Messenger.Layer.LayerExtra exposing (BasicUpdater, Distributor)
import SceneProtos.Game.Components.Bullet.Model as Bullet
import SceneProtos.Game.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import SceneProtos.Game.LayerBase exposing (..)
import SceneProtos.Game.Main.Collision exposing (judgeCollision)


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


updateBasic : BasicUpdater Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg
updateBasic env evt data =
    ( { data | components = removeOutOfBound <| removeDead data.components }, [], ( env, False ) )


collisionDistributor : Distributor Data SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg (List ( ComponentTarget, ComponentMsg ))
collisionDistributor env evt data =
    ( data, ( [], judgeCollision data.components ), env )


update : LayerUpdate SceneCommonData UserData LayerTarget (LayerMsg SceneMsg) SceneMsg Data
update env evt data =
    let
        ( data1, lmsg1, ( env1, block1 ) ) =
            updateBasic env evt data

        ( comps1, cmsgs1, ( env2, block2 ) ) =
            updateComponentsWithBlock env1 evt block1 data1.components

        ( data2, ( lmsg2, tocmsg ), env3 ) =
            collisionDistributor env2 evt { data1 | components = comps1 }

        ( comps2, cmsgs2, env4 ) =
            updateComponentsWithTarget env3 tocmsg data2.components

        ( data3, lmsgs3, env5 ) =
            handleComponentMsgs env4 (cmsgs2 ++ cmsgs1) { data2 | components = comps2 } (lmsg1 ++ lmsg2) handleComponentMsg
    in
    ( data3, lmsgs3, ( env5, block2 ) )


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
