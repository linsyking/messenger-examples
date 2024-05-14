module Scenes.Home.Components.ComponentBase exposing (ComponentMsg(..), ComponentTarget, BaseData)

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}

import PortableComponents.Button.Model as Button


{-| Component message
-}
type ComponentMsg
    = ButtonInit Button.Data
    | ButtonPressed String
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
