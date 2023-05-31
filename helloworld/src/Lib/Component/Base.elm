module Lib.Component.Base exposing
    ( DefinedTypes(..)
    , Component
    , Data
    , nullComponent
    , ComponentInitData(..), ComponentMsg(..), ComponentTarget(..)
    )

{-|


# Component

Component is designed to have the best flexibility and compability.

You can use component almost anywhere, in layers, in gamecomponents and components themselves.

You have to manually add components in your layer and update them manually.

It is **not** fast to communicate between many components.

Gamecomponents have better speed when communicating with each other. (their message types are built-in)

@docs ComponentTMsg
@docs DefinedTypes
@docs Component
@docs Data
@docs nullComponent

-}

import Canvas exposing (Renderable, empty)
import Color exposing (Color)
import Dict exposing (Dict)
import Lib.Env.Env exposing (Env)
import Messenger.GeneralModel exposing (GeneralModel)



--- Component Base


{-| Component

The data entry doesn't have a fixed type, you can use any type you want.

Though this is flexible, it is not convenient to use sometimes.

If your object has many properties that are in common, you should create your own component type.

Examples are [GameComponent](https://github.com/linsyking/Reweave/blob/master/src/Lib/CoreEngine/GameComponent/Base.elm) which has a lot of game related properties.

-}
type alias Component =
    GeneralModel Data Env ComponentMsg ComponentTarget Renderable


{-| Data type used to initialize a component.
-}
type ComponentInitData
    = ComponentID Int ComponentInitData
    | ComponentMsg ComponentMsg
    | NullComponentInitData


{-| nullComponent
-}
nullComponent : Component
nullComponent =
    { name = "NULL"
    , data = Dict.empty
    , update =
        \env _ _ ->
            ( Dict.empty
            , []
            , env
            )
    , view = \_ _ -> empty
    }


{-| ComponentTMsg

This is the message that can be sent to the layer

Those entries are some basic data types we need.

You may add your own data types here.

However, if your data types are too complicated, you might want to create your own component type (like game component) to achieve better performance.

-}
type ComponentMsg
    = ComponentStringMsg String
    | ComponentIntMsg Int
    | ComponentFloatMsg Float
    | ComponentBoolMsg Bool
    | ComponentStringDataMsg String ComponentMsg
    | ComponentListMsg (List ComponentMsg)
    | ComponentComponentMsg Component
    | ComponentComponentTargetMsg ComponentTarget
    | ComponentNamedMsg ComponentTarget ComponentMsg
    | ComponentDTMsg DefinedTypes
    | NullComponentMsg


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
    | CDComponentMsg ComponentMsg
    | CDComponentTarget ComponentTarget
    | CDColor Color
    | CDListDT (List DefinedTypes)
    | CDDictDT (Dict String DefinedTypes)
