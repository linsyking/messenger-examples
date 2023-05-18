port module Lib.Tools.Browser exposing (alert)

{-| This module contains functions for working with the browser.

@docs alert

-}


{-| This is the alert function in JS.
-}
port alert : String -> Cmd msg
