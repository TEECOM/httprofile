module Page exposing (view)

import Browser
import Html exposing (Html, a, div, footer, header, main_, span, text)
import Html.Attributes exposing (class, href, target)
import Icon
import Route



-- VIEW


view : (a -> msg) -> Browser.Document a -> Browser.Document msg
view toMsg { title, body } =
    { title = title ++ " · HTTProfile"
    , body =
        [ Html.map never viewHeader
        , viewMain toMsg body
        , Html.map never viewFooter
        ]
    }


viewHeader : Html Never
viewHeader =
    header [ class "flex items-center justify-between max-w-3xl mx-auto py-6 px-3" ]
        [ a [ Route.href Route.Home, class "flex items-center" ]
            [ Html.map never Icon.logo
            , span [ class "text-xl font-bold tracking-wide px-2" ] [ text "HTTProfile" ]
            ]
        , div [ class "font-semibold text-gray-500" ]
            [ a [ Route.href Route.Api, class "pl-3 hover:text-gray-300" ] [ text "API" ]
            , a [ Route.href Route.About, class "pl-3 hover:text-gray-300" ] [ text "About" ]
            ]
        ]


viewMain : (a -> msg) -> List (Html a) -> Html msg
viewMain toMsg body =
    main_
        [ class "max-w-3xl mx-auto px-3 py-2 pt-12" ]
        (List.map (Html.map toMsg) body)


viewFooter : Html Never
viewFooter =
    footer []
        [ div [ class "flex items-center text-gray-600 justify-center pt-12 py-2" ]
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
        , div [ class "flex items-center text-gray-600 justify-center pb-4" ]
            [ span [ class "ml-3 mr-2" ] [ text "inspired" ]
            , Html.map never Icon.bulb
            , span [ class "ml-3" ] [ text "by" ]
            , a
                [ href "https://github.com/reorx/httpstat"
                , class "ml-1 border-b border-gray-800 hover:text-teecom-blue hover:border-teecom-blue"
                , target "_blank"
                ]
                [ text "httpstat" ]
            ]
        ]
