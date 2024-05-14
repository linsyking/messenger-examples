module MainConfig exposing
    ( background
    , debug
    , initGlobalData
    , initScene
    , initSceneMsg
    , saveGlobalData
    , timeInterval
    , virtualSize
    )

{-|


# Main Config

@docs background
@docs debug
@docs initGlobalData
@docs initScene
@docs initSceneMsg
@docs saveGlobalData
@docs timeInterval
@docs virtualSize

-}

import Canvas exposing (Renderable)
import Lib.Base exposing (SceneMsg)
import Lib.UserData exposing (UserData, decodeUserData, encodeUserData)
import Messenger.Base exposing (UserViewGlobalData)
import Messenger.UserConfig exposing (transparentBackground)


{-| Initial scene
-}
initScene : String
initScene =
    "Home"


{-| Initial scene message
-}
initSceneMsg : Maybe SceneMsg
initSceneMsg =
    Nothing


{-| Virtual screen size
-}
virtualSize : { width : Float, height : Float }
virtualSize =
    { width = 1920, height = 1080 }


{-| Debug flag
-}
debug : Bool
debug =
    True


{-| Background of the scene.
-}
background : Messenger.Base.GlobalData userdata -> Renderable
background =
    transparentBackground


{-| Interval between two Tick messages in milliseconds.
-}
timeInterval : Float
timeInterval =
    15


{-| Initialize the global data with the user data.

You may set the initial user data based on the user data.

-}
initGlobalData : String -> UserViewGlobalData UserData
initGlobalData data =
    let
        storage =
            decodeUserData data
    in
    { sceneStartTime = 0
    , globalTime = 0
    , volume = 0.5
    , canvasAttributes = []
    , extraHTML = Nothing
    , userData = storage
    }


{-| Save Globaldata

Used when saving the user data to local storage.

-}
saveGlobalData : UserViewGlobalData UserData -> String
saveGlobalData globalData =
    encodeUserData globalData.userData
