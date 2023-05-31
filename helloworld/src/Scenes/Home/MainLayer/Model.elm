module Scenes.Home.MainLayer.Model exposing
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
import Canvas exposing (Renderable, empty, group, shapes)
import Canvas.Settings exposing (fill)
import Color
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Render.Text exposing (renderText, renderTextWithColorCenter)
import Scenes.Home.MainLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Home.SceneInit exposing (HomeInit)
import Lib.Env.Env exposing (cleanEnvC)


{-| initModel
Add components here
-}
initModel : EnvC -> HomeInit -> Model
initModel _ init =
    init


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        MouseDown 0 pos ->
            if judgeMouseRect pos ( 400, 800 ) ( 200, 100 ) then
                ( model, [(LayerParentScene, LayerChangeSceneMsg "Game")], cleanEnvC env )

            else
                ( model, [], env )

        _ ->
            ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group []
        [ renderSprite env.globalData [] ( 0, 0 ) ( 1920, 0 ) "bg"
        , renderText env.globalData 40 ("Hello " ++ model.title) "Arial" ( 0, 0 )
        , renderTextWithColorCenter env.globalData 140 ("Hello " ++ model.title) "Arial" Color.blue ( 1920 // 2, 1080 // 2 )
        , shapes [ fill Color.red ]
            [ rect env.globalData ( 400, 800 ) ( 200, 100 )
            ]
        ]
