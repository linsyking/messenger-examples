module SceneProtos.SimpleGame.GameLayer.Global exposing
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
import SceneProtos.SimpleGame.GameLayer.Common exposing (EnvC)
import SceneProtos.SimpleGame.GameLayer.Export exposing (Data, nullData)
import SceneProtos.SimpleGame.LayerBase exposing (CommonData, LayerInitData)
import SceneProtos.SimpleGame.LayerSettings exposing (LayerDataType(..), LayerT)


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
        init : EnvC -> LayerInitData -> LayerDataType
        init env i =
            dataToLDT (layer.init env i)

        update : EnvC -> LayerMsg -> LayerDataType -> ( LayerDataType, List ( LayerTarget, LayerMsg ), EnvC )
        update env lm ldt =
            let
                ( rldt, newmsg, newenv ) =
                    layer.update env lm (ldtToData ldt)
            in
            ( dataToLDT rldt, newmsg, newenv )

        view : EnvC -> LayerDataType -> Renderable
        view env ldt =
            layer.view env (ldtToData ldt)
    in
    GeneralModel layer.name (dataToLDT layer.data) init update view
