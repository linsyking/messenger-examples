module Scenes.Home.Components.Comp.Msg exposing
    ( Init
    , Msg
    )

{-| Msg module for component.

You may want to put this in `ComponentBase` module.

If you don't need communication between components, you can remove this module.

@docs Init

-}

import Color exposing (Color)


{-| Component init type
-}
type alias Init =
    { left : Float
    , top : Float
    , width : Float
    , height : Float
    , color : Color
    }


type alias Msg =
    Color
