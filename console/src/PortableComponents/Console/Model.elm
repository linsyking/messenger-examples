module PortableComponents.Console.Model exposing (..)

import Canvas exposing (empty, group, shapes)
import Canvas.Settings.Advanced exposing (alpha)
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.Component exposing (AbstractComponent, updateComponents, updateComponentsWithTarget)
import Messenger.Component.PortableComponent exposing (ConcretePortableComponent, PortableComponentInit, PortableComponentUpdate, PortableComponentUpdateRec, PortableComponentView)
import Messenger.GeneralModel exposing (Matcher, Msg(..), MsgBase(..))
import Messenger.Render.Shape exposing (rect)
import Messenger.Render.Text exposing (renderText)
import Messenger.Scene.Scene exposing (MMsg, MMsgBase)
import PortableComponents.Console.Base exposing (Msg(..), Target(..))
import PortableComponents.Console.Typer exposing (component)


type alias Data userdata =
    { hidden : Bool
    , text : String
    , pointer : Int
    , typer : AbstractComponent () userdata Target Msg () ()
    }


init : PortableComponentInit userdata Msg (Data userdata)
init env msg =
    case msg of
        Init his ->
            { hidden = True
            , text = ""
            , pointer = 0
            , typer = component (TyperInit <| Just his) env
            }

        _ ->
            { hidden = True
            , text = ""
            , pointer = 0
            , typer = component (TyperInit Nothing) env
            }


handleTyperMsg : MMsgBase Msg () userdata -> Data userdata -> ( Data userdata, List (MMsg Target Msg scenemsg userdata) )
handleTyperMsg typermsg data =
    case typermsg of
        OtherMsg (TyperText ( txt, pointer )) ->
            ( { data | text = txt, pointer = pointer }, [] )

        OtherMsg (TyperLog his) ->
            ( data, [ Parent <| OtherMsg <| Log his ] )

        _ ->
            ( data, [] )


update : PortableComponentUpdate (Data userdata) userdata Target Msg scenemsg
update env event data =
    case event of
        KeyDown k ->
            let
                totyper : List (AbstractComponent () userdata Target Msg () ()) -> AbstractComponent () userdata Target Msg () ()
                totyper tls =
                    Maybe.withDefault (component (TyperInit Nothing) env) <| List.head tls

                ( ntyper, typermsg, _ ) =
                    updateComponents env event [ data.typer ]

                ( ndata, nmsgs ) =
                    (\( d, m ) -> ( { d | typer = totyper ntyper }, m )) <|
                        List.foldl
                            (\cm ( d, m ) ->
                                let
                                    ( d2, m2 ) =
                                        handleTyperMsg cm d
                                in
                                ( d2, m ++ m2 )
                            )
                            ( data, [] )
                            typermsg
            in
            case k of
                17 ->
                    --ctrl
                    let
                        ( wtyper, _, _ ) =
                            updateComponentsWithTarget env [ ( Typer, TyperWritten ) ] [ data.typer ]
                    in
                    ( { data | hidden = not data.hidden, text = "", pointer = 0, typer = totyper wtyper }, [], ( env, False ) )

                13 ->
                    --enter
                    ( ndata, nmsgs ++ [ Parent <| OtherMsg <| Output data.text ], ( env, False ) )

                _ ->
                    ( ndata, [], ( env, False ) )

        _ ->
            ( data, [], ( env, False ) )


updaterec : PortableComponentUpdateRec (Data userdata) userdata Target Msg scenemsg
updaterec env msg data =
    case msg of
        TyperClear ->
            let
                ( ctyper, _, _ ) =
                    updateComponentsWithTarget env [ ( Typer, TyperClear ) ] [ data.typer ]
            in
            ( { data | typer = Maybe.withDefault (component (TyperInit Nothing) env) <| List.head ctyper }, [], env )

        _ ->
            ( data, [], env )


view : PortableComponentView userdata (Data userdata)
view env data =
    if data.hidden then
        empty

    else
        group []
            [ shapes [ alpha 0.1 ] [ rect env.globalData.internalData ( 20, 970 ) ( 1850, 40 ) ]
            , renderText env.globalData.internalData 30 ("> " ++ String.left data.pointer data.text ++ "_" ++ String.dropLeft data.pointer data.text) "sans-seif" ( 30, 975 )
            ]


matcher : Matcher (Data userdata) Target
matcher _ tar =
    tar == Me


componentcon : ConcretePortableComponent (Data userdata) userdata Target Msg scenemsg
componentcon =
    { init = init
    , update = update
    , updaterec = updaterec
    , view = view
    , matcher = matcher
    }
