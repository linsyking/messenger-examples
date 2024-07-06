module PortableComponents.Console.Typer exposing (..)

import Messenger.Component.PortableComponent exposing (PortableComponentStorage, PortableMsgCodec, PortableTarCodec, genPortableComponent)
import PortableComponents.Console.Base exposing (Msg(..), Target(..))
import PortableComponents.Typer.Model as Typer


component : PortableComponentStorage () userdata Target Msg () ()
component =
    let
        targetCodec : PortableTarCodec Typer.Target Target
        targetCodec =
            { encode =
                \gt ->
                    if gt == Typer then
                        Typer.Me

                    else
                        Typer.OtherC
            , decode = \_ -> OtherC
            }

        msgCodec : PortableMsgCodec Typer.Msg Msg
        msgCodec =
            { encode =
                \msg ->
                    case msg of
                        TyperInit his ->
                            Typer.Init his

                        TyperWritten ->
                            Typer.Written

                        TyperClear ->
                            Typer.Clear

                        _ ->
                            Typer.NullMsg
            , decode =
                \msg ->
                    case msg of
                        Typer.Text ( txt, pointer ) ->
                            TyperText ( txt, pointer )

                        Typer.Log his ->
                            TyperLog his

                        _ ->
                            NullMsg
            }
    in
    genPortableComponent Typer.componentcon targetCodec msgCodec () 0
