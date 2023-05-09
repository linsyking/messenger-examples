port module Lib.LocalStorage.LocalStorage exposing
    ( decodeLSInfo
    , encodeLSInfo
    , sendInfo
    )

{-| LocalStorage is a local "database" that enables the developer to store data in.

It won't disappear when the game restarts.

You can use it to store some gamedata.

For every gamedata, you first need to add that data type to LSInfo.

@docs decodeLSInfo
@docs encodeLSInfo

-}

import Base exposing (LSInfo)
import Json.Decode as Decode exposing (at, decodeString)
import Json.Encode as Encode


{-| This is the port for sending the data to localstorage.
-}
port sendInfo : String -> Cmd msg


{-| decodeLSInfo

Decode the string to LSInfo.

When the game starts, it will run this function to load the data from localstorage.

-}
decodeLSInfo : String -> LSInfo
decodeLSInfo info =
    let
        oldvol =
            Result.withDefault 0.5 (decodeString (at [ "volume" ] Decode.float) info)
    in
    LSInfo oldvol


{-| encodeLSInfo

Encode the LSInfo to string.

When needed, it will run this function to save the data to localstorage.

-}
encodeLSInfo : LSInfo -> String
encodeLSInfo info =
    Encode.encode 0
        (Encode.object
            [ ( "volume", Encode.float info.volume )
            ]
        )
