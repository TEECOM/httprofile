module Main exposing (Model, init)

import Browser
import Duration
import Header exposing (Header)
import Html exposing (Html, a, button, div, footer, header, input, li, main_, option, select, span, text, textarea, ul)
import Html.Attributes exposing (class, href, placeholder, target, type_, value)
import Html.Events exposing (on, onClick, onInput)
import Http
import Icon
import Json.Decode as Decode
import List.Extra exposing (mapOnly, positionedMap, removeAt)
import Profile
import Profile.Report as Report
import Status
import Verb



-- MODEL


type Status
    = NotRequested
    | Loading
    | Loaded Report.Report
    | Failed Http.Error


type alias Model =
    { verb : Verb.Verb
    , url : String
    , headers : List Header
    , body : String
    , report : Status
    }


init : () -> ( Model, Cmd Msg )
init =
    always
        ( { verb = Verb.Get
          , url = ""
          , headers = [ Header.empty ]
          , body = ""
          , report = NotRequested
          }
        , Cmd.none
        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.map never viewHeader
        , viewMain model
        , Html.map never viewFooter
        ]


viewHeader : Html Never
viewHeader =
    header [ class "flex items-center justify-between max-w-3xl mx-auto py-6 px-3" ]
        [ a [ href "/", class "flex items-center" ]
            [ Html.map never Icon.logo
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
        [ class "max-w-3xl mx-auto px-3 pt-10 py-2" ]
        [ div [ class "flex items-center" ]
            [ viewVerbSelect
            , input
                [ type_ "text"
                , placeholder "https://httprofile.io"
                , class "bg-gray-800 rounded border-2 border-transparent ml-2 py-3 px-4 w-full appearance-none focus:outline-none focus:border-gray-700"
                , onInput ChangedURL
                ]
                []
            ]
        , div [ class "py-2" ] (positionedMap viewHeaderInput model.headers)
        , div [ class "py-2" ]
            [ textarea
                [ placeholder "{ \"request\": \"body\" }"
                , class "scroll-dark bg-gray-800 rounded border-2 border-transparent py-3 px-4 w-full h-40 appearance-none focus:outline-none focus:border-gray-700"
                , onInput ChangedBody
                ]
                []
            ]
        , div [ class "py-2 text-right" ]
            [ button
                [ class "font-semibold text-gray-400 bg-transparent rounded border-2 border-gray-400 py-2 px-4 hover:bg-gray-400 hover:text-gray-900 hover:border-transparent"
                , onClick ClickedRunButton
                ]
                [ text "Run Profile" ]
            ]
        , div [ class "my-10" ] [ viewReport model.report ]
        ]


viewFooter : Html Never
viewFooter =
    footer [ class "flex items-center text-gray-600 w-64 px-6 mx-auto mt-10" ]
        [ span [ class "mr-2" ] [ text "made with" ]
        , Html.map never Icon.heart
        , span [ class "ml-2" ] [ text "by" ]
        , a
            [ href "https://teecom.com"
            , class "ml-1 border-b border-gray-800 hover:text-teecom-blue hover:border-teecom-blue"
            , target "_blank"
            ]
            [ text "TEECOM" ]
        ]


viewVerbSelect : Html Msg
viewVerbSelect =
    div [ class "inline-block relative" ]
        [ select
            [ class "bg-gray-800 border-2 border-gray-700 px-4 py-3 pr-8 rounded block appearance-none focus:outline-none focus:border-gray-600"
            , on "change" (Decode.map ChangedVerb Verb.targetValueDecoder)
            ]
            (List.map viewVerbOption Verb.all)
        , div [ class "pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-600" ]
            [ Html.map never Icon.downCarrot ]
        ]


viewVerbOption : Verb.Verb -> Html msg
viewVerbOption v =
    option [ value <| Verb.toString v ] [ text <| Verb.toString v ]


viewHeaderInput : List.Extra.Position -> Header -> Html Msg
viewHeaderInput (List.Extra.Position idx lastIdx) header =
    let
        action =
            if idx == lastIdx then
                a [ class "ml-2 text-gray-600 hover:text-gray-500", onClick ClickedAddHeader ] [ Html.map never Icon.plus ]

            else
                a [ class "ml-2 text-gray-600 hover:text-gray-500", onClick <| ClickedRemoveHeader idx ] [ Html.map never Icon.minus ]
    in
    div [ class "flex items-center my-2" ]
        [ input
            [ type_ "text"
            , placeholder "Content-Type"
            , class "bg-gray-800 rounded border-2 border-transparent py-3 px-4 w-2/5 appearance-none focus:outline-none focus:border-gray-700"
            , onInput <| ChangedHeaderKey idx
            , value <| Header.key header
            ]
            []
        , input
            [ type_ "text"
            , placeholder "application/json"
            , class "bg-gray-800 rounded border-2 border-transparent ml-2 py-3 px-4 w-full appearance-none focus:outline-none focus:border-gray-700"
            , onInput <| ChangedHeaderValue idx
            , value <| Header.value header
            ]
            []
        , action
        ]


viewReport : Status -> Html Msg
viewReport status =
    case status of
        Loaded report ->
            div []
                [ div [ class "text-2xl" ]
                    [ span [ class "text-gray-400" ] [ text "Total Request Time: " ]
                    , span [ class "font-semibold text-teal-500" ]
                        [ Html.map never <| viewDuration report.aggregateTimeline.totalRequestTime ]
                    ]
                , div [ class "flex items-center pt-8" ]
                    [ span [ class "text-lg text-teal-500" ] [ text report.protocol ]
                    , Html.map never (viewStatus report.status)
                    ]
                , ul [ class "py-2" ] <| List.map viewReportHeader report.headers
                ]

        _ ->
            div [] []


viewStatus : Int -> Html Never
viewStatus code =
    let
        color =
            case Status.category code of
                Status.Informational ->
                    "teal-500"

                Status.Success ->
                    "green-500"

                Status.Redirection ->
                    "purple-500"

                Status.ClientError ->
                    "orange-500"

                Status.ServerError ->
                    "red-500"

                Status.Unknown ->
                    "gray-500"
    in
    span [ class <| "text-md text-" ++ color ++ " ml-2 border-2 border-" ++ color ++ " px-3 rounded-full" ]
        [ text <| String.fromInt code ++ " " ++ Status.text code ]


viewReportHeader : Header -> Html msg
viewReportHeader h =
    li []
        [ span [ class "text-gray-400" ] [ text (Header.key h ++ ": ") ]
        , span [ class "text-teal-500" ] [ text (Header.value h) ]
        ]


viewDuration : Duration.Duration -> Html Never
viewDuration d =
    d
        |> Duration.inMilliseconds
        |> (round >> String.fromInt)
        |> (\s -> s ++ "ms")
        |> text



-- MESSAGE


type Msg
    = ChangedURL String
    | ChangedVerb Verb.Verb
    | ChangedHeaderKey Int String
    | ChangedHeaderValue Int String
    | ClickedRemoveHeader Int
    | ClickedAddHeader
    | ChangedBody String
    | ClickedRunButton
    | CompletedProfile (Result Http.Error Report.Report)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedVerb verb ->
            ( { model | verb = verb }, Cmd.none )

        ChangedURL url ->
            ( { model | url = url }, Cmd.none )

        ChangedHeaderKey idx key ->
            let
                updateKey =
                    Header.mapKey (always key)
            in
            ( { model | headers = mapOnly idx updateKey model.headers }, Cmd.none )

        ChangedHeaderValue idx value ->
            let
                updateValue =
                    Header.mapValue (always value)
            in
            ( { model | headers = mapOnly idx updateValue model.headers }, Cmd.none )

        ClickedRemoveHeader idx ->
            ( { model | headers = removeAt idx model.headers }, Cmd.none )

        ClickedAddHeader ->
            ( { model | headers = model.headers ++ [ Header.empty ] }, Cmd.none )

        ChangedBody body ->
            ( { model | body = body }, Cmd.none )

        ClickedRunButton ->
            ( { model | report = Loading }
            , Profile.run CompletedProfile
                { verb = model.verb
                , url = model.url
                , headers = List.filter (not << Header.isEmpty) model.headers
                , body = model.body
                }
            )

        CompletedProfile (Err error) ->
            ( { model | report = Failed error }, Cmd.none )

        CompletedProfile (Ok report) ->
            ( { model | report = Loaded report }, Cmd.none )



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
