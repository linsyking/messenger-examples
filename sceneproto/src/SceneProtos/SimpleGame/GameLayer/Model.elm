module SceneProtos.SimpleGame.GameLayer.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| This is the doc for this module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Array
import Canvas exposing (Renderable)
import Lib.Component.Base exposing (ComponentMsg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponentInitData(..))
import SceneProtos.SimpleGame.GameComponent.Handler exposing (viewGC)
import SceneProtos.SimpleGame.GameLayer.Common exposing (EnvC, Model)
import SceneProtos.SimpleGame.LayerInit exposing (LayerInitData(..))


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel _ i =
    case i of
        GameLayerInitData x ->
            x

        _ ->
            { balls = Array.empty }


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
    viewGC env model.balls
