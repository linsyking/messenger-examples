module SceneProtos.SimpleGame.GameComponent.Handler exposing
    ( update, match, super, recBody
    , updateGC, viewGC
    )

{-| Handler to update game components

@docs update, match, super, recBody
@docs updateGC, viewGC

-}

import Array exposing (Array)
import Canvas exposing (Renderable, group)
import Lib.Env.Env exposing (EnvC)
import Messenger.GeneralModel exposing (viewModelArray)
import Messenger.Recursion exposing (RecBody)
import Messenger.RecursionArray exposing (updateObjects)
import SceneProtos.SimpleGame.GameComponent.Base exposing (GameComponent, GameComponentMsg(..), GameComponentTarget(..))
import SceneProtos.SimpleGame.LayerBase exposing (CommonData)


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
    }


{-| Update all the components in an array and recursively update the components which have messenges sent.

Return a list of messages sent to the parentlayer.

-}
updateGC : EnvC CommonData -> Array GameComponent -> ( Array GameComponent, List GameComponentMsg, EnvC CommonData )
updateGC env =
    updateObjects recBody env NullGCMsg


{-| Generate the view of the components
-}
viewGC : EnvC CommonData -> Array GameComponent -> Renderable
viewGC env xs =
    group [] <| viewModelArray env xs
