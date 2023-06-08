module Scenes.Home.Main.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable, group)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Home.Main.Common exposing (EnvC, Model, nullModel)
import Scenes.Home.SceneInit exposing (HomeInit)


{-| initModel
Add components here
-}
initModel : EnvC -> HomeInit -> Model
initModel _ _ =
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
viewModel env _ =
    let
        rate =
            5

        currentAct x =
            String.fromInt (modBy (rate * x) env.t // rate)
    in
    group []
        [ renderSprite env.globalData [] ( 0, 0 ) ( 1920, 0 ) "bg"
        , renderSprite env.globalData [ imageSmoothing False ] ( 100, 900 ) ( 100, 0 ) ("player.0/" ++ currentAct 13)
        , renderSprite env.globalData [ imageSmoothing False ] ( 300, 900 ) ( 100, 0 ) ("player.1/" ++ currentAct 8)
        , renderSprite env.globalData [ imageSmoothing False ] ( 500, 900 ) ( 100, 0 ) ("player.2/" ++ currentAct 10)
        , renderSprite env.globalData [ imageSmoothing False ] ( 700, 900 ) ( 100, 0 ) ("player.3/" ++ currentAct 10)
        , renderSprite env.globalData [ imageSmoothing False ] ( 900, 900 ) ( 100, 0 ) ("player.4/" ++ currentAct 10)
        , renderSprite env.globalData [ imageSmoothing False ] ( 1100, 900 ) ( 100, 0 ) ("player.5/" ++ currentAct 6)
        , renderSprite env.globalData [ imageSmoothing False ] ( 1300, 900 ) ( 100, 0 ) ("player.6/" ++ currentAct 4)
        , renderSprite env.globalData [ imageSmoothing False ] ( 1500, 900 ) ( 100, 0 ) ("player.7/" ++ currentAct 7)
        ]
