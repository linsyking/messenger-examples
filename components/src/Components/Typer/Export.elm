module Components.Typer.Export exposing (initComponent)

{-| Component Export

Write a description here for how to use your component.

@docs initComponent

-}

import Components.Typer.Typer exposing (initModel, updateModel, viewModel)
import Lib.Component.Base exposing (Component, ComponentTMsg(..))


{-| initComponent
Write a description here for how to initialize your component.
-}
initComponent : Int -> Int -> ComponentTMsg -> Component
initComponent t id ct =
    { name = "Typer"
    , data = initModel t id ct
    , init = initModel
    , update = updateModel
    , view = viewModel
    }
