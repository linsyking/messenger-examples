module Scenes.Home.GameLayer.Global exposing
    ( dataToLDT
    , ldtToData
    , getLayerT
    )

{-| This is the doc for this module

@docs dataToLDT
@docs ldtToData
@docs getLayerT

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (Layer, LayerMsg, LayerTarget)
import Messenger.GeneralModel exposing (GeneralModel)
import Scenes.Home.GameLayer.Common exposing (Env)
import Scenes.Home.GameLayer.Export exposing (Data, nullData)
import Scenes.Home.LayerBase exposing (CommonData, LayerInitData)
import Scenes.Home.LayerSettings exposing (LayerDataType(..), LayerT)


{-| dataToLDT
-}
dataToLDT : Data -> LayerDataType
dataToLDT data =
    GameLayerData data


{-| ldtToData
-}
ldtToData : LayerDataType -> Data
ldtToData ldt =
    case ldt of
        GameLayerData x ->
            x

        _ ->
            nullData


{-| getLayerT
-}
getLayerT : Layer Data CommonData LayerInitData -> LayerT
getLayerT layer =
    let
        init : Env -> LayerInitData -> LayerDataType
        init env i =
            dataToLDT (layer.init env i)

        update : Env -> LayerMsg -> LayerDataType -> ( LayerDataType, List ( LayerTarget, LayerMsg ), Env )
        update env lm ldt =
            let
                ( rldt, newmsg, newenv ) =
                    layer.update env lm (ldtToData ldt)
            in
            ( dataToLDT rldt, newmsg, newenv )

        view : Env -> LayerDataType -> Renderable
        view env ldt =
            layer.view env (ldtToData ldt)
    in
    GeneralModel layer.name (dataToLDT layer.data) init update view
