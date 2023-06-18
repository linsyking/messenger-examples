module Lib.Env.Env exposing
    ( Env, EnvC
    , noCommonData, addCommonData
    , cleanEnv, cleanEnvC
    )

{-|


# Env

Provide type support for environment variables.

@docs Env, EnvC
@docs noCommonData, addCommonData
@docs cleanEnv, cleanEnvC

-}

import Base exposing (GlobalData, Msg(..))


{-| Normal environment.
-}
type alias Env =
    { msg : Msg
    , t : Int
    , globalData : GlobalData
    }


{-| Normal environment with extra common data.
-}
type alias EnvC b =
    { msg : Msg
    , globalData : GlobalData
    , t : Int
    , commonData : b
    }


{-| Remove common data from environment.

Useful when sending message to a component.

-}
noCommonData : EnvC b -> Env
noCommonData env =
    { msg = env.msg
    , globalData = env.globalData
    , t = env.t
    }


{-| Add the common data back.
-}
addCommonData : b -> Env -> EnvC b
addCommonData commonData env =
    { msg = env.msg
    , globalData = env.globalData
    , t = env.t
    , commonData = commonData
    }


{-| Clean the environment
-}
cleanEnv : Env -> Env
cleanEnv env =
    { env | msg = NullMsg }


{-| Clean the environment with commonData
-}
cleanEnvC : EnvC b -> EnvC b
cleanEnvC env =
    { env | msg = NullMsg }
