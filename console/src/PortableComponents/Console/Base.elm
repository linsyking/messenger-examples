module PortableComponents.Console.Base exposing (Msg(..), Target(..))

import PortableComponents.Typer.History exposing (History)


type Target
    = OtherC
    | Typer
    | Me


type Msg
    = Init History
    | TyperInit (Maybe History)
    | TyperWritten
    | TyperText ( String, Int )
    | TyperLog History
    | TyperClear
    | Output String
    | Log History
    | NullMsg
