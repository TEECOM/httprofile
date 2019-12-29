module Main exposing (Model, init)

import Browser
import Html exposing (Html, a, div, header, input, main_, span, text)
import Html.Attributes exposing (class, href, placeholder, src, type_)
import Html.Events exposing (onInput)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, viewBox)



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init =
    always ( {}, Cmd.none )



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
        [ class "max-w-3xl mx-auto px-3 pt-10" ]
        [ viewInput "https://httprofile.io" ChangedURL
        , text "Hi!"
        ]


viewLogo : String -> Html Never
viewLogo classes =
    svg
        [ viewBox "0 0 20 20", Svg.Attributes.class classes ]
        [ path [ d "M10 20a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm-5.6-4.29a9.95 9.95 0 0 1 11.2 0 8 8 0 1 0-11.2 0zm6.12-7.64l3.02-3.02 1.41 1.41-3.02 3.02a2 2 0 1 1-1.41-1.41z" ] [] ]


viewInput : String -> (String -> msg) -> Html msg
viewInput p msg =
    input
        [ type_ "text"
        , placeholder p
        , class "bg-gray-800 rounded border-2 border-transparent py-3 px-4 w-full appearance-none focus:outline-none focus:border-gray-700"
        , onInput msg
        ]
        []



-- MESSAGE


type Msg
    = ChangedURL String



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
