module SceneProtos.SimpleGame.Model exposing
    ( initModel
    , handleLayerMsg
    , updateModel
    , viewModel
    )

{-| This is the doc for this module

@docs initModel
@docs handleLayerMsg
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Env.Env exposing (Env, EnvC, addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneInitData(..), SceneMsg(..), SceneOutputMsg(..))
import SceneProtos.SimpleGame.Common exposing (Model)
import SceneProtos.SimpleGame.GameLayer.Export as GameLayer
import SceneProtos.SimpleGame.GameLayer.Global as GameLayerG
import SceneProtos.SimpleGame.LayerBase exposing (CommonData, LayerInitData(..), nullCommonData)


{-| Initialize the model
-}
initModel : Env -> SceneInitData -> Model
initModel env _ =
    { commonData = nullCommonData
    , layers =
        [ let
            x =
                GameLayer.layer
          in
          GameLayerG.getLayerT { x | data = GameLayer.layer.init (addCommonData nullCommonData env) NullLayerInitData }
        ]
    }


{-| handleLayerMsg

Usually you are adding logic here.

-}
handleLayerMsg : EnvC CommonData -> LayerMsg -> Model -> ( Model, List SceneOutputMsg, EnvC CommonData )
handleLayerMsg env _ model =
    ( model, [], env )


{-| updateModel

Default update function. Normally you won't change this function.

-}
updateModel : Env -> Model -> ( Model, List SceneOutputMsg, Env )
updateModel env model =
    let
        ( newdata, msgs, newenv ) =
            updateLayer (addCommonData model.commonData env) NullLayerMsg model.layers

        nmodel =
            { model | commonData = newenv.commonData, layers = newdata }

        ( newmodel, newsow, newgd2 ) =
            List.foldl (\x ( y, _, cgd ) -> handleLayerMsg cgd x y) ( nmodel, [], newenv ) msgs
    in
    ( newmodel, newsow, noCommonData newgd2 )


{-| Default view function
-}
viewModel : Env -> Model -> Renderable
viewModel env model =
    viewLayer (addCommonData model.commonData env) model.layers
