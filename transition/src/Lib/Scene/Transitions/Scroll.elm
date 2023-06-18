module Lib.Scene.Transitions.Scroll exposing (scrollIn, scrollOut)

{-| Scroll Transition

@docs scrollIn, scrollOut

-}

import Canvas exposing (group, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (GlobalCompositeOperationMode(..), compositeOperationMode, fillLinear)
import Color exposing (Color)
import Lib.Coordinate.Coordinates exposing (lengthToReal)
import Lib.Render.Shape exposing (rect)
import Lib.Scene.Transitions.Base exposing (SingleTrans)
import MainConfig exposing (plHeight, plWidth)


{-| Scroll Out
-}
scrollOut : Color -> SingleTrans
scrollOut col gd rd v =
    group []
        [ rd
        , shapes
            [ fillLinear { x0 = 0, y0 = 0, x1 = lengthToReal gd plWidth, y1 = 0 }
                [ ( 0, Color.rgba 0 0 0 0 )
                , ( if 0.95 - v >= 0 then
                        0.95 - v

                    else
                        0
                  , Color.rgba 0 0 0 0
                  )
                , ( 1 - v, Color.rgba 0 0 0 1 )
                , ( 1, Color.rgba 0 0 0 1 )
                ]
            , compositeOperationMode DestinationOut
            ]
            [ rect gd ( 0, 0 ) ( plWidth, plHeight )
            ]
        , shapes
            [ fill col, compositeOperationMode DestinationOver ]
            [ rect gd ( 0, 0 ) ( plWidth, plHeight )
            ]
        ]


{-| Scroll In
-}
scrollIn : Color -> SingleTrans
scrollIn col gd rd v =
    group []
        [ rd
        , shapes
            [ fillLinear { x0 = 0, y0 = 0, x1 = lengthToReal gd plWidth, y1 = 0 }
                [ ( 0, Color.rgba 0 0 0 1 )
                , ( if v >= 0.95 then
                        0

                    else
                        0.95 - v
                  , Color.rgba 0 0 0 1
                  )
                , ( 1 - v, Color.rgba 0 0 0 0 )
                , ( 1, Color.rgba 0 0 0 0 )
                ]
            , compositeOperationMode DestinationOut
            ]
            [ rect gd ( 0, 0 ) ( plWidth, plHeight )
            ]
        , shapes
            [ fill col, compositeOperationMode DestinationOver ]
            [ rect gd ( 0, 0 ) ( plWidth, plHeight )
            ]
        ]
