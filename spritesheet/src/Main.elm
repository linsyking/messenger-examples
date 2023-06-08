module Main exposing (main)

{-| This is the main module which is the main entry of the whole game

@docs main

-}

import Audio exposing (AudioCmd, AudioData)
import Base exposing (Flags, Msg(..))
import Browser.Events exposing (onKeyDown, onKeyUp, onMouseDown, onMouseMove, onMouseUp, onResize)
import Canvas
import Canvas.Texture
import Common exposing (Model, audio, initGlobalData, resetSceneStartTime, updateSceneStartTime)
import Dict
import Html exposing (Html)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Lib.Audio.Audio exposing (audioPortFromJS, audioPortToJS, loadAudio, stopAudio)
import Lib.Coordinate.Coordinates exposing (fromMouseToVirtual, getStartPoint, maxHandW)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.LocalStorage.LocalStorage exposing (decodeLSInfo, encodeLSInfo, sendInfo)
import Lib.Resources.Base exposing (allTexture, getTexture, saveSprite)
import Lib.Resources.SpriteSheets exposing (allSpriteSheets)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Lib.Scene.SceneLoader exposing (existScene, getCurrentScene, loadSceneByName)
import Lib.Tools.Browser exposing (alert, prompt, promptReceiver)
import MainConfig exposing (debug, initScene, initSceneSettings, timeInterval)
import Scenes.SceneSettings exposing (SceneDataTypes(..), nullSceneT)
import Task
import Time


{-| initModel
-}
initModel : Model
initModel =
    { currentData = NullSceneData
    , currentScene = nullSceneT
    , currentGlobalData = initGlobalData
    , time = 0
    , audiorepo = []
    }


{-| main

Main Function

-}
main : Program Flags (Audio.Model Msg Model) (Audio.Msg Msg)
main =
    Audio.elementWithAudio
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , audio = audio
        , audioPort = { toJS = audioPortToJS, fromJS = audioPortFromJS }
        }


