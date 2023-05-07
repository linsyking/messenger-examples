module Scenes.Home.GameLayer.Model exposing
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
import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable, group)
import Canvas.Settings.Advanced
import Color
import Lib.Component.Base exposing (ComponentTMsg(..))
import Lib.Component.ComponentHandler exposing (updateComponents)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Render exposing (renderSprite, renderTextWithColor)
import Scenes.Home.GameLayer.Common exposing (Model)
import Scenes.Home.LayerBase exposing (CommonData)


{-| initModel
Add components here
-}
initModel : Int -> LayerMsg -> CommonData -> Model
initModel _ _ _ =
    { components = Array.empty
    }


{-| Handle component messages (that are sent to this layer).
-}
handleComponentMsg : GlobalData -> ComponentTMsg -> ( Model, Int ) -> CommonData -> ( ( Model, CommonData, List ( LayerTarget, LayerMsg ) ), GlobalData )
handleComponentMsg gd _ ( model, _ ) cd =
    ( ( model, cd, [] ), gd )


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : Msg -> GlobalData -> LayerMsg -> ( Model, Int ) -> CommonData -> ( ( Model, CommonData, List ( LayerTarget, LayerMsg ) ), GlobalData )
updateModel msg gd _ ( model, t ) cd =
    let
        components =
            model.components

        ( newComponents, newMsg, newGlobalData ) =
            updateComponents msg gd t components

        ( ( newModel, newCommonData, newMsg2 ), newGlobalData2 ) =
            List.foldl
                (\cTMsg ( ( m, ccd, cmsg ), cgd ) ->
                    let
                        ( ( nm, ncd, nmsg ), ngd ) =
                            handleComponentMsg cgd cTMsg ( m, t ) ccd
                    in
                    ( ( nm, ncd, nmsg ++ cmsg ), ngd )
                )
                ( ( { model | components = newComponents }, cd, [] ), newGlobalData )
                newMsg
    in
    ( ( newModel, newCommonData, newMsg2 ), newGlobalData2 )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : ( Model, Int ) -> CommonData -> GlobalData -> Renderable
viewModel ( model, t ) _ gd =
    group []
        [ renderSprite gd [ Canvas.Settings.Advanced.filter "blur(5px)" ] ( 0, 0 ) ( 1920, 0 ) "bg"
        , renderTextWithColor gd 100 "Hello World!" "Times New Roman" Color.blue ( 700, 100 )
        ]
