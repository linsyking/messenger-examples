module Lib.UserData exposing (UserData, decodeUserData, encodeUserData)

{-|


# User data

@docs UserData, decodeUserData, encodeUserData

-}

import Json.Decode as Decode exposing (at, decodeString)
import Json.Encode as Encode


{-| User defined data
-}
type alias UserData =
    { maxScore : Int }


{-| Encoder for the UserData.
-}
encodeUserData : UserData -> String
encodeUserData storage =
    Encode.encode 0
        (Encode.object
            [ ( "maxScore", Encode.int storage.maxScore )
            ]
        )


{-| Decoder for the UserData.
-}
decodeUserData : String -> UserData
decodeUserData ls =
    let
        maxScore =
            Result.withDefault 0 (decodeString (at [ "maxScore" ] Decode.int) ls)
    in
    UserData maxScore
