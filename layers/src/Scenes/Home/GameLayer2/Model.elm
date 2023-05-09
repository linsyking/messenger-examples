module Scenes.Home.GameLayer2.Model exposing
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
import Color
import Components.Rect.Export as Rect
import Lib.Component.Base exposing (ComponentInitData(..), ComponentTMsg(..))
import Lib.Component.ComponentHandler exposing (updateComponents, viewComponent)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..), addCommonData, noCommonData)
import Scenes.Home.GameLayer2.Common exposing (Env, Model)
import Scenes.Home.LayerBase exposing (LayerInitData)


{-| initModel
Add components here
-}
initModel : Env -> LayerInitData -> Model
initModel env _ =
    { components =
        Array.fromList
            [ Rect.initComponent (noCommonData env) (ComponentID 0 (RectInitData 150 150 200 200 Color.yellow))
            , Rect.initComponent (noCommonData env) (ComponentID 1 (RectInitData 200 200 200 200 Color.green))
            ]
    }


{-| Handle component messages (that are sent to this layer).
-}
handleComponentMsg : Env -> ComponentTMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), Env )
handleComponentMsg env _ model =
    ( model, [], env )


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : Env -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), Env )
updateModel env _ model =
    let
        components =
            model.components

        ( newComponents, newMsg, newEnv ) =
            updateComponents (noCommonData env) NullComponentMsg components

        ( newModel, newMsg2, newEnv2 ) =
            List.foldl
                (\cTMsg ( m, cmsg, cenv ) ->
                    let
                        ( nm, nmsg, nenv ) =
                            handleComponentMsg cenv cTMsg m
                    in
                    ( nm, nmsg ++ cmsg, nenv )
                )
                ( { model | components = newComponents }, [], addCommonData env.commonData newEnv )
                newMsg
    in
    ( newModel, newMsg2, newEnv2 )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : Env -> Model -> Renderable
viewModel env model =
    viewComponent (noCommonData env) model.components
