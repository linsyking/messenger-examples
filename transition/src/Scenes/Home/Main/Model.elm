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

import Base exposing (Msg(..))
import Canvas exposing (Renderable, group, shapes)
import Canvas.Settings exposing (fill)
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
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
    if env.globalData.sceneStartTime == 150 then
        ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Home2" ) ], env )

    else
        ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env _ =
    group []
        [ renderSprite env.globalData
            []
            ( 0, 0 )
            ( 1920, 0 )
            "b"
        , shapes []
            [ rect env.globalData ( 0, 0 ) ( 200, 100 )
            ]
        , shapes [ fill Color.blue ]
            [ rect env.globalData ( 300, 100 ) ( 200, 100 )
            ]
        ]
