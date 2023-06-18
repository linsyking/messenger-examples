module Lib.Scene.Transitions.Base exposing
    ( Transition, SingleTrans
    , genTransition
    )

{-|


# Transition Base

@docs Transition, SingleTrans
@docs genTransition

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable)


{-| Single Transition
-}
type alias SingleTrans =
    GlobalData -> Renderable -> Float -> Renderable


{-| Transition has three stages:

1.  From the old scene to the transition scene
2.  Transition scene
3.  From the transition scene to the new scene

-}
type alias Transition =
    { currentTransition : Int
    , outT : Int
    , inT : Int
    , fadeout : SingleTrans
    , fadein : SingleTrans
    }


{-| Generate new transition
-}
genTransition : Int -> Int -> SingleTrans -> SingleTrans -> Transition
genTransition outT inT fadeout fadein =
    { currentTransition = 0
    , outT = outT
    , inT = inT
    , fadeout = fadeout
    , fadein = fadein
    }
