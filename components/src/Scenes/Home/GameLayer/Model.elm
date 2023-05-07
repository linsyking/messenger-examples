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
import Canvas exposing (Renderable)
import Components.Console.Export as Console
import Components.Typer.Export as Typer
import Lib.Component.Base exposing (ComponentTMsg(..), ComponentTarget(..))
import Lib.Component.ComponentHandler exposing (updateComponents, viewComponent)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Home.GameLayer.Common exposing (Model)
import Scenes.Home.LayerBase exposing (CommonData)


{-| initModel
Add components here
-}
initModel : Int -> LayerMsg -> CommonData -> Model
initModel t _ _ =
    { components =
        Array.fromList
            [ Typer.initComponent t 0 (ComponentIntMsg 1)
            , Console.initComponent t 1 (ComponentIntMsg 0)
            ]
    }


{-| Handle component messages (that are sent to this layer).
-}
handleComponentMsg : GlobalData -> ComponentTMsg -> ( Model, Int ) -> CommonData -> ( ( Model, CommonData, List ( LayerTarget, LayerMsg ) ), GlobalData )
handleComponentMsg gd tmsg ( model, _ ) cd =
    case tmsg of
        ComponentStringMsg x ->
            ( ( model, cd, [ ( LayerParentScene, LayerStringMsg x ) ] ), gd )

        _ ->
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
    viewComponent gd t model.components
