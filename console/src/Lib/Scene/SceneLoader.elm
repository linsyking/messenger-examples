module Lib.Scene.SceneLoader exposing
    ( getScene
    , loadScene
    , loadSceneByName
    , getCurrentScene
    )

{-| This is the doc for this module

@docs getScene
@docs loadScene
@docs loadSceneByName
@docs getCurrentScene

-}

import Base exposing (Msg)
import Common exposing (Model)
import Lib.Scene.Base exposing (SceneInitData)
import List exposing (head)
import Scenes.AllScenes exposing (allScenes)
import Scenes.SceneSettings exposing (SceneT, nullSceneT)


{-| getScene
-}
getScene : String -> SceneT
getScene i =
    let
        scenes =
            allScenes

        tests =
            List.filter (\( x, _ ) -> x == i) scenes

        head =
            List.head tests
    in
    case head of
        Just ( _, x ) ->
            x

        Nothing ->
            nullSceneT


{-| loadScene
-}
loadScene : Msg -> Model -> SceneT -> SceneInitData -> Model
loadScene msg model cs tm =
    let
        ls =
            { model | currentScene = cs }

        ld =
            { ls | currentData = cs.init { t = model.time, globalData = model.currentGlobalData, msg = msg } tm }
    in
    ld


{-| loadSceneByName
-}
loadSceneByName : Msg -> Model -> String -> SceneInitData -> Model
loadSceneByName msg model i tm =
    let
        sc =
            getScene i
    in
    loadScene msg model sc tm


{-| getCurrentScene
-}
getCurrentScene : Model -> SceneT
getCurrentScene model =
    model.currentScene
