module Main exposing (Model, init)

import Browser
import Header
import Html exposing (Html, a, b, div, header, input, main_, option, p, select, span, text)
import Html.Attributes exposing (class, href, placeholder, src, type_, value)
import Html.Events exposing (on, onInput)
import Http
import Json.Decode as Decode
import Response exposing (Response)
import Svg exposing (circle, path, svg)
import Svg.Attributes exposing (cx, cy, d, r, viewBox)
import Verbs


type Header
    = Header String String



-- MODEL


type alias Model =
    { verb : Verbs.Verb
    , url : String
    , header : Header.Header
    , response : Response
    }


init : () -> ( Model, Cmd Msg )
init =
    always
        ( { verb = Verbs.Get
          , url = ""
          , header = Header.Header "" ""
          , response = Response "HTTP/1.1" "200 OK" (Header.Header "" "") "bodytext" "50ms" "50ms" "50ms" "50ms" "50ms" "50ms" "50ms" "50ms" "50ms" "50ms"
          }
        , Cmd.none
        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.map never viewHeader
        , viewMain model
        ]


viewHeader : Html Never
viewHeader =
    header [ class "flex items-center justify-between max-w-3xl mx-auto py-6" ]
        [ a [ href "/", class "flex items-center" ]
            [ Html.map never (viewLogo "fill-current h-6")
            , span [ class "text-xl font-bold tracking-wide px-2" ] [ text "HTTProfile" ]
            ]
        , div [ class "font-semibold text-gray-500" ]
            [ a [ href "#", class "pl-3 hover:text-gray-300" ] [ text "API" ]
            , a [ href "#", class "pl-3 hover:text-gray-300" ] [ text "About" ]
            ]
        ]


viewMain : Model -> Html Msg
viewMain model =
    Html.main_
        [ class "max-w-3xl mx-auto pt-10" ]
        [ div [ class "flex items-center" ]
            [ viewVerbSelect
            , viewInput "https://httprofile.io" ChangedURL
            ]
        , div [ class "flex items-center my-2" ]
            [ input
                [ type_ "text"
                , placeholder "Content-Type"
                , class "bg-gray-800 rounded border-2 border-transparent py-3 px-4 w-1/4 appearance-none focus:outline-none focus:border-gray-700"
                , onInput ChangedHeaderKey
                ]
                []
            , input
                [ type_ "text"
                , placeholder "application/json"
                , class "bg-gray-800 rounded border-2 border-transparent ml-2 py-3 px-4 w-full appearance-none focus:outline-none focus:border-gray-700"
                , onInput ChangedHeaderValue
                ]
                []
            , Html.map never (viewPlusButton "fill-current text-gray-600 h-8 ml-3 hover:text-gray-500")
            ]
        , div []
            [ div [ class "my-2" ]
                [ p []
                    [ span [ class "text-yellow-400" ] [ text model.response.protocol ]
                    , span [ class "text-blue-500" ] [ text model.response.status ]
                    ]
                , p []
                    [ span [] [ text "Body: " ]
                    , span [ class "text-blue-500" ] [ text model.response.body ]
                    ]
                ]
            , div [ class "text-5xl text-green-500" ] [ text model.response.totalRequestTime ]
            , div [ class "my-2 flex" ]
                [ viewStep "DNS Lookup" model.response.dnsDuration
                , viewStep "TCP Connection" model.response.tcpConnectionDuration
                , viewStep "SSL Handshake" model.response.tlsHandshakeDuration
                , viewStep "Server Processing" model.response.serverProcessingDuration
                , viewStep "Content Transfer" model.response.contentTransferDuration
                ]
            , div [ class "my-2 mx-auto w-1/2 flex" ]
                [ viewStep "namelookup" model.response.timeToNameLookup
                , viewStep "connect" model.response.timeToConnect
                , viewStep "pretransfer" model.response.timeToPreTransfer
                , viewStep "starttransfer" model.response.timeToStartTransfer
                ]
            ]
        ]


viewStep : String -> String -> Html Msg
viewStep step duration =
    div [ class "m-2 p-2 bg-gray-600 text-sm text-center first:ml-0 last:mr-0 flex-1" ]
        [ p [] [ text step ]
        , b [ class (viewStepColor (String.dropRight 2 duration)) ] [ text duration ]
        ]


viewStepColor : String -> String
viewStepColor duration =
    if Maybe.withDefault 0 (String.toInt duration) < 100 then
        "text-green-400"

    else if Maybe.withDefault 0 (String.toInt duration) < 300 then
        "text-orange-400"

    else
        "text-red-400"


viewVerbSelect : Html Msg
viewVerbSelect =
    div [ class "inline-block relative" ]
        [ select
            [ class "bg-gray-800 border-2 border-gray-700 px-4 py-3 pr-8 rounded block appearance-none focus:outline-none focus:border-gray-600"
            , on "change" (Decode.map ChangedVerb Verbs.targetValueDecoder)
            ]
            (List.map viewVerbOption Verbs.all)
        , div [ class "pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-600" ]
            [ Html.map never <| viewDownIcon "fill-current h-4 w-4" ]
        ]


viewVerbOption : Verbs.Verb -> Html msg
viewVerbOption v =
    option [ value <| Verbs.toString v ] [ text <| Verbs.toString v ]


viewLogo : String -> Html Never
viewLogo classes =
    svg
        [ viewBox "0 0 20 20", Svg.Attributes.class classes ]
        [ path [ d "M10 20a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm-5.6-4.29a9.95 9.95 0 0 1 11.2 0 8 8 0 1 0-11.2 0zm6.12-7.64l3.02-3.02 1.41 1.41-3.02 3.02a2 2 0 1 1-1.41-1.41z" ] [] ]


viewDownIcon : String -> Html Never
viewDownIcon classes =
    svg
        [ viewBox "0 0 20 20", Svg.Attributes.class classes ]
        [ path [ d "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" ] [] ]


viewPlusButton : String -> Html Never
viewPlusButton classes =
    svg
        [ viewBox "0 0 24 24", Svg.Attributes.class classes ]
        [ circle [ cx "12", cy "12", r "10" ] []
        , path [ d "M13 11h4a1 1 0 0 1 0 2h-4v4a1 1 0 0 1-2 0v-4H7a1 1 0 0 1 0-2h4V7a1 1 0 0 1 2 0v4z", Svg.Attributes.class "text-gray-900" ] []
        ]


viewInput : String -> (String -> msg) -> Html msg
viewInput p msg =
    input
        [ type_ "text"
        , placeholder p
        , class "bg-gray-800 rounded border-2 border-transparent ml-2 py-3 px-4 w-full appearance-none focus:outline-none focus:border-gray-700"
        , onInput msg
        ]
        []



-- MESSAGE


type Msg
    = ChangedURL String
    | ChangedVerb Verbs.Verb
    | ChangedHeaderKey String
    | ChangedHeaderValue String



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedVerb verb ->
            ( { model | verb = verb }, Cmd.none )

        ChangedURL url ->
            ( { model | url = url }, Cmd.none )

        ChangedHeaderKey key ->
            let
                (Header.Header _ value) =
                    model.header
            in
            ( { model | header = Header.Header key value }, Cmd.none )

        ChangedHeaderValue value ->
            let
                (Header.Header key _) =
                    model.header
            in
            ( { model | header = Header.Header key value }, Cmd.none )



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
