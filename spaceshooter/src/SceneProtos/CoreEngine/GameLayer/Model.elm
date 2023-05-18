module SceneProtos.CoreEngine.GameLayer.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| This is the doc for this module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import SceneProtos.CoreEngine.GameComponent.Handler exposing (viewGC)
import SceneProtos.CoreEngine.GameLayer.Common exposing (EnvC, Model, nullModel)
import SceneProtos.CoreEngine.LayerInit exposing (LayerInitData(..))


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel _ init =
    case init of
        GameLayerInitData x ->
            x

        _ ->
            nullModel


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    viewGC env model.objects
