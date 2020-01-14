module Page.About exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (class, href, target)
import Route



-- MODEL


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view _ =
    { title = "About"
    , body =
        [ div [ class "text-lg leading-relaxed" ]
            [ p [ class "" ]
                [ text "HTTProfile is a side project of TEECOM's research and development group, "
                , viewLink [ href "https://labs.teecom.com" ] [ text "TEECOMlabs" ]
                , text ". We started work on HTTProfile in December of 2019, heavily inspired by the awesome "
                , viewLink [ href "https://github.com/reorx/httpstat" ] [ text "httpstat" ]
                , text "."
                ]
            , p [ class "mt-6" ]
                [ text "This site was built using a language we love, "
                , viewLink [ href "https://elm-lang.org" ] [ text "Elm" ]
                , text ". It was styled with "
                , viewLink [ href "https://tailwindcss.com" ] [ text "Tailwind" ]
                , text ", complimented by Steve Schoger's beautifully design icon set, "
                , viewLink [ href "https://www.zondicons.com" ] [ text "Zondicons" ]
                , text ", and visually inspired by Derrick Reimer's "
                , viewLink [ href "https://statickit.com" ] [ text "StaticKit" ]
                , text ". The backing API was written in "
                , viewLink [ href "https://golang.org" ] [ text "Go" ]
                , text ", guided by Dave Cheney's implementation of "
                , viewLink [ href "https://github.com/davecheney/httpstat" ] [ text "httpstat" ]
                , text "."
                ]
            ]
        ]
    }


viewLink : List (Html.Attribute msg) -> List (Html msg) -> Html msg
viewLink attributes =
    a ([ target "_blank", class "font-bold border-b border-1 text-gray-300 hover:text-gray-100" ] ++ attributes)



-- MESSAGE


type alias Msg =
    ()



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none