init : Flags -> ( Model, Cmd Msg, AudioCmd Msg )
init flags =
    let
        ms =
            loadSceneByName NullMsg { initModel | currentGlobalData = newgd } initScene initSceneSettings

        ( gw, gh ) =
            maxHandW ( flags.windowWidth, flags.windowHeight )

        ( fl, ft ) =
            getStartPoint ( flags.windowWidth, flags.windowHeight )

        ls =
            decodeLSInfo flags.info

        newgd =
            { initGlobalData | currentTimeStamp = Time.millisToPosix flags.timeStamp, localStorage = ls, browserViewPort = ( flags.windowWidth, flags.windowHeight ), realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }
    in
    ( { ms | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )


{-| This is the update function for updating the model.

If you add some SceneOutputMsg, you have to add corresponding updating logic here.

-}
gameUpdate : Msg -> Model -> ( Model, Cmd Msg, AudioCmd Msg )
gameUpdate msg model =
    if List.length (Dict.keys model.currentGlobalData.sprites) < List.length allTexture then
        -- Still loading assets
        ( model, Cmd.none, Audio.cmdNone )

    else
        let
            oldLocalStorage =
                model.currentGlobalData.localStorage

            ( sdt, som, newenv ) =
                (getCurrentScene model).update { msg = msg, globalData = model.currentGlobalData, t = model.time } model.currentData

            newGD1 =
                newenv.globalData

            newGD2 =
                { newGD1 | lastLocalStorage = oldLocalStorage }

            timeUpdatedModel =
                case msg of
                    Tick _ ->
                        -- Tick event needs to update time
                        { model | time = model.time + 1, currentGlobalData = newGD2 }

                    _ ->
                        { model | currentGlobalData = newGD2 }

            newModel =
                updateSceneStartTime { timeUpdatedModel | currentData = sdt }

            ( newmodel, cmds, audiocmds ) =
                List.foldl
                    (\singleSOM ( lastModel, lastCmds, lastAudioCmds ) ->
                        case singleSOM of
                            SOMChangeScene ( tm, s ) ->
                                --- Load new scene
                                ( loadSceneByName msg lastModel s tm
                                    |> resetSceneStartTime
                                , lastCmds
                                , lastAudioCmds
                                )

                            SOMPlayAudio name path opt ->
                                ( lastModel, lastCmds, lastAudioCmds ++ [ Audio.loadAudio (SoundLoaded name opt) path ] )

                            SOMSetVolume s ->
                                let
                                    oldgd =
                                        lastModel.currentGlobalData

                                    oldLS =
                                        oldgd.localStorage

                                    newgd2 =
                                        { oldgd | localStorage = { oldLS | volume = s } }
                                in
                                ( { lastModel | currentGlobalData = newgd2 }, lastCmds, lastAudioCmds )

                            SOMStopAudio name ->
                                ( { lastModel | audiorepo = stopAudio lastModel.audiorepo name }, lastCmds, lastAudioCmds )

                            SOMAlert text ->
                                ( lastModel, lastCmds ++ [ alert text ], lastAudioCmds )

                            SOMPrompt name title ->
                                ( lastModel, lastCmds ++ [ prompt { name = name, title = title } ], lastAudioCmds )
                    )
                    ( newModel, [], [] )
                    som
        in
        ( newmodel
        , Cmd.batch <|
            if newmodel.currentGlobalData.localStorage /= model.currentGlobalData.lastLocalStorage then
                -- Save local storage
                sendInfo (encodeLSInfo newmodel.currentGlobalData.localStorage) :: cmds

            else
                cmds
        , Audio.cmdBatch audiocmds
        )


{-| update
DO NOT EDIT THIS UNLESS YOU KNOW WHAT YOU ARE DOING.
This is the update function of the whole game.
You may want to change `gameUpdate` rather than this function.
-}
update : AudioData -> Msg -> Model -> ( Model, Cmd Msg, AudioCmd Msg )
update _ msg model =
    let
        gd =
            model.currentGlobalData
    in
    case msg of
        TextureLoaded name Nothing ->
            ( model, alert ("Failed to load sprite " ++ name), Audio.cmdNone )

        TextureLoaded name (Just t) ->
            let
                newgd =
                    case Dict.get name allSpriteSheets of
                        Just sprites ->
                            -- Save all sprites in the spritesheet
                            List.foldl
                                (\( n, s ) lastgd ->
                                    let
                                        ( x, y ) =
                                            s.realStartPoint

                                        ( w, h ) =
                                            s.realSize

                                        newTexture =
                                            Canvas.Texture.sprite { x = x, y = y, width = w, height = h } t
                                    in
                                    { lastgd | sprites = saveSprite lastgd.sprites (name ++ "." ++ n) newTexture }
                                )
                                gd
                                sprites

                        Nothing ->
                            { gd | sprites = saveSprite gd.sprites name t }
            in
            ( { model | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )

        SoundLoaded name opt result ->
            case result of
                Ok sound ->
                    ( model
                    , Task.perform (PlaySoundGotTime name opt sound) Time.now
                    , Audio.cmdNone
                    )

                Err _ ->
                    ( model
                    , alert ("Failed to load audio " ++ name)
                    , Audio.cmdNone
                    )

        PlaySoundGotTime name opt sound t ->
            ( { model | audiorepo = loadAudio model.audiorepo name sound opt t }, Cmd.none, Audio.cmdNone )

        NewWindowSize t ->
            let
                ( gw, gh ) =
                    maxHandW t

                ( fl, ft ) =
                    getStartPoint t

                newgd =
                    { gd | browserViewPort = t, realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }
            in
            ( { model | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )

        MouseMove ( px, py ) ->
            let
                mp =
                    fromMouseToVirtual gd ( px, py )
            in
            ( { model | currentGlobalData = { gd | mousePos = mp } }, Cmd.none, Audio.cmdNone )

        RealMouseDown e pos ->
            let
                vp =
                    fromMouseToVirtual model.currentGlobalData pos
            in
            gameUpdate (MouseDown e vp) model

        RealMouseUp pos ->
            let
                vp =
                    fromMouseToVirtual model.currentGlobalData pos
            in
            gameUpdate (MouseUp vp) model

        KeyDown 112 ->
            if debug then
                -- F1
                ( model, prompt { name = "load", title = "Enter the scene you want to load" }, Audio.cmdNone )

            else
                gameUpdate msg model

        KeyDown 113 ->
            if debug then
                -- F2
                ( model, prompt { name = "setVolume", title = "Set volume (0-1)" }, Audio.cmdNone )

            else
                gameUpdate msg model

        Prompt "load" result ->
            if existScene result then
                ( loadSceneByName msg model result NullSceneInitData
                    |> resetSceneStartTime
                , Cmd.none
                , Audio.cmdNone
                )

            else
                ( model, alert "Scene not found!", Audio.cmdNone )

        Prompt "setVolume" result ->
            let
                vol =
                    String.toFloat result
            in
            case vol of
                Just v ->
                    let
                        ls =
                            gd.localStorage

                        newGd =
                            { gd | localStorage = { ls | volume = v } }
                    in
                    ( { model | currentGlobalData = newGd }, Cmd.none, Audio.cmdNone )

                Nothing ->
                    ( model, alert "Not a number", Audio.cmdNone )

        Tick x ->
            let
                newGD =
                    { gd | currentTimeStamp = x }
            in
            gameUpdate msg { model | currentGlobalData = newGD }

        _ ->
            gameUpdate msg model


{-| subscriptions
DO NOT EDIT THIS UNLESS YOU KNOW WHAT YOU ARE DOING.

Subscriptions are event listeners.

These are common event listeners that are commonly used in most games.

-}
subscriptions : AudioData -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch
        [ Time.every timeInterval Tick --- Slow down the fps
        , onKeyDown (Decode.map (\x -> KeyDown x) (Decode.field "keyCode" Decode.int))
        , onKeyUp (Decode.map (\x -> KeyUp x) (Decode.field "keyCode" Decode.int))
        , onResize (\w h -> NewWindowSize ( w, h ))
        , onMouseDown (Decode.map3 (\b x y -> RealMouseDown b ( x, y )) (Decode.field "button" Decode.int) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , onMouseUp (Decode.map2 (\x y -> RealMouseUp ( x, y )) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , onMouseMove (Decode.map2 (\x y -> MouseMove ( x, y )) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , promptReceiver (\p -> Prompt p.name p.result)
        ]


{-| view
DO NOT EDIT THIS UNLESS YOU KNOW WHAT YOU ARE DOING.

Canvas viewer
You can change the mouse style here.

-}
view : AudioData -> Model -> Html Msg
view _ model =
    let
        canvas =
            Canvas.toHtmlWith
                { width = model.currentGlobalData.realWidth
                , height = model.currentGlobalData.realHeight
                , textures = getTexture
                }
                [ style "left" (String.fromFloat model.currentGlobalData.startLeft)
                , style "top" (String.fromFloat model.currentGlobalData.startTop)
                , style "position" "fixed"
                ]
                [ MainConfig.background model.currentGlobalData
                , (getCurrentScene model).view { msg = NullMsg, t = model.time, globalData = model.currentGlobalData } model.currentData
                ]
    in
    Html.div []
        (case model.currentGlobalData.extraHTML of
            Just x ->
                [ canvas, x ]

            Nothing ->
                [ canvas ]
        )
