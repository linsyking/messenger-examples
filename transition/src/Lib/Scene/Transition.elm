module Lib.Scene.Transition exposing (makeTransition)

{-|


# Transtition Library

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable)
import Lib.Scene.Transitions.Base exposing (Transition)


{-| Generate transition from transition data
-}
makeTransition : GlobalData -> Maybe Transition -> Renderable -> Renderable
makeTransition gd trans ren =
    case trans of
        Just data ->
            if data.currentTransition < data.outT then
                -- Fade out
                data.fadeout gd ren (toFloat data.currentTransition / toFloat data.outT)

            else if data.currentTransition < data.outT + data.inT then
                -- Fade in
                data.fadein gd ren (toFloat (data.currentTransition - data.outT) / toFloat data.inT)

            else
                ren

        Nothing ->
            ren
