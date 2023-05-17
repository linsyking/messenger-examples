module Components.Button.Base exposing (ButtonInit)

import Color exposing (Color)


type alias ButtonInit =
    { position : ( Int, Int )
    , size : ( Int, Int )
    , text : String
    , background : Color
    , textColor: Color
    }
