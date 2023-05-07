module Scenes.Home.Model exposing
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

import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandlerRaw exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneMsg(..), SceneOutputMsg(..))
import Scenes.Home.Common exposing (Model)
import Scenes.Home.GameLayer.Export as GameLayer
import Scenes.Home.GameLayer.Global as GameLayerG
import Scenes.Home.LayerBase exposing (initCommonData)


{-| Initialize the model
-}
initModel : Int -> SceneMsg -> Model
initModel t _ =
    { commonData = initCommonData
    , layers =
        [ ( "GameLayer"
          , let
                x =
                    GameLayer.layer
            in
            GameLayerG.getLayerT { x | data = GameLayer.layer.init t NullLayerMsg initCommonData }
          )
        ]
    }


{-| handleLayerMsg

Usually you are adding logic here.

-}
handleLayerMsg : GlobalData -> LayerMsg -> ( Model, Int ) -> ( Model, List SceneOutputMsg, GlobalData )
handleLayerMsg gd lmsg ( model, _ ) =
    case lmsg of
        LayerStringMsg x ->
            ( model, [ SOMAlert x ], gd )

        _ ->
            ( model, [], gd )


{-| updateModel

Default update function. Normally you won't change this function.

-}
updateModel : Msg -> GlobalData -> ( Model, Int ) -> ( Model, List SceneOutputMsg, GlobalData )
updateModel msg gd ( model, t ) =
    let
        ( ( newdata, newcd, msgs ), newgd ) =
            updateLayer msg gd t model.commonData model.layers

        nmodel =
            { model | commonData = newcd, layers = newdata }

        ( newmodel, newsow, newgd2 ) =
            List.foldl (\x ( y, _, cgd ) -> handleLayerMsg cgd x ( y, t )) ( nmodel, [], newgd ) msgs
    in
    ( newmodel, newsow, newgd2 )


{-| Default view function
-}
viewModel : ( Model, Int ) -> GlobalData -> Maybe Renderable
viewModel ( model, t ) gd =
    viewLayer gd t model.commonData model.layers
