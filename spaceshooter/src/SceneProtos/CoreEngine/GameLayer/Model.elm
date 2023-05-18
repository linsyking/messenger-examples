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

import Base exposing (Msg(..))
import Canvas exposing (Renderable)
import Lib.Env.Env exposing (noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponentInitData(..), GameComponentMsg(..))
import SceneProtos.CoreEngine.GameComponent.Handler exposing (removeDead, removeOutOfBound, updateGC, viewGC)
import SceneProtos.CoreEngine.GameComponents.Bullet.Export as Bullet
import SceneProtos.CoreEngine.GameLayer.Collision exposing (updateCollision)
import SceneProtos.CoreEngine.GameLayer.Common exposing (EnvC, Model, nullModel)
import SceneProtos.CoreEngine.GameLayer.GenUID exposing (genUID)
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


handleComponentMsg : EnvC -> GameComponentMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
handleComponentMsg env msg model =
    case msg of
        GCNewBulletMsg bullet ->
            -- Create a new bullet
            let
                objs =
                    model.objects

                newBullet =
                    Bullet.initGC (noCommonData env) <| GCIdData (genUID model.objects) <| GCBulletInitData bullet

                newObjs =
                    newBullet :: objs
            in
            ( { model | objects = newObjs }, [], env )

        GCGameOverMsg ->
            -- Game over
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
        objects =
            removeOutOfBound <| removeDead model.objects

        ( newObjs, newMsg, newEnv ) =
            updateGC env objects

        ( newObjs2, newMsgs2, newEnv2 ) =
            updateCollision newEnv newObjs
    in
    List.foldl
        (\cTMsg ( m, cmsg, cenv ) ->
            let
                ( nm, nmsg, nenv ) =
                    handleComponentMsg cenv cTMsg m
            in
            ( nm, nmsg ++ cmsg, nenv )
        )
        ( { model | objects = newObjs2 }, [], newEnv2 )
        (newMsg ++ newMsgs2)


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    viewGC env model.objects
