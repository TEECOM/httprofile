module Main exposing (Model, init)

import Browser
import Html exposing (Html, h1, text)
import Html.Attributes exposing (class)



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init =
    always ( {}, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    h1 [ class "text-2xl font-bold" ] [ text "Hello World!!" ]



-- MESSAGE


type Msg
    = NoOp



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
