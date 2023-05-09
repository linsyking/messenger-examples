module Lib.Layer.Base exposing
    ( LayerMsg(..)
    , LayerTarget(..)
    , Layer, Env, noCommonData, addCommonData
    )

{-| This is the doc for this module

Layer plays a very important role in the game framework.

It is mainly used to seperate different rendering layers.

Using layers can help us deal with different things in different layers.

@docs LayerMsg
@docs LayerTarget
@docs Layer, Env, noCommonData, addCommonData

-}

import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption)
import Messenger.GeneralModel exposing (GeneralModel)


{-| Layer

Layer data type.

a is the layer data, b is the common data that shares between layers, c is the init data

-}
type alias Layer a b c =
    GeneralModel a (Env b) c LayerMsg LayerTarget Renderable


{-| Environment data type.
-}
type alias Env b =
    { msg : Msg
    , globalData : GlobalData
    , t : Int
    , commonData : b
    }


{-| Remove common data from environment.

Useful when sending message to a component.

-}
noCommonData :
    Env b
    ->
        { msg : Msg
        , globalData : GlobalData
        , t : Int
        }
noCommonData env =
    { msg = env.msg
    , globalData = env.globalData
    , t = env.t
    }


{-| Add the common data back.
-}
addCommonData :
    b
    ->
        { msg : Msg
        , globalData : GlobalData
        , t : Int
        }
    -> Env b
addCommonData commonData env =
    { msg = env.msg
    , globalData = env.globalData
    , t = env.t
    , commonData = commonData
    }


{-| LayerMsg

Add your own layer messages here.

-}
type LayerMsg
    = LayerStringMsg String
    | LayerIntMsg Int
    | LayerFloatMsg Float
    | LayerStringDataMsg String LayerMsg
    | LayerSoundMsg String String AudioOption
    | LayerStopSoundMsg String
    | NullLayerMsg


{-| LayerTarget

You can send message to a layer by using LayerTarget.

LayerParentScene is used to send message to the parent scene of the layer.

LayerName is used to send message to a specific layer.

-}
type LayerTarget
    = LayerParentScene
    | LayerName String
