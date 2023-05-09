module Components.A.A exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Component

This is a component model module. It should define init, update and view model.

@docs initModel
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable, empty)
import Dict
import Lib.Component.Base exposing (ComponentInitData(..), ComponentTMsg(..), ComponentTarget(..), Data, DefinedTypes(..), Env)


{-| initModel

Initialize the model. It should update the id.

-}
initModel : Env -> ComponentInitData -> Data
initModel _ i =
    case i of
        ComponentID id _ ->
            Dict.fromList
                [ ( "id", CDInt id )
                ]

        _ ->
            Dict.fromList []


{-| updateModel

Add your component logic here.

-}
updateModel : Env -> ComponentTMsg -> Data -> ( Data, List ( ComponentTarget, ComponentTMsg ), Env )
updateModel env ctmsg d =
    case ctmsg of
        ComponentIntMsg x ->
            let
                test =
                    Debug.log "A" x
            in
            ( d, [ ( ComponentByName "B", ComponentIntMsg (x - 1) ), ( ComponentParentLayer, ComponentIntMsg x ), ( ComponentByName "B", ComponentIntMsg (x + 1) ) ], env )

        _ ->
            ( d, [], env )


{-| viewModel

Change this to your own component view function.

If there is no view function, return Nothing.

-}
viewModel : Env -> Data -> Renderable
viewModel _ _ =
    empty
