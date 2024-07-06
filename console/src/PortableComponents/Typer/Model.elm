module PortableComponents.Typer.Model exposing (..)

import Canvas exposing (empty)
import Maybe exposing (withDefault)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.PortableComponent exposing (ConcretePortableComponent, PortableComponentInit, PortableComponentUpdate, PortableComponentUpdateRec, PortableComponentView)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import PortableComponents.Typer.History exposing (History(..), hisBack, hisGet, hisNext, hisStore)
import Set


type Target
    = OtherC
    | Me


type Msg
    = Init (Maybe History)
    | Written
    | Text ( String, Int )
    | Log History
    | Clear
    | NullMsg


type alias Data =
    { history : ( History, Bool )
    , text : String
    , pointer : Int
    , written : Bool
    , isCaps : Bool
    }


init : PortableComponentInit userdata Msg Data
init _ msg =
    case msg of
        Init (Just his) ->
            { history = ( his, False )
            , text = ""
            , pointer = 0
            , written = False
            , isCaps = False
            }

        _ ->
            { history = ( Empty, False )
            , text = ""
            , pointer = 0
            , written = False
            , isCaps = False
            }


update : PortableComponentUpdate Data userdata Target Msg scenemsg
update env event data =
    if data.written then
        case event of
            KeyDown 20 ->
                --capslock
                ( { data | isCaps = not data.isCaps }, [], ( env, False ) )

            KeyDown 38 ->
                --arrowup
                case data.history of
                    ( his, hmode ) ->
                        if hmode then
                            case hisGet <| hisBack his of
                                Just backt ->
                                    let
                                        npointer =
                                            String.length backt
                                    in
                                    ( { data | text = backt, pointer = npointer, history = ( hisBack his, True ) }, [ Parent <| OtherMsg <| Text ( backt, npointer ) ], ( env, False ) )

                                Nothing ->
                                    ( data, [], ( env, False ) )

                        else
                            let
                                ntext =
                                    withDefault "" <| hisGet his

                                npointer =
                                    String.length ntext
                            in
                            ( { data | text = ntext, pointer = npointer, history = ( his, True ) }, [ Parent <| OtherMsg <| Text ( ntext, npointer ) ], ( env, False ) )

            KeyDown 40 ->
                --arrowdown
                case data.history of
                    ( his, hmode ) ->
                        case hisGet <| hisNext his of
                            Just nextt ->
                                let
                                    npointer =
                                        String.length nextt
                                in
                                ( { data | text = nextt, pointer = npointer, history = ( hisNext his, True ) }, [ Parent <| OtherMsg <| Text ( nextt, npointer ) ], ( env, False ) )

                            Nothing ->
                                if hmode then
                                    ( { data | text = "", pointer = 0, history = ( his, False ) }, [ Parent <| OtherMsg <| Text ( "", 0 ) ], ( env, False ) )

                                else
                                    ( data, [], ( env, False ) )

            KeyDown 37 ->
                --arrowleft
                let
                    npointer =
                        max 0 (data.pointer - 1)
                in
                ( { data | pointer = npointer }, [ Parent <| OtherMsg <| Text ( data.text, npointer ) ], ( env, False ) )

            KeyDown 39 ->
                --arrowright
                let
                    npointer =
                        min (String.length data.text) (data.pointer + 1)
                in
                ( { data | pointer = npointer }, [ Parent <| OtherMsg <| Text ( data.text, npointer ) ], ( env, False ) )

            KeyDown 8 ->
                --backspace
                let
                    ntext =
                        String.left (data.pointer - 1) data.text ++ String.dropLeft data.pointer data.text

                    npointer =
                        max 0 (data.pointer - 1)
                in
                ( { data | text = ntext, pointer = npointer, history = ( Tuple.first data.history, False ) }, [ Parent <| OtherMsg <| Text ( ntext, npointer ) ], ( env, False ) )

            KeyDown 13 ->
                --enter
                let
                    nhis =
                        hisStore data.text <| Tuple.first data.history
                in
                ( { data | text = "", pointer = 0, history = ( nhis, False ) }, [ Parent <| OtherMsg <| Text ( "", 0 ), Parent <| OtherMsg <| Log nhis ], ( env, False ) )

            KeyDown x ->
                if isCharacter x then
                    let
                        newchar =
                            if xor data.isCaps <| Set.member 16 env.globalData.pressedKeys then
                                Char.toUpper <| Char.fromCode x

                            else
                                Char.toLower <| Char.fromCode x

                        ntext =
                            String.left data.pointer data.text ++ String.fromChar newchar ++ String.dropLeft data.pointer data.text

                        npointer =
                            data.pointer + 1
                    in
                    ( { data | text = ntext, pointer = npointer, history = ( Tuple.first data.history, False ) }, [ Parent <| OtherMsg <| Text ( ntext, npointer ) ], ( env, False ) )

                else
                    ( data, [], ( env, False ) )

            _ ->
                ( data, [], ( env, False ) )

    else
        ( data, [], ( env, False ) )


isCharacter : Int -> Bool
isCharacter x =
    if x >= 65 && x <= 90 then
        -- a-z
        True

    else if x >= 48 && x <= 57 then
        -- 0-9
        True

    else if x == 32 then
        -- Space
        True

    else
        False


updaterec : PortableComponentUpdateRec Data userdata Target Msg scenemsg
updaterec env msg data =
    case msg of
        Written ->
            ( { data | written = not data.written, text = "" }, [], env )

        Clear ->
            ( { data | history = ( Empty, False ) }, [], env )

        _ ->
            ( data, [], env )


view : PortableComponentView userdata Data
view _ _ =
    empty


matcher : Matcher Data Target
matcher _ tar =
    tar == Me


componentcon : ConcretePortableComponent Data userdata Target Msg scenemsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }
