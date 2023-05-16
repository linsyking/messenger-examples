module Components.Tetriminos.Export exposing (initComponent)

{-| Component Export

Write a description here for how to use your component.

@docs initComponent

-}

import Components.Tetriminos.Tetriminos exposing (initModel, updateModel, viewModel)
import Lib.Component.Base exposing (Component, ComponentInitData, ComponentMsg(..))
import Lib.Env.Env exposing (Env)


{-| initComponent
Write a description here for how to initialize your component.
-}
initComponent : Env -> ComponentInitData -> Component
initComponent env i =
    { name = "Tetriminos"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
