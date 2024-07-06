module PortableComponents.Typer.History exposing (History(..), hisBack, hisFromList, hisGet, hisInit, hisNext, hisStore, hisToList)


type History
    = Empty
    | Roll
        { text : String
        , back : () -> History
        , next : () -> History
        }


hisRec : Maybe String -> Maybe String -> Maybe String -> History
hisRec lt t nt =
    case t of
        Nothing ->
            Empty

        Just txt ->
            Roll
                { text = txt
                , back = \_ -> hisRec Nothing lt t
                , next = \_ -> hisRec t nt Nothing
                }


hisInit : String -> History
hisInit str =
    hisRec Nothing (Just str) Nothing


hisMake : String -> { text : String, back : () -> History, next : () -> History } -> History
hisMake str h =
    let
        makerec : History -> { text : String, back : () -> History, next : () -> History } -> History
        makerec tar hh =
            case hh.back () of
                Empty ->
                    Roll { hh | next = \_ -> tar, back = \_ -> Empty }

                Roll hhh ->
                    Roll { hh | next = \_ -> tar, back = \_ -> makerec (makerec tar hh) hhh }
    in
    Roll
        { text = str
        , back = \_ -> makerec (hisMake str h) h
        , next = \_ -> Empty
        }


hisStore : String -> History -> History
hisStore str his =
    case his of
        Empty ->
            hisInit str

        Roll h ->
            if h.next () == Empty then
                hisMake str h

            else
                hisStore str <| h.next ()


hisToList : History -> List String
hisToList his =
    let
        hisToListHelper : History -> List String -> List String
        hisToListHelper h ls =
            case hisGet h of
                Nothing ->
                    ls

                Just txt ->
                    hisToListHelper (hisBack h) (txt :: ls)
    in
    hisToListHelper his []


hisFromList : List String -> History
hisFromList ls =
    List.foldl hisStore Empty ls


hisGet : History -> Maybe String
hisGet his =
    case his of
        Empty ->
            Nothing

        Roll h ->
            Just h.text


hisBack : History -> History
hisBack his =
    case his of
        Empty ->
            Empty

        Roll h ->
            h.back ()


hisNext : History -> History
hisNext his =
    case his of
        Empty ->
            Empty

        Roll h ->
            h.next ()
