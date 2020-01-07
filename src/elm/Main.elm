module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Page
import Page.About
import Page.Api
import Page.Home
import Page.NotFound
import Route
import Url



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | Home Page.Home.Model
    | Api Page.Api.Model
    | About Page.About.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    changeToPage (Route.fromUrl url)
        { key = key, page = NotFound }



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            Page.view never Page.NotFound.view

        Home home ->
            Page.view GotHomeMsg (Page.Home.view home)

        Api api ->
            Page.view GotApiMsg (Page.Api.view api)

        About about ->
            Page.view GotAboutMsg (Page.About.view about)



-- MESSAGE


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | GotHomeMsg Page.Home.Msg
    | GotApiMsg Page.Api.Msg
    | GotAboutMsg Page.About.Msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        ( ChangedUrl url, _ ) ->
            changeToPage (Route.fromUrl url) model

        ( GotHomeMsg subMsg, Home home ) ->
            Page.Home.update subMsg home |> mapToHome model

        ( GotApiMsg subMsg, Api api ) ->
            Page.Api.update subMsg api |> mapToApi model

        ( GotAboutMsg subMsg, About about ) ->
            Page.About.update subMsg about |> mapToAbout model

        _ ->
            ( model, Cmd.none )


changeToPage : Maybe Route.Route -> Model -> ( Model, Cmd Msg )
changeToPage maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Home ->
            Page.Home.init |> mapToHome model

        Just Route.Api ->
            Page.Api.init |> mapToApi model

        Just Route.About ->
            Page.About.init |> mapToAbout model


mapToHome : Model -> ( Page.Home.Model, Cmd Page.Home.Msg ) -> ( Model, Cmd Msg )
mapToHome model ( subModel, subCmd ) =
    ( { model | page = Home subModel }, Cmd.map GotHomeMsg subCmd )


mapToApi : Model -> ( Page.Api.Model, Cmd Page.Api.Msg ) -> ( Model, Cmd Msg )
mapToApi model ( subModel, subCmd ) =
    ( { model | page = Api subModel }, Cmd.map GotApiMsg subCmd )


mapToAbout : Model -> ( Page.About.Model, Cmd Page.About.Msg ) -> ( Model, Cmd Msg )
mapToAbout model ( subModel, subCmd ) =
    ( { model | page = About subModel }, Cmd.map GotAboutMsg subCmd )



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
