module SceneProtos.CoreEngine.GameComponent.Handler exposing
    ( update, match, super, recBody
    , updateGC, viewGC
    , removeDead
    , removeOutOfBound
    )

{-| Handler to update game components

@docs update, match, super, recBody
@docs updateGC, viewGC
@docs removeDead

-}

import Base exposing (Msg(..))
import Canvas exposing (Renderable, group)
import Lib.Env.Env exposing (EnvC, cleanEnvC)
import Messenger.GeneralModel exposing (viewModelList)
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionList exposing (updateObjects)
import SceneProtos.CoreEngine.GameComponent.Base exposing (GameComponent, GameComponentMsg(..), GameComponentTarget(..))
import SceneProtos.CoreEngine.LayerBase exposing (CommonData)


{-| Updater
-}
update : GameComponent -> EnvC CommonData -> GameComponentMsg -> ( GameComponent, List ( GameComponentTarget, GameComponentMsg ), EnvC CommonData )
update gc env msg =
    let
        ( newGC, newMsg, newEnv ) =
            gc.update env msg gc.data
    in
    ( { gc | data = newGC }, newMsg, newEnv )


{-| Matcher
-}
match : GameComponent -> GameComponentTarget -> Bool
match gc tar =
    case tar of
        GCParent ->
            False

        GCById x ->
            x == gc.data.uid

        GCByName x ->
            x == gc.name


{-| Super
-}
super : GameComponentTarget -> Bool
super tar =
    case tar of
        GCParent ->
            True

        _ ->
            False


{-| Rec body for the component
-}
recBody : RecBody GameComponent GameComponentMsg (EnvC CommonData) GameComponentTarget
recBody =
    { update = update
    , match = match
    , super = super
    , clean = cleanEnvC
    }


{-| Update all the components in an array and recursively update the components which have messenges sent.

Return a list of messages sent to the parentlayer.

-}
updateGC : EnvC CommonData -> List GameComponent -> ( List GameComponent, List GameComponentMsg, EnvC CommonData )
updateGC env xs =
    let
        ( newGC, newMsg, newEnv ) =
            updateObjects recBody env NullGCMsg xs
    in
    ( newGC, newMsg, newEnv )


{-| Generate the view of the components
-}
viewGC : EnvC CommonData -> List GameComponent -> Renderable
viewGC env xs =
    group [] <| viewModelList env xs



-- Helper Functions


{-| Remove dead objects
-}
removeDead : List GameComponent -> List GameComponent
removeDead =
    List.filter (\x -> x.data.alive)


{-| Remove OoB objects
-}
removeOutOfBound : List GameComponent -> List GameComponent
removeOutOfBound =
    List.filter
        (\p ->
            let
                ( x, _ ) =
                    p.data.position
            in
            x > -200 && x < 2000
        )
