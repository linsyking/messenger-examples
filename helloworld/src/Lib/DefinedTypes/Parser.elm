module Lib.DefinedTypes.Parser exposing
    ( dIntGet
    , dIntSet
    , dFloatGet
    , dFloatSet
    , dBoolGet
    , dBoolSet
    , dStringGet
    , dStringSet
    , dListDTGet
    , dListDTSet
    , dDictDTGet
    , dDictDTSet
    , dComponentGet
    , dComponentSet
    , dComponentTargetGet
    , dComponentTargetSet
    )

{-| This is a parser for DefinedTypes.

You have to use functions here to decode and encode DefinedTypes.

@docs dIntGet
@docs dIntSet
@docs dFloatGet
@docs dFloatSet
@docs dBoolGet
@docs dBoolSet
@docs dStringGet
@docs dStringSet
@docs dListDTGet
@docs dListDTSet
@docs dDictDTGet
@docs dDictDTSet
@docs dComponentGet
@docs dComponentSet
@docs dComponentTargetGet
@docs dComponentTargetSet

-}

import Dict exposing (Dict)
import Lib.Component.Base exposing (Component, ComponentTarget(..), DefinedTypes(..), nullComponent)


{-| dIntGet
-}
dIntGet : Dict String DefinedTypes -> String -> Int
dIntGet f s =
    let
        other =
            0
    in
    case Dict.get s f of
        Just (CDInt x) ->
            x

        _ ->
            other


{-| dIntSet
-}
dIntSet : String -> Int -> Dict String DefinedTypes -> Dict String DefinedTypes
dIntSet s t f =
    Dict.update s (\_ -> Just (CDInt t)) f


{-| dFloatGet
-}
dFloatGet : Dict String DefinedTypes -> String -> Float
dFloatGet f s =
    let
        other =
            0
    in
    case Dict.get s f of
        Just (CDFloat x) ->
            x

        _ ->
            other


{-| dFloatSet
-}
dFloatSet : String -> Float -> Dict String DefinedTypes -> Dict String DefinedTypes
dFloatSet s t f =
    Dict.update s (\_ -> Just (CDFloat t)) f


{-| dBoolGet
-}
dBoolGet : Dict String DefinedTypes -> String -> Bool
dBoolGet f s =
    let
        other =
            False
    in
    case Dict.get s f of
        Just (CDBool x) ->
            x

        _ ->
            other


{-| dBoolSet
-}
dBoolSet : String -> Bool -> Dict String DefinedTypes -> Dict String DefinedTypes
dBoolSet s t f =
    Dict.update s (\_ -> Just (CDBool t)) f


{-| dStringGet
-}
dStringGet : Dict String DefinedTypes -> String -> String
dStringGet f s =
    let
        other =
            ""
    in
    case Dict.get s f of
        Just (CDString x) ->
            x

        _ ->
            other


{-| dStringSet
-}
dStringSet : String -> String -> Dict String DefinedTypes -> Dict String DefinedTypes
dStringSet s t f =
    Dict.update s (\_ -> Just (CDString t)) f


{-| dListDTGet
-}
dListDTGet : Dict String DefinedTypes -> String -> List DefinedTypes
dListDTGet f s =
    let
        other =
            []
    in
    case Dict.get s f of
        Just (CDListDT x) ->
            x

        _ ->
            other


{-| dListDTSet
-}
dListDTSet : String -> List DefinedTypes -> Dict String DefinedTypes -> Dict String DefinedTypes
dListDTSet s t f =
    Dict.update s (\_ -> Just (CDListDT t)) f


{-| dDictDTGet
-}
dDictDTGet : Dict String DefinedTypes -> String -> Dict String DefinedTypes
dDictDTGet f s =
    case Dict.get s f of
        Just (CDDictDT x) ->
            x

        _ ->
            Dict.empty


{-| dDictDTSet
-}
dDictDTSet : String -> Dict String DefinedTypes -> Dict String DefinedTypes -> Dict String DefinedTypes
dDictDTSet s t f =
    Dict.update s (\_ -> Just (CDDictDT t)) f


{-| dComponentGet
-}
dComponentGet : Dict String DefinedTypes -> String -> Component
dComponentGet f s =
    case Dict.get s f of
        Just (CDComponent x) ->
            x

        _ ->
            nullComponent


{-| dComponentSet
-}
dComponentSet : String -> Component -> Dict String DefinedTypes -> Dict String DefinedTypes
dComponentSet s t f =
    Dict.update s (\_ -> Just (CDComponent t)) f


{-| dComponentTargetGet
-}
dComponentTargetGet : Dict String DefinedTypes -> String -> ComponentTarget
dComponentTargetGet f s =
    case Dict.get s f of
        Just (CDComponentTarget x) ->
            x

        _ ->
            ComponentParentLayer


{-| dComponentTargetSet
-}
dComponentTargetSet : String -> ComponentTarget -> Dict String DefinedTypes -> Dict String DefinedTypes
dComponentTargetSet s t f =
    Dict.update s (\_ -> Just (CDComponentTarget t)) f
