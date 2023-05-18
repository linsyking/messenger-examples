module SceneProtos.CoreEngine.GameLayer.Global exposing (getLayerT)

{-| This is the doc for this module

@docs getLayerT

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (Layer, LayerMsg, LayerTarget)
import Messenger.GeneralModel exposing (GeneralModel)
import SceneProtos.CoreEngine.GameLayer.Common exposing (EnvC, nullModel)
import SceneProtos.CoreEngine.GameLayer.Export exposing (Data)
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)
import SceneProtos.CoreEngine.LayerSettings exposing (LayerDataType(..), LayerT)


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
            nullModel


{-| getLayerT
-}
getLayerT : Layer Data CommonData -> LayerT
getLayerT layer =
    let
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
    GeneralModel layer.name (dataToLDT layer.data) update view
