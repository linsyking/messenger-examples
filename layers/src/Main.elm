module Main exposing (main)

{-| This is the main module which is the main entry of the whole game

@docs main

-}

import Audio exposing (AudioCmd, AudioData)
import Base exposing (Flags, Msg(..))
import Browser.Events exposing (onKeyDown, onKeyUp, onMouseDown, onMouseMove, onResize)
import Canvas
import Common exposing (Model, audio, initGlobalData, resetSceneStartTime, updateSceneStartTime)
import Dict
import Html exposing (Html)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Lib.Audio.Audio exposing (audioPortFromJS, audioPortToJS, loadAudio, stopAudio)
import Lib.Coordinate.Coordinates exposing (fromMouseToReal, getStartPoint, maxHandW)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.LocalStorage.LocalStorage exposing (decodeLSInfo, encodeLSInfo, sendInfo)
import Lib.Resources.Base exposing (allTexture, getTexture, saveSprite)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Lib.Scene.SceneLoader exposing (getCurrentScene, loadSceneByName)
import Lib.Tools.Browser exposing (alert)
import MainConfig exposing (initScene, timeInterval)
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
            loadSceneByName UnknownMsg initModel initScene NullSceneInitData

        oldgd =
            ms.currentGlobalData

        ( gw, gh ) =
            maxHandW ( flags.windowWidth, flags.windowHeight )

        ( fl, ft ) =
            getStartPoint ( flags.windowWidth, flags.windowHeight )

        ls =
            decodeLSInfo flags.info

        -- Update volume in globaldata
        newgd =
            { oldgd | localstorage = ls, audioVolume = ls.volume, browserViewPort = ( flags.windowWidth, flags.windowHeight ), realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }
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
            ( sdt, som, newenv ) =
                (getCurrentScene model).update { msg = msg, globalData = model.currentGlobalData, t = model.time } model.currentData

            newgd =
                newenv.globalData

            timeUpdatedModel =
                case msg of
                    Tick _ ->
                        -- Tick event needs to update time
                        { model | time = model.time + 1, currentGlobalData = newgd }

                    _ ->
                        { model | currentGlobalData = newgd }

            newModel =
                { timeUpdatedModel | currentData = sdt }

            ( newmodel, cmds, audiocmds ) =
                if List.isEmpty som then
                    ( updateSceneStartTime newModel, [ sendInfo (encodeLSInfo timeUpdatedModel.currentGlobalData.localstorage) ], [] )

                else
                    List.foldl
                        (\singleSOM ( lastModel, lastCmds, lastAudioCmds ) ->
                            case singleSOM of
                                SOMChangeScene ( tm, s ) ->
                                    --- Load new scene
                                    ( loadSceneByName msg lastModel s tm
                                        |> resetSceneStartTime
                                    , lastCmds ++ [ sendInfo (encodeLSInfo lastModel.currentGlobalData.localstorage) ]
                                    , lastAudioCmds
                                    )

                                SOMPlayAudio name path opt ->
                                    ( lastModel, lastCmds, lastAudioCmds ++ [ Audio.loadAudio (SoundLoaded name opt) path ] )

                                SOMSetVolume s ->
                                    let
                                        oldgd =
                                            lastModel.currentGlobalData

                                        newgd2 =
                                            { oldgd | audioVolume = s }
                                    in
                                    ( { lastModel | currentGlobalData = newgd2 }, lastCmds, lastAudioCmds )

                                SOMStopAudio name ->
                                    ( { lastModel | audiorepo = stopAudio lastModel.audiorepo name }, lastCmds, lastAudioCmds )

                                SOMAlert text ->
                                    ( lastModel, lastCmds ++ [ alert text ], lastAudioCmds )
                        )
                        ( newModel, [], [] )
                        som
        in
        ( newmodel, Cmd.batch cmds, Audio.cmdBatch audiocmds )


{-| update
DO NOT EDIT THIS UNLESS YOU KNOW WHAT YOU ARE DOING.
This is the update function of the whole game.
You may want to change `gameUpdate` rather than this function.
-}
update : AudioData -> Msg -> Model -> ( Model, Cmd Msg, AudioCmd Msg )
update _ msg model =
    case msg of
        TextureLoaded name Nothing ->
            ( model, alert ("Failed to load sprite " ++ name), Audio.cmdNone )

        TextureLoaded name (Just t) ->
            let
                oldgd =
                    model.currentGlobalData

                newgd =
                    { oldgd | sprites = saveSprite model.currentGlobalData.sprites name t }
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
                oldgd =
                    model.currentGlobalData

                ( gw, gh ) =
                    maxHandW t

                ( fl, ft ) =
                    getStartPoint t

                newgd =
                    { oldgd | browserViewPort = t, realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }
            in
            ( { model | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )

        MouseMove ( px, py ) ->
            let
                curgd =
                    model.currentGlobalData

                mp =
                    fromMouseToReal curgd ( toFloat px, toFloat py )
            in
            ( { model | currentGlobalData = { curgd | mousePos = mp } }, Cmd.none, Audio.cmdNone )

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
        , onMouseDown (Decode.map3 (\b x y -> MouseDown b ( x, y )) (Decode.field "button" Decode.int) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , onMouseMove (Decode.map2 (\x y -> MouseMove ( x, y )) (Decode.field "clientX" Decode.int) (Decode.field "clientY" Decode.int))
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
                , (getCurrentScene model).view { msg = UnknownMsg, t = model.time, globalData = model.currentGlobalData } model.currentData
                ]
    in
    Html.div []
        (case model.currentGlobalData.extraHTML of
            Just x ->
                [ canvas, x ]

            Nothing ->
                [ canvas ]
        )
