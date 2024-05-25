module Lib.Scene.Base exposing
    ( SceneTMsg(..), SceneOutputMsg(..)
    , Scene, SceneInitData(..)
    , LayerPacker
    )

{-|


# Scene

Scene plays an important role in Messenger.

It is like a "page". You can change scenes in the game.

You have to send data to next scene if you don't store the data in globaldata.

@docs SceneTMsg, SceneOutputMsg
@docs Scene, SceneInitData

-}

import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption)
import Lib.Env.Env exposing (Env)


{-| Scene
-}
type alias Scene a =
    { init : Env -> SceneInitData -> a
    , update : Env -> a -> ( a, List SceneOutputMsg, Env )
    , view : Env -> a -> Renderable
    }


{-| Data to initilize the scene.
-}
type SceneInitData
    = SceneTransMsg SceneTMsg
    | NullSceneInitData


{-| SceneTMsg
You can pass some messages to the scene to initilize it.

Add your own messages here if you want to do more things.

Commonly, a game engine may want to add the engine init settings here.

-}
type SceneTMsg
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
