module Scenes.Home.Components.Console exposing (..)

{-| Import module for the button portable component.
-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.PortableComponent exposing (PortableComponentStorage, PortableMsgCodec, PortableTarCodec, genPortableComponent)
import PortableComponents.Console.Base as ConsoleBase
import PortableComponents.Console.Model as Console
import Scenes.Home.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Home.SceneBase exposing (SceneCommonData)


component : Int -> PortableComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component zindex =
    let
        targetCodec : PortableTarCodec ConsoleBase.Target ComponentTarget
        targetCodec =
            { encode =
                \tar ->
                    case tar of
                        "console" ->
                            ConsoleBase.Me

                        _ ->
                            ConsoleBase.OtherC
            , decode = \_ -> ""
            }

        msgCodec : PortableMsgCodec ConsoleBase.Msg ComponentMsg
        msgCodec =
            { encode =
                \msg ->
                    case msg of
                        ConsoleInit his ->
                            ConsoleBase.Init his

                        ConsoleClear ->
                            ConsoleBase.TyperClear

                        _ ->
                            ConsoleBase.NullMsg
            , decode =
                \msg ->
                    case msg of
                        ConsoleBase.Output cmd ->
                            ConsoleOutput cmd

                        ConsoleBase.Log his ->
                            ConsoleLog his

                        _ ->
                            NullComponentMsg
            }
    in
    genPortableComponent Console.componentcon targetCodec msgCodec () zindex
