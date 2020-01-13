module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, button, div, h3, kbd, li, span, text, ul)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Icon
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
    , showingKeyboardShortcutInfo : Bool
    }


type Page
    = NotFound
    | Home Page.Home.Model
    | Api Page.Api.Model
    | About Page.About.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    changeToPage (Route.fromUrl url)
        { key = key
        , page = NotFound
        , showingKeyboardShortcutInfo = False
        }



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        { title, body } =
            viewPage model.page
    in
    { title = title
    , body = body ++ [ viewKeyboardShortcutInfo model.showingKeyboardShortcutInfo ]
    }


viewPage : Page -> Browser.Document Msg
viewPage page =
    case page of
        NotFound ->
            Page.view never Page.NotFound.view

        Home home ->
            Page.view GotHomeMsg (Page.Home.view home)

        Api api ->
            Page.view GotApiMsg (Page.Api.view api)

        About about ->
            Page.view GotAboutMsg (Page.About.view about)


viewKeyboardShortcutInfo : Bool -> Html Msg
viewKeyboardShortcutInfo showingKeyboardShortcutInfo =
    div [ class "fixed bottom-0 left-0 ml-6 mb-4" ]
        [ div
            [ class "transition-ease w-84 bg-gray-500 rounded ml-3 mb-3 text-gray-900 py-3 px-4"
            , classList
                [ ( "opacity-100 transform-shift-up", showingKeyboardShortcutInfo )
                , ( "opacity-0 invisible", not showingKeyboardShortcutInfo )
                ]
            ]
            [ h3 [ class "font-bold mb-3" ] [ text "Keyboard Shortcuts" ]
            , ul []
                [ li [ class "flex justify-between py-2" ]
                    [ span [] [ text "Run profile" ]
                    , span []
                        [ kbd [ class "py-1 px-2 bg-gray-800 text-gray-100 rounded mx-1" ]
                            [ text "Cmd" ]
                        , span [] [ text "+" ]
                        , kbd [ class "py-1 px-2 bg-gray-800 text-gray-100 rounded mx-1" ] [ text "Enter" ]
                        ]
                    ]
                , li [ class "flex justify-between py-2" ]
                    [ span [] [ text "Show / hide body" ]
                    , span []
                        [ kbd [ class "py-1 px-2 bg-gray-800 text-gray-100 rounded mx-1" ]
                            [ text "b" ]
                        ]
                    ]
                ]
            ]
        , button
            [ class "text-gray-600 hover:text-gray-500 hover:bg-gray-800 p-3 rounded-full"
            , onClick ToggledKeyboardShortcutInfo
            ]
            [ Html.map never Icon.keyboard ]
        ]



-- MESSAGE


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | ToggledKeyboardShortcutInfo
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

        ( ToggledKeyboardShortcutInfo, _ ) ->
            ( { model | showingKeyboardShortcutInfo = not model.showingKeyboardShortcutInfo }
            , Cmd.none
            )

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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        NotFound ->
            Sub.none

        Home home ->
            Sub.map GotHomeMsg (Page.Home.subscriptions home)

        Api api ->
            Sub.map GotApiMsg (Page.Api.subscriptions api)

        About about ->
            Sub.map GotAboutMsg (Page.About.subscriptions about)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
