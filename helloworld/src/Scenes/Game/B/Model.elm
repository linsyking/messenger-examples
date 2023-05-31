module Scenes.Game.B.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable, empty, shapes)
import Canvas.Settings exposing (fill)
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
import Scenes.Game.B.Common exposing (EnvC, Model, nullModel)
import Scenes.Game.SceneInit exposing (GameInit)


{-| initModel
Add components here
-}
initModel : EnvC -> GameInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    if env.t == 100 then
        ( model, [(LayerName "A", LayerIntMsg 6)], env )

    else
        ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env _ =
    shapes [ fill Color.yellow ]
        [ rect env.globalData ( 400, 0 ) ( 1920 // 2, 1080 )
        ]
