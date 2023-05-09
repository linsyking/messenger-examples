module Components.A.Export exposing (initComponent)

{-| Component Export

Write a description here for how to use your component.

@docs initComponent

-}

import Components.A.A exposing (initModel, updateModel, viewModel)
import Lib.Component.Base exposing (Component, ComponentInitData, ComponentTMsg(..), Env)


{-| initComponent
Write a description here for how to initialize your component.
-}
initComponent : Env -> ComponentInitData -> Component
initComponent env i =
    { name = "A"
    , data = initModel env i
    , init = initModel
    , update = updateModel
    , view = viewModel
    }
