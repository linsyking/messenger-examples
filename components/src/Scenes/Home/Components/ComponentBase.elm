module Scenes.Home.Components.ComponentBase exposing (ComponentMsg(..), ComponentTarget, BaseData)

{-|


# Component base

@docs ComponentMsg, ComponentTarget, BaseData

-}

import Scenes.Home.Components.Comp.Msg as Rect


{-| Component message
-}
type ComponentMsg
    = RectangleMsg Rect.Msg
    | RectangleInit Rect.Init
    | NullComponentMsg


{-| Component target
-}
type alias ComponentTarget =
    Int


{-| Component base data
-}
type alias BaseData =
    ()
