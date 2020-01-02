module Main exposing (Model, init)

import Browser
import Html exposing (Html, a, div, header, input, main_, option, select, span, text)
import Html.Attributes exposing (class, href, placeholder, src, type_, value)
import Html.Events exposing (on, onInput)
import Icon
import Json.Decode as Decode
import Verb



-- MODEL


type alias Model =
    { verb : Verb.Verb, url : String }


init : () -> ( Model, Cmd Msg )
init =
    always ( { verb = Verb.Get, url = "" }, Cmd.none )



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
        [ class "max-w-3xl mx-auto px-3 pt-10" ]
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



-- MESSAGE


type Msg
    = ChangedURL String
    | ChangedVerb Verb.Verb



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedVerb verb ->
            ( { model | verb = verb }, Cmd.none )

        ChangedURL url ->
            ( { model | url = url }, Cmd.none )



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
