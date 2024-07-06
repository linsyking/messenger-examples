module Lib.UserData exposing (UserData, decodeUserData, encodeUserData)

{-|


# User data

@docs UserData, decodeUserData, encodeUserData

-}

import Json.Decode as Decode exposing (at, decodeString)
import Json.Encode as Encode
import PortableComponents.Typer.History exposing (History, hisFromList, hisToList)


{-| UserData

`UserData` can store any data in the game.
Users can **save their own global data** and **implement local storage** here.

-}
type alias UserData =
    { consoleHis : History }


{-| encodeUserData

encoder for the Userdata to store the data you want.

-}
encodeUserData : UserData -> String
encodeUserData storage =
    Encode.encode 0
        (Encode.object
            [ ( "consoleHis", Encode.list Encode.string <| hisToList storage.consoleHis )
            ]
        )


{-| decodeUserData

decoder for the Userdata to get data from the storage.

-}
decodeUserData : String -> UserData
decodeUserData ls =
    let
        his =
            hisFromList <| Result.withDefault [] (decodeString (at [ "consoleHis" ] <| Decode.list Decode.string) ls)
    in
    UserData his
