module Scenes.Home.Components.ComponentBase exposing (ComponentMsg(..), ComponentTarget, BaseData)

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}

import PortableComponents.Typer.History exposing (History)


{-| Component message
-}
type ComponentMsg
    = ConsoleInit History
    | ConsoleOutput String
    | ConsoleLog History
    | ConsoleClear
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
