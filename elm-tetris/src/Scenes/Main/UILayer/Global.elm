module Scenes.Main.UILayer.Global exposing (getLayerT)

{-| This is the doc for this module

@docs getLayerT

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (Layer, LayerMsg, LayerTarget)
import Messenger.GeneralModel exposing (GeneralModel)
import Scenes.Main.LayerBase exposing (CommonData)
import Scenes.Main.LayerSettings exposing (LayerDataType(..), LayerT)
import Scenes.Main.UILayer.Common exposing (EnvC, nullModel)
import Scenes.Main.UILayer.Export exposing (Data)


dataToLDT : Data -> LayerDataType
dataToLDT data =
    UILayerData data


ldtToData : LayerDataType -> Data
ldtToData ldt =
    case ldt of
        UILayerData x ->
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
