module Scenes.Home.Components.ComponentBase exposing (ComponentMsg(..), ComponentTarget, BaseData)

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}

import PortableComponents.Button.Model as Button
import Scenes.Home.Components.Comp.Msg as Rect


{-| Component message
-}
type ComponentMsg
    = ButtonInit Button.Data
    | ButtonPressed String
    | RectInit Rect.Init
    | RectMsg Rect.Msg
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    String


{-| Component base data
-}
type alias BaseData =
    ()
