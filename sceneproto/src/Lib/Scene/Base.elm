module Lib.Scene.Base exposing
    ( SceneMsg(..)
    , SceneOutputMsg(..)
    , Scene, Env, SceneInitData(..)
    , LayerPacker
    )

{-| This is the doc for this module


# Scene

Scene plays an important role in our game engine.

It is like a "page". You can change scenes in the game.

Different levels are different scenes.

You have to transmit data to next scene if you don't store the data in globaldata.

@docs SceneMsg
@docs SceneOutputMsg
@docs Scene, Env, SceneInitData

-}

import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption)


{-| Scene
-}
type alias Scene a =
    { init : Env -> SceneInitData -> a
    , update : Env -> a -> ( a, List SceneOutputMsg, Env )
    , view : Env -> a -> Renderable
    }


{-| Environment data
-}
type alias Env =
    { msg : Msg
    , t : Int
    , globalData : GlobalData
    }


{-| Data to initilize the scene.
-}
type SceneInitData
    = NullSceneInitData


{-| SceneMsg
You can pass some messages to the scene to initilize it.

Add your own messages here if you want to do more things.

Commonly, a game engine may want to add the engine init settings here.

-}
type SceneMsg
    = SceneStringMsg String
    | SceneIntMsg Int
    | NullSceneMsg


{-| SceneOutputMsg

When you want to change the scene or play the audio, you have to send those messages to the central controller.

Add your own messages here if you want to do more things.

-}
type SceneOutputMsg
    = SOMChangeScene ( SceneInitData, String )
    | SOMPlayAudio String String AudioOption
    | SOMAlert String
    | SOMStopAudio String
    | SOMSetVolume Float


{-| This datatype is used in Scene definition.
A default scene will have those data in it.
-}
type alias LayerPacker a b =
    { commonData : a
    , layers : List b
    }
