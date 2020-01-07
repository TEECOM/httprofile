module Page.Api exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (text)



-- MODEL


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view _ =
    { title = "Api"
    , body = [ text "API" ]
    }



-- MESSAGE


type alias Msg =
    ()



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )
