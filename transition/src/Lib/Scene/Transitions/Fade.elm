module Lib.Scene.Transitions.Fade exposing
    ( fadeOutBlack, fadeInBlack
    , fadeOutWithRenderable, fadeInWithRenderable
    , fadeIn, fadeOut
    )

{-| Fading Effects

@docs fadeOutWithColor, fadeInWithColor
@docs fadeOutBlack, fadeInBlack
@docs fadeOutWithRenderable, fadeInWithRenderable

-}

import Canvas exposing (Renderable, group, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (alpha)
import Color exposing (Color)
import Lib.Render.Shape exposing (rect)
import Lib.Scene.Transitions.Base exposing (SingleTrans)
import MainConfig exposing (plHeight, plWidth)


{-| Fade Out with Color
-}
fadeOut : Color -> SingleTrans
fadeOut color gd rd v =
    group []
        [ rd
        , shapes [ fill color, alpha v ]
            [ rect gd ( 0, 0 ) ( plWidth, plHeight )
            ]
        ]


{-| Fade In with Color
-}
fadeIn : Color -> SingleTrans
fadeIn color gd rd v =
    group []
        [ rd
        , shapes [ fill color, alpha (1 - v) ]
            [ rect gd ( 0, 0 ) ( plWidth, plHeight )
            ]
        ]


{-| Fade Out with Black
-}
fadeOutBlack : SingleTrans
fadeOutBlack =
    fadeOut Color.black


{-| Fade In with Black
-}
fadeInBlack : SingleTrans
fadeInBlack =
    fadeIn Color.black


{-| Fade Out with Renderable
-}
fadeOutWithRenderable : Renderable -> SingleTrans
fadeOutWithRenderable renderable _ rd v =
    group []
        [ rd
        , group [ alpha v ]
            [ renderable
            ]
        ]


{-| Fade In with Renderable
-}
fadeInWithRenderable : Renderable -> SingleTrans
fadeInWithRenderable renderable _ rd v =
    group []
        [ rd
        , group [ alpha (1 - v) ]
            [ renderable
            ]
        ]
