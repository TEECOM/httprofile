module Main exposing (Model, init)

import Browser
import Header exposing (Header)
import Html exposing (Html, a, div, header, input, main_, option, select, span, text)
import Html.Attributes exposing (class, href, placeholder, src, type_, value)
import Html.Events exposing (on, onClick, onInput)
import Icon
import Json.Decode as Decode
import List.Extra exposing (mapOnly, positionedMap, removeAt)
import Verb



-- MODEL


type alias Model =
    { verb : Verb.Verb
    , url : String
    , headers : List Header
    }


init : () -> ( Model, Cmd Msg )
init =
    always
        ( { verb = Verb.Get
          , url = ""
          , headers = [ Header.empty ]
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
        , text "Hi!"
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



-- MESSAGE


type Msg
    = ChangedURL String
    | ChangedVerb Verb.Verb
    | ChangedHeaderKey Int String
    | ChangedHeaderValue Int String
    | ClickedRemoveHeader Int
    | ClickedAddHeader



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



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
