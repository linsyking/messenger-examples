module Lib.Tools.Maybe exposing
    ( nothing1
    , nothing2
    , nothing3
    , just1
    , just2
    , just3
    )

{-|


# Tools for dealing with Maybe

@docs nothing1
@docs nothing2
@docs nothing3
@docs just1
@docs just2
@docs just3

-}


{-| Eat 1 argument and return Nothing
-}
nothing1 : a -> Maybe b
nothing1 _ =
    Nothing


{-| Eat 2 arguments and return Nothing
-}
nothing2 : a -> b -> Maybe c
nothing2 _ _ =
    Nothing


{-| Eat 3 arguments and return Nothing
-}
nothing3 : a -> b -> c -> Maybe d
nothing3 _ _ _ =
    Nothing


{-| Given a function and its arguments (1), pack the result with Maybe
-}
just1 : (a -> b) -> a -> Maybe b
just1 f a =
    Just (f a)


{-| Given a function and its arguments (2), pack the result with Maybe
-}
just2 : (a -> b -> c) -> a -> b -> Maybe c
just2 f a b =
    Just (f a b)


{-| Given a function and its arguments (3), pack the result with Maybe
-}
just3 : (a -> b -> c -> d) -> a -> b -> c -> Maybe d
just3 f a b c =
    Just (f a b c)
