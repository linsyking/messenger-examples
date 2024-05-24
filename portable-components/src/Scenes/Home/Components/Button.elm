module Scenes.Home.Components.Button exposing (..)

{-| Import module for the button portable component.
-}

import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData)
import Messenger.Component.PortableComponent exposing (PortableComponentStorage, PortableMsgCodec, PortableTarCodec, genPortableComponent)
import PortableComponents.Button.Model as Button
import Scenes.Home.Components.ComponentBase exposing (BaseData, ComponentMsg(..), ComponentTarget)
import Scenes.Home.LayerBase exposing (SceneCommonData)


component : Int -> ComponentTarget -> ComponentMsg -> PortableComponentStorage SceneCommonData UserData ComponentTarget ComponentMsg BaseData SceneMsg
component zindex gtar gmsg =
    let
        targetCodec : PortableTarCodec Button.Target ComponentTarget
        targetCodec =
            { encode = \_ -> Button.OtherC
            , decode = \_ -> gtar
            }

        msgCodec : PortableMsgCodec Button.Msg ComponentMsg
        msgCodec =
            { encode =
                \msg ->
                    case msg of
                        ButtonInit data ->
                            Button.InitData (Just data)

                        _ ->
                            Button.InitData Nothing
            , decode =
                \msg ->
                    case msg of
                        Button.InitData _ ->
                            NullComponentMsg

                        Button.Pressed ->
                            gmsg
            }
    in
    genPortableComponent Button.componentcon targetCodec msgCodec () zindex
