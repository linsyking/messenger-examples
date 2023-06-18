module Scenes.Home.Model exposing
    ( handleLayerMsg
    , updateModel
    , viewModel
    )

{-| Scene update module

@docs handleLayerMsg
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable)
import Color
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Env.Env exposing (Env, EnvC, addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Lib.Scene.Transitions.Base exposing (genTransition)
import Lib.Scene.Transitions.Scroll exposing (scrollOut)
import Scenes.Home.Common exposing (Model)
import Scenes.Home.LayerBase exposing (CommonData)
import Lib.Scene.Transitions.Scroll exposing (scrollIn)


{-| handleLayerMsg

Usually you are adding logic here.

-}
handleLayerMsg : EnvC CommonData -> LayerMsg -> Model -> ( Model, List SceneOutputMsg, EnvC CommonData )
handleLayerMsg env lmsg model =
    case lmsg of
        LayerSoundMsg name path opt ->
            ( model, [ SOMPlayAudio name path opt ], env )

        LayerStopSoundMsg name ->
            ( model, [ SOMStopAudio name ], env )

        LayerChangeSceneMsg "Home2" ->
            ( model, [ SOMChangeScene ( NullSceneInitData, "Home2", Just <| genTransition 50 30 (scrollOut Color.black) (scrollIn Color.black) ) ], env )

        _ ->
            ( model, [], env )


{-| updateModel

Default update function. Normally you won't change this function.

-}
updateModel : Env -> Model -> ( Model, List SceneOutputMsg, Env )
updateModel env model =
    let
        ( newdata, msgs, newenv ) =
            updateLayer (addCommonData model.commonData env) model.layers

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
