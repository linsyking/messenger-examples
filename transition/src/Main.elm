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
import Lib.Resources.Base exposing (getTexture, saveSprite)
import Lib.Resources.SpriteSheets exposing (allSpriteSheets)
import Lib.Resources.Sprites exposing (allTexture)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Lib.Scene.Loader exposing (existScene, getCurrentScene, loadSceneByName)
import Lib.Scene.Transition exposing (makeTransition)
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
    , transition = Nothing
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

        oldIT =
            initGlobalData.internalData

        newIT =
            { oldIT
                | browserViewPort = ( flags.windowWidth, flags.windowHeight )
                , realWidth = gw
                , realHeight = gh
                , startLeft = fl
                , startTop = ft
            }

        newgd =
            { initGlobalData | currentTimeStamp = Time.millisToPosix flags.timeStamp, localStorage = ls, internalData = newIT }
    in
    ( { ms | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )


{-| This is the update function for updating the model.

If you add some SceneOutputMsg, you have to add corresponding updating logic here.

-}
gameUpdate : Msg -> Model -> ( Model, Cmd Msg, AudioCmd Msg )
gameUpdate msg model =
    if List.length (Dict.keys model.currentGlobalData.internalData.sprites) < List.length allTexture then
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

            timeUpdatedModel =
                case msg of
                    Tick _ ->
                        -- Tick event needs to update time
                        { model | time = model.time + 1, currentGlobalData = newGD1 }

                    _ ->
                        { model | currentGlobalData = newGD1 }

            newModel =
                updateSceneStartTime { timeUpdatedModel | currentData = sdt }

            ( newmodel, cmds, audiocmds ) =
                List.foldl
                    (\singleSOM ( lastModel, lastCmds, lastAudioCmds ) ->
                        case singleSOM of
                            SOMChangeScene ( tm, s, Nothing ) ->
                                --- Load new scene
                                ( loadSceneByName msg lastModel s tm
                                    |> resetSceneStartTime
                                , lastCmds
                                , lastAudioCmds
                                )

                            SOMChangeScene ( tm, s, Just trans ) ->
                                --- Delayed Loading
                                ( { lastModel | transition = Just ( trans, ( s, tm ) ) }
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

            newmodel2 =
                case newmodel.transition of
                    Just ( trans, ( d, n ) ) ->
                        if trans.currentTransition == trans.outT then
                            loadSceneByName msg newmodel d n
                                |> resetSceneStartTime

                        else
                            newmodel

                    Nothing ->
                        newmodel
        in
        ( newmodel2
        , Cmd.batch <|
            if newmodel2.currentGlobalData.localStorage /= oldLocalStorage then
                -- Save local storage
                sendInfo (encodeLSInfo newmodel2.currentGlobalData.localStorage) :: cmds

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

                                        oldIT =
                                            lastgd.internalData

                                        newIT =
                                            { oldIT | sprites = saveSprite oldIT.sprites (name ++ "." ++ n) newTexture }
                                    in
                                    { lastgd | internalData = newIT }
                                )
                                gd
                                sprites

                        Nothing ->
                            let
                                oldIT =
                                    gd.internalData

                                newIT =
                                    { oldIT | sprites = saveSprite oldIT.sprites name t }
                            in
                            { gd | internalData = newIT }
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

                oldIT =
                    gd.internalData

                newIT =
                    { oldIT | browserViewPort = t, realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }

                newgd =
                    { gd | internalData = newIT }
            in
            ( { model | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )

        MouseMove ( px, py ) ->
            let
                mp =
                    fromMouseToVirtual gd ( px, py )
            in
            ( { model | currentGlobalData = { gd | mousePos = mp } }, Cmd.none, Audio.cmdNone )

        MouseDown e pos ->
            gameUpdate (MouseDown e <| fromMouseToVirtual model.currentGlobalData pos) model

        MouseUp pos ->
            gameUpdate (MouseUp <| fromMouseToVirtual model.currentGlobalData pos) model

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

                        newls =
                            { ls | volume = v }

                        newGd =
                            { gd | localStorage = newls }
                    in
                    ( { model | currentGlobalData = newGd }, sendInfo (encodeLSInfo newls), Audio.cmdNone )

                Nothing ->
                    ( model, alert "Not a number", Audio.cmdNone )

        Tick x ->
            let
                newGD =
                    { gd | currentTimeStamp = x }

                trans =
                    model.transition

                newTrans =
                    case trans of
                        Just ( data, sd ) ->
                            if data.currentTransition >= data.inT + data.outT then
                                Nothing

                            else
                                Just ( { data | currentTransition = data.currentTransition + 1 }, sd )

                        Nothing ->
                            trans
            in
            gameUpdate msg { model | currentGlobalData = newGD, transition = newTrans }

        NullMsg ->
            ( model, Cmd.none, Audio.cmdNone )

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
        , onKeyDown
            (Decode.map2
                (\x rep ->
                    if not rep then
                        KeyDown x

                    else
                        NullMsg
                )
                (Decode.field "keyCode" Decode.int)
                (Decode.field "repeat" Decode.bool)
            )
        , onKeyUp
            (Decode.map2
                (\x rep ->
                    if not rep then
                        KeyUp x

                    else
                        NullMsg
                )
                (Decode.field "keyCode" Decode.int)
                (Decode.field "repeat" Decode.bool)
            )
        , onResize (\w h -> NewWindowSize ( toFloat w, toFloat h ))
        , onMouseDown (Decode.map3 (\b x y -> MouseDown b ( x, y )) (Decode.field "button" Decode.int) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , onMouseUp (Decode.map2 (\x y -> MouseUp ( x, y )) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
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
        transitiondata =
            Maybe.map Tuple.first model.transition

        canvas =
            Canvas.toHtmlWith
                { width = floor model.currentGlobalData.internalData.realWidth
                , height = floor model.currentGlobalData.internalData.realHeight
                , textures = getTexture
                }
                [ style "left" (String.fromFloat model.currentGlobalData.internalData.startLeft)
                , style "top" (String.fromFloat model.currentGlobalData.internalData.startTop)
                , style "position" "fixed"
                ]
                [ MainConfig.background model.currentGlobalData
                , makeTransition model.currentGlobalData transitiondata <| (getCurrentScene model).view { msg = NullMsg, t = model.time, globalData = model.currentGlobalData } model.currentData
                ]
    in
    Html.div []
        (case model.currentGlobalData.extraHTML of
            Just x ->
                [ canvas, x ]

            Nothing ->
                [ canvas ]
        )
