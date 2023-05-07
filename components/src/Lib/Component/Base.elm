module Lib.Component.Base exposing
    ( ComponentTMsg(..)
    , ComponentTMsgType(..)
    , DefinedTypes(..)
    , Component
    , Data
    , nullComponent
    , ComponentTarget(..)
    )

{-|


# Component

Component is designed to have the best flexibility and compability.

You can use component almost anywhere, in layers, in gamecomponents and components themselves.

You have to manually add components in your layer and update them manually.

It is **not** fast to communicate between many components.

Gamecomponents have better speed when communicating with each other. (their message types are built-in)

@docs ComponentTMsg
@docs ComponentTMsgType
@docs DefinedTypes
@docs Component
@docs Data
@docs nullComponent

-}

import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Dict exposing (Dict)
import Lib.Tools.Maybe exposing (nothing2)



--- Component Base


{-| Component

The data entry doesn't have a fixed type, you can use any type you want.

Though this is flexible, it is not convenient to use sometimes.

If your object has many properties that are in common, you should create your own component type.

Examples are [GameComponent](https://github.com/linsyking/Reweave/blob/master/src/Lib/CoreEngine/GameComponent/Base.elm) which has a lot of game related properties.

-}
type alias Component =
    { name : String
    , data : Data
    , init : Int -> Int -> ComponentTMsg -> Data
    , update : Msg -> GlobalData -> ComponentTMsg -> ( Data, Int ) -> ( Data, List ( ComponentTarget, ComponentTMsg ), GlobalData )
    , view : ( Data, Int ) -> GlobalData -> Maybe Renderable
    }


{-| nullComponent
-}
nullComponent : Component
nullComponent =
    { name = "NULL"
    , data = Dict.empty
    , init = \_ _ _ -> Dict.empty
    , update =
        \_ gd _ _ ->
            ( Dict.empty
            , []
            , gd
            )
    , view = nothing2
    }


{-| ComponentTMsg

This is the message that can be sent to the layer

Those entries are some basic data types we need.

You may add your own data types here.

However, if your data types are too complicated, you might want to create your own component type (like game component) to acheive better performance.

-}
type ComponentTMsg
    = ComponentUnnamedMsg ComponentTMsgType
    | ComponentNamedMsg ComponentTarget ComponentTMsgType
    | NullComponentMsg


{-| Data types for message sending
-}
type ComponentTMsgType
    = ComponentStringMsg String
    | ComponentStringDataMsg String ComponentTMsgType
    | ComponentIntMsg Int
    | ComponentFloatMsg Float
    | ComponentBoolMsg Bool
    | ComponentListMsg (List ComponentTMsgType)
    | ComponentDictMsg Data
    | ComponentComponentMsg Component
    | ComponentComponentTargetMsg ComponentTarget
    | ComponentDTMsg DefinedTypes


{-| ComponentTarget is the target you want to send the message to.

ComponentParentLayer is the layer that the component is in.

ComponentByName is the component that has the name you specified.

ComponentByID is the component that has the id you specified.

-}
type ComponentTarget
    = ComponentParentLayer
    | ComponentByName String
    | ComponentByID Int


{-| Data

Data is the dictionary based on DefinedTypes.

This is the `Data` datatype for Component.

-}
type alias Data =
    Dict String DefinedTypes


{-| DefinedTypes

Defined type is used to store more data types in components.

Those entries are the commonly used data types.

Note that you can use `CDComponent` to store components inside components.

-}
type DefinedTypes
    = CDInt Int
    | CDBool Bool
    | CDFloat Float
    | CDString String
    | CDComponent Component
    | CDComponentTarget ComponentTarget
    | CDListDT (List DefinedTypes)
    | CDDictDT (Dict String DefinedTypes)
