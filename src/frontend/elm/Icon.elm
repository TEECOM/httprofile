module Icon exposing (bolt, downCarrot, heart, keyboard, logo, minus, plus)

import Html exposing (Html)
import Svg exposing (circle, path, rect, svg)
import Svg.Attributes exposing (class, cx, cy, d, height, r, rx, viewBox, width, x, y)


logo : Html Never
logo =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-6" ]
        [ path [ d "M10 20a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm-5.6-4.29a9.95 9.95 0 0 1 11.2 0 8 8 0 1 0-11.2 0zm6.12-7.64l3.02-3.02 1.41 1.41-3.02 3.02a2 2 0 1 1-1.41-1.41z" ] [] ]


downCarrot : Html Never
downCarrot =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-4 w-4" ]
        [ path [ d "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" ] [] ]


plus : Html Never
plus =
    svg
        [ viewBox "0 0 24 24", class "fill-current h-6" ]
        [ circle [ cx "12", cy "12", r "10" ] []
        , path [ d "M13 11h4a1 1 0 0 1 0 2h-4v4a1 1 0 0 1-2 0v-4H7a1 1 0 0 1 0-2h4V7a1 1 0 0 1 2 0v4z", class "fill-current text-gray-900" ] []
        ]


minus : Html Never
minus =
    svg
        [ viewBox "0 0 24 24", class "fill-current h-6" ]
        [ circle [ cx "12", cy "12", r "10" ] []
        , rect [ width "12", height "2", x "6", y "11", rx "1", class "fill-current text-gray-900" ] []
        ]


heart : Html Never
heart =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-4 hover:text-red-700" ]
        [ path [ d "M10 3.22l-.61-.6a5.5 5.5 0 0 0-7.78 7.77L10 18.78l8.39-8.4a5.5 5.5 0 0 0-7.78-7.77l-.61.61z" ] [] ]


bolt : Html Never
bolt =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-4 hover:text-yellow-500" ]
        [ path [ d "M13 8V0L8.11 5.87 3 12h4v8L17 8h-4z" ] [] ]


keyboard : Html Never
keyboard =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-6" ]
        [ path [ d "M0 6c0-1.1.9-2 2-2h16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6zm2 0v2h2V6H2zm1 3v2h2V9H3zm-1 3v2h2v-2H2zm3 0v2h10v-2H5zm11 0v2h2v-2h-2zM6 9v2h2V9H6zm3 0v2h2V9H9zm3 0v2h2V9h-2zm3 0v2h2V9h-2zM5 6v2h2V6H5zm3 0v2h2V6H8zm3 0v2h2V6h-2zm3 0v2h4V6h-4z" ] [] ]
