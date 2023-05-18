module Components.Button.Base exposing (ButtonInit)

{-| Button

@docs ButtonInit

-}

import Color exposing (Color)


{-| ButtonInit

Init Data for Button

-}
type alias ButtonInit =
    { position : ( Int, Int )
    , size : ( Int, Int )
    , text : String
    , background : Color
    , textColor : Color
    }
