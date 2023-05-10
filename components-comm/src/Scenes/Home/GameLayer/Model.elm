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
import Canvas exposing (Renderable)
import Components.A.Export as A
import Components.B.Export as B
import Lib.Component.Base exposing (ComponentInitData(..), ComponentMsg(..), ComponentTarget(..))
import Lib.Component.ComponentHandler exposing (updateComponents, viewComponent)
import Lib.Env.Env exposing (addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Messenger.RecursionArray exposing (updateObjectByIndex, updateObjectsByTarget)
import Scenes.Home.GameLayer.Common exposing (EnvC, Model)
import Scenes.Home.LayerBase exposing (LayerInitData)


{-| initModel
Add components here
-}
initModel : EnvC -> LayerInitData -> Model
initModel env _ =
    { components =
        Array.fromList
            [ A.initComponent (noCommonData env) NullComponentInitData
            , B.initComponent (noCommonData env) NullComponentInitData
            ]
    }


{-| Handle component messages (that are sent to this layer).
-}
handleComponentMsg : EnvC -> ComponentMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
handleComponentMsg env ctmsg model =
    case ctmsg of
        ComponentIntMsg x ->
            let
                test =
                    Debug.log "layer" x
            in
            ( model, [], env )

        _ ->
            ( model, [], env )


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
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
    if env.t == 100 then
        let
            ( nc, _, _ ) =
                model.components |> updateObjectsByTarget Lib.Component.ComponentHandler.recBody (noCommonData env) (ComponentIntMsg 100) (ComponentByName "B")
        in
        ( { newModel | components = nc }, newMsg2, newEnv2 )

    else
        ( newModel, newMsg2, newEnv2 )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    viewComponent (noCommonData env) model.components
