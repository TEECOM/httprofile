port module Page.Home exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Browser.Events
import Duration
import Header exposing (Header)
import Html exposing (Html, button, div, form, input, li, option, select, span, text, textarea, ul)
import Html.Attributes exposing (autofocus, class, placeholder, selected, type_, value)
import Html.Events exposing (on, onClick, onInput, onSubmit)
import Http
import Icon
import Json.Decode as Decode
import Keyboard
import List.Extra exposing (mapOnly, positionedMap, removeAt)
import Profile
import Profile.Report as Report
import Status
import Verb



-- PORTS


port blurActive : () -> Cmd msg



-- MODEL


type Status
    = NotRequested
    | Loading
    | Loaded Report.Report
    | Failed Http.Error


type Visibility
    = Visible
    | Hidden


type alias Model =
    { verb : Verb.Verb
    , url : String
    , headers : List Header
    , body : String
    , report : Status
    , bodyVisibility : Visibility
    }


init : ( Model, Cmd Msg )
init =
    ( { verb = Verb.Get
      , url = ""
      , headers = [ Header.empty ]
      , body = ""
      , report = NotRequested
      , bodyVisibility = Hidden
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "HTTP Response Profiler"
    , body =
        [ form [ onSubmit RequestedProfile ]
            [ div [ class "flex items-center" ]
                [ viewVerbSelect model.verb
                , input
                    [ type_ "text"
                    , placeholder "https://httprofile.io"
                    , class "bg-gray-800 rounded border-2 border-transparent ml-2 py-3 px-4 w-full appearance-none focus:outline-none focus:border-gray-700"
                    , onInput ChangedURL
                    , value model.url
                    , autofocus True
                    ]
                    []
                ]
            , div [ class "py-2" ] (positionedMap viewHeaderInput model.headers)
            , div [ class "py-2" ]
                [ textarea
                    [ placeholder "{ \"request\": \"body\" }"
                    , class "scroll-dark bg-gray-800 rounded border-2 border-transparent py-3 px-4 w-full h-40 appearance-none focus:outline-none focus:border-gray-700"
                    , onInput ChangedBody
                    , value model.body
                    ]
                    []
                ]
            , div [ class "py-2 flex items-center justify-end" ]
                [ case model.report of
                    Loading ->
                        div [ class "spin w-8 h-8 mr-4" ] []

                    _ ->
                        text ""
                , button
                    [ class "font-semibold text-gray-400 bg-transparent rounded border-2 border-gray-400 py-2 px-4 hover:bg-gray-400 hover:text-gray-900 hover:border-transparent focus:outline-none focus:border-gray-700"
                    , type_ "submit"
                    ]
                    [ text "Run Profile" ]
                ]
            ]
        , div [ class "my-10" ] [ viewReport model.report model.bodyVisibility ]
        ]
    }


viewVerbSelect : Verb.Verb -> Html Msg
viewVerbSelect modelVerb =
    div [ class "inline-block relative" ]
        [ select
            [ class "bg-gray-800 border-2 border-gray-700 px-4 py-3 pr-8 rounded block appearance-none focus:outline-none focus:border-gray-600"
            , on "change" (Decode.map ChangedVerb Verb.targetValueDecoder)
            ]
            (List.map (viewVerbOption modelVerb) Verb.all)
        , div [ class "pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-600" ]
            [ Html.map never Icon.downCarrot ]
        ]


viewVerbOption : Verb.Verb -> Verb.Verb -> Html msg
viewVerbOption modelVerb verb =
    option [ value <| Verb.toString verb, selected (modelVerb == verb) ] [ text <| Verb.toString verb ]


viewHeaderInput : List.Extra.Position -> Header -> Html Msg
viewHeaderInput (List.Extra.Position idx lastIdx) header =
    let
        action =
            if idx == lastIdx then
                button [ class "ml-2 text-gray-600 hover:text-gray-500", type_ "button", onClick ClickedAddHeader ] [ Html.map never Icon.plus ]

            else
                button [ class "ml-2 text-gray-600 hover:text-gray-500", type_ "button", onClick <| ClickedRemoveHeader idx ] [ Html.map never Icon.minus ]
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


viewReport : Status -> Visibility -> Html Msg
viewReport status bodyVisibility =
    case status of
        Loaded report ->
            div []
                [ div [ class "text-2xl" ]
                    [ span [ class "text-gray-400" ] [ text "Total Request Time: " ]
                    , span [ class "font-semibold text-teal-500" ]
                        [ Html.map never <| viewDuration report.aggregateTimeline.totalRequestTime ]
                    ]
                , viewDiscreteTimeline report.discreteTimeline
                , viewAggregateTimeline report.aggregateTimeline
                , div [ class "flex items-center pt-12" ]
                    [ span [ class "text-lg text-teal-500" ] [ text report.protocol ]
                    , Html.map never (viewStatus report.status)
                    ]
                , ul [ class "py-2" ] <| List.map viewReportHeader report.headers
                , viewReportBody bodyVisibility report.body
                ]

        _ ->
            div [] []


viewDiscreteTimeline : Report.DiscreteTimeline -> Html msg
viewDiscreteTimeline t =
    div [ class "py-4 flex text-sm" ]
        [ div [ class "rounded bg-gray-800 px-2 py-3 w-full text-center" ]
            [ span [ class "block text-gray-300" ] [ text "DNS Lookup" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.dnsLookupDuration ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "TCP Connection" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.tcpConnectionDuration ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "SSL Handshake" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.tlsHandshakeDuration ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "Server Processing" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.serverProcessingDuration ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "Content Transfer" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.contentTransferDuration ]
            ]
        ]


viewAggregateTimeline : Report.AggregateTimeline -> Html msg
viewAggregateTimeline t =
    div [ class "py-4 flex mx-auto w-4/5 text-sm" ]
        [ div [ class "rounded bg-gray-800 px-2 py-2 w-full text-center" ]
            [ span [ class "block text-gray-300" ] [ text "Name Lookup" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.timeToNameLookup ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "Connect" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.timeToConnect ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "Pre-Transfer" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.timeToPreTransfer ]
            ]
        , div [ class "rounded bg-gray-800 px-2 py-2 text-center w-full ml-2" ]
            [ span [ class "block text-gray-300" ] [ text "Start Transfer" ]
            , span [ class "block font-semibold text-teal-500 text-lg pt-2" ] [ Html.map never <| viewDuration t.timeToStartTransfer ]
            ]
        ]


viewDuration : Duration.Duration -> Html Never
viewDuration d =
    d
        |> Duration.inMilliseconds
        |> (round >> String.fromInt)
        |> (\s -> s ++ "ms")
        |> text


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


viewReportBody : Visibility -> String -> Html Msg
viewReportBody visibility body =
    let
        toggleText =
            case visibility of
                Visible ->
                    "hide body"

                Hidden ->
                    "show body"

        bodyClass =
            case visibility of
                Visible ->
                    ""

                Hidden ->
                    "hidden"
    in
    div [ class "text-md text-gray-400" ]
        [ span [ class "text-lg" ] [ text "Body: " ]
        , span [ class "text-teal-500" ]
            [ text "[ "
            , button [ class "cursor-pointer border-b border-teal-500", onClick ClickedBodyVisibilityToggle ] [ text toggleText ]
            , text " ]"
            ]
        , div
            [ class <| "mt-2 scroll-dark text-md h-64 border-2 border-gray-700 rounded py-2 px-2 overflow-auto font-mono " ++ bodyClass
            ]
            [ text body ]
        ]



-- MESSAGE


type Msg
    = ChangedURL String
    | ChangedVerb Verb.Verb
    | ChangedHeaderKey Int String
    | ChangedHeaderValue Int String
    | ClickedRemoveHeader Int
    | ClickedAddHeader
    | ChangedBody String
    | RequestedProfile
    | CompletedProfile (Result Http.Error Report.Report)
    | ClickedBodyVisibilityToggle



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

        RequestedProfile ->
            ( { model | report = Loading, bodyVisibility = Hidden }
            , Cmd.batch
                [ blurActive ()
                , Profile.run CompletedProfile
                    { verb = model.verb
                    , url = model.url
                    , headers = List.filter (not << Header.isEmpty) model.headers
                    , body = model.body
                    }
                ]
            )

        CompletedProfile (Err error) ->
            ( { model | report = Failed error }, Cmd.none )

        CompletedProfile (Ok report) ->
            ( { model | report = Loaded report }, Cmd.none )

        ClickedBodyVisibilityToggle ->
            let
                toggled =
                    case model.bodyVisibility of
                        Visible ->
                            Hidden

                        Hidden ->
                            Visible
            in
            ( { model | bodyVisibility = toggled }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Keyboard.decoder shortcuts
        |> Browser.Events.onKeyPress


shortcuts : Keyboard.Event -> Keyboard.Command Msg
shortcuts event =
    case event of
        Keyboard.Event "INPUT" _ _ ->
            Keyboard.Unrecognized

        Keyboard.Event _ "Enter" [ Keyboard.Meta ] ->
            Keyboard.Recognized RequestedProfile

        Keyboard.Event "TEXTAREA" _ _ ->
            Keyboard.Unrecognized

        Keyboard.Event _ "b" _ ->
            Keyboard.Recognized ClickedBodyVisibilityToggle

        _ ->
            Keyboard.Unrecognized
